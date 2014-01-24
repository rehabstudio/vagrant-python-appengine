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
    root_password => 'root';
}

# Adding project database schema to the MySQL database.
mysql::db { $databaseName:
    grant    => ['ALL'],
    user     => $databaseUser,
    password => $databasePass,
    sql      => $databaseFile
}

include other
include nginx
include php