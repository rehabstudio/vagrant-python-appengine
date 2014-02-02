# Vagrant / Global configuration.
$vagrantPrivateIP = '192.168.33.10'
$vagrantDomain = 'rehab.vagrant.local'

# Nginx configuration.
$siteRoot = '/var/www/app'
$errorLog = '/var/logs/app/error.log'
$accessLog = '/var/logs/app/access.log'

# Database configuration.
$databaseName = 'your-database-name'
$databaseUser = 'projectuser'
$databasePass = '6LG621D15l37Yzv'
$databaseFile = '/vagrant/files/db_schema.sql'

# PHP configuration.
$phpIniSettings = [
    "set PHP/short_open_tag Off",
    "set PHP/expose_php Off",
    "set PHP/display_errors On",
    "set PHP/html_errors On",
    "set PHP/post_max_size 128M",
    "set PHP/upload_max_filesize 128M",
    "set Date/date.timezone Europe/Belfast"
]

# Adding a global exec statement so we don't have to add paths to every one.
Exec {
    path => ['/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin']
}

# Adding extra PPA's for more up to date software.
class { 'apt': }
apt::ppa { 'ppa:git-core/ppa': }

# Installing MySQL server and updating the root users password.
class { '::mysql::server':
    root_password => 'root',
    restart => true,
    override_options => {
        'mysqld' => {
            'bind-address' => $vagrantPrivateIP
        }
    }
}

# Adding project database schema to the MySQL database.
mysql::db { $databaseName:
    grant    => ['ALL'],
    user     => $databaseUser,
    password => $databasePass,
    sql      => $databaseFile,
    require => Class['mysql::server']
}

# Ensuring the user is added as a wildcard.
mysql_user { "${databaseUser}@%":
    password_hash => mysql_password("${databasePass}"),
    require => Class['mysql::server']
}

# Ensuring the users privileges are correct.
mysql_grant { "${databaseUser}@%/${databaseName}":
    ensure => 'present',
    options => ['GRANT'],
    privileges => ['ALL'],
    table => '*.*',
    user => "${databaseUser}@%",
    require => Class['mysql::server']
}

# Including necessary classes for installing PHP.
include php
include php::composer
include php::fpm::daemon

# Installing FPM and PEAR separately as they have extra functionality.
class {
    'php::fpm':
        ensure => installed,
        settings => {
            set => {
            }
        };
    'php::pear':
        ensure => installed;
}

# Installing PHP Extensions.
php::extension { 'php-extensions':
    ensure => installed,
    package => [
        'php5-cli', 'php5-curl', 'php5-dev',
        'php5-gd', 'php5-imagick', 'php5-mcrypt',
        'php5-mysql', 'php5-pspell', 'php5-xdebug',
        'php5-xmlrpc', 'php5-tidy', 'php5-xsl'
    ],
    notify => Service['php5-fpm'];
}

# Installing PHPUnit via Pear.
package { 'pear.phpunit.de/PHPUnit':
    ensure   => present,
    provider => pear,
    require  => [Package['php-pear'], Exec['php::pear::auto_discover']];
}

# Updating particular settings in the ini file without doing a file overwrite.
augeas { 'php.ini':
    notify => Service['php5-fpm'],
    require => [Package['libaugeas-ruby'], Package['augeas-tools'], Package['php5-fpm']],
    context => '/files/etc/php5/fpm/php.ini',
    changes => $phpIniSettings
}

# Installing nginx package and setting up its conf file.
class { 'nginx':
    server_tokens => 'off',
    nginx_error_log => $errorLog,
    http_access_log => $accessLog;
}

# Adding a vhost file for the project.
nginx::resource::vhost { $vagrantDomain:
    www_root => $siteRoot,
    error_log => $errorLog,
    access_log => $accessLog,
    index_files => ['index.php', 'index.html'],
    try_files => ['$uri', '$uri/', '/index.php?$args'];
}

# Pushing all PHP files to FastCGI Process Manager (php5-fpm).
nginx::resource::location { "${vagrantDomain} php files":
    vhost => $vagrantDomain,
    www_root => $siteRoot,
    fastcgi => '127.0.0.1:9000',
    location => '~ \.php$',
    location_cfg_append => {
        fastcgi_param => 'APPLICATION_ENV local',
        fastcgi_index => 'index.php'
    },
    notify => Class['nginx::service'];
}

# Ensuring the www-data user is part of the vagrant group so files can be modified.
user { 'www-data':
    groups => ['vagrant'],
    notify => Class['nginx::service']
}

# Installing other useful packages.
package { [
    'curl',
    'unzip',
    'zip',
    'git-core',
    'vim',
    'libaugeas-ruby',
    'augeas-tools'
]:
    ensure => present,
    require => Apt::Ppa['ppa:git-core/ppa']
}

# Applying a custom sign-in message for the box.
file { 'Custom Sign-in Message':
    ensure  => present,
    replace => true,
    path => '/etc/motd',
    source  => '/vagrant/files/welcome.txt';
}