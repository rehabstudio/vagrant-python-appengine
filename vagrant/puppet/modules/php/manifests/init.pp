class php {

    $modules = [
        'php5',
        'php5-cli',
        'php5-curl',
        'php5-dev',
        'php5-fpm',
        'php5-gd',
        'php5-imagick',
        'php5-mcrypt',
        'php5-mysql',
        'php5-pspell',
        'php5-tidy',
        'php5-xdebug',
        'php5-xmlrpc',
        'php5-xsl',
        'php-pear'
    ]

    package { $modules:
        ensure => present;
    }

    service { 'php5-fpm':
        ensure  => running,
        require => Package['php5-fpm'];
    }

    exec { 'phpunit-install':
        command => "pear upgrade PEAR && \
                    pear config-set auto_discover 1 && \
                    pear install --alldeps pear.phpunit.de/PHPUnit",
        creates => '/usr/bin/phpunit',
        require => Package['php-pear'];
    }

    class { 'composer':
        require => [Package['php5'], Package['curl'], Package['git-core']];
    }

    # Updating particular settings in the ini file without doing a file overwrite.
    augeas { 'php.ini':
        notify => [Service['php5-fpm'], Service['nginx']],
        require => [Package['libaugeas-ruby'], Package['augeas-tools'], Package['php5']],
        context => '/files/etc/php5/fpm/php.ini',
        changes => [
            "set PHP/short_open_tag Off",
            "set PHP/expose_php Off",
            "set PHP/display_errors On",
            "set PHP/html_errors On",
            "set PHP/post_max_size 128M",
            "set PHP/upload_max_filesize 128M",
            "set Date/date.timezone Europe/Belfast"
        ]
    }

}