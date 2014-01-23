class other {

    $modules = [
        'curl',
        'git-core',
        'vim',
        'lynx'
    ]

    package { $modules:
        ensure => present;
    }

    file { '/etc/motd':
        ensure  => present,
        replace => true,
        source  => 'puppet:///modules/other/welcome.txt';
    }

}