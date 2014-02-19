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
    cwd => "/home/vagrant/app",
    command => 'npm install',
    require => Class['nodejs'],
    onlyif => "test -f /home/vagrant/app/package.json"
}
