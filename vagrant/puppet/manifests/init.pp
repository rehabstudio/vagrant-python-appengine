# Project specific settings.
$databaseName = 'your-database-name'
$databaseUser = 'projectuser'
$databasePass = '6LG621D15l37Yzv'
$databaseFile = '/vagrant/schema/db.sql'

# Adding a global exec statement so we don't have to add paths to every one.
Exec {
    path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin']
}

# Installing MySQL server and updating the root users password.
class { '::mysql::server':
    root_password => 'root',
    restart => true,
    override_options => {
        'mysqld' => {
            'bind-address' => '192.168.33.10'
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
    require => [ Class['mysql::server'] ]
}

# Ensuring the users privileges are correct.
mysql_grant { "${databaseUser}@%/${databaseName}":
    ensure => 'present',
    options => ['GRANT'],
    privileges => ['ALL'],
    table => '*.*',
    user => "${databaseUser}@%",
    require => [ Class['mysql::server'] ]
}

include other
include nginx
include php