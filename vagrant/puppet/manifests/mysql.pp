# Import base configuration from YAML file
$mysql_ymlconfig = loadyaml('/vagrant/config.yml')

# Database configuration.
$databaseName = $mysql_ymlconfig['database']['name']
$databaseUser = $mysql_ymlconfig['database']['user']
$databasePass = $mysql_ymlconfig['database']['pass']
$vagrantPrivateIP = $mysql_ymlconfig['env']['ip']


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
