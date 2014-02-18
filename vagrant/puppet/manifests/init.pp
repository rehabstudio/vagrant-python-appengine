include 'stdlib'

# Import base configuration from YAML file
$ymlconfig = loadyaml('/vagrant/config.yml')

# Vagrant / Global configuration.
$vagrantPrivateIP = $ymlconfig['env']['ip']
$vagrantDomain = $ymlconfig['env']['domain']

# Database configuration.
$databaseName = $ymlconfig['database']['name']
$databaseUser = $ymlconfig['database']['user']
$databasePass = $ymlconfig['database']['pass']

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

# Installing other useful packages.
package { [
    'curl',
    'unzip',
    'zip',
    'git-core',
    'vim',
    'memcached',
    'python-dev',
    'python-imaging',
    'python-virtualenv',
    'virtualenvwrapper',
]:
    ensure => present,
    require => Apt::Ppa['ppa:git-core/ppa']
}

# Installing ruby gems.
package { [
    'sass',
    'compass'
]:
    ensure => 'installed',
    provider => 'gem'
}

# Installing node library.
class { 'nodejs':
    manage_repo => true
}

# Installing node executables.
package { [
    'grunt-cli',
    'bower'
]:
    ensure => present,
    provider => 'npm',
    require => Class['nodejs']
}

# Installing node dependencies.
exec { 'Installing Node Packages':
    cwd => $siteRoot,
    command => 'npm install',
    require => Class['nodejs'],
    onlyif => "test -f ${siteRoot}/package.json"
}

# Applying a custom sign-in message for the box.
file { 'Custom Sign-in Message':
    ensure  => present,
    replace => true,
    path => '/etc/motd',
    source  => '/vagrant/files/welcome.txt';
}

# Add a custom bashrc for the vagrant user
file { 'Custom bashrc':
    ensure  => present,
    replace => true,
    path => '/home/vagrant/.bashrc',
    source  => '/vagrant/files/bashrc',
    mode    => '0644',
    owner    => 'vagrant';
}

archive { 'google_appengine_sdk':
   ensure => present,
   url => 'http://googleappengine.googlecode.com/files/google_appengine_1.8.9.zip',
   target => '/opt',
   follow_redirects => true,
   extension => 'zip',
   checksum => false,
   src_target => '/tmp'
}
