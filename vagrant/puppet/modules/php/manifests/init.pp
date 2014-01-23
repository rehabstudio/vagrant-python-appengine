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

    exec { 'phpunit-install':
        command => "pear upgrade PEAR && \
                    pear config-set auto_discover 1 && \
                    pear install --alldeps pear.phpunit.de/PHPUnit",
        creates => '/usr/bin/phpunit',
        require => Package['php-pear'];
    }

    exec { 'composer-install':
        command => "curl -sS https://getcomposer.org/installer | php && \
                    mv composer.phar /usr/local/bin/composer",
        creates => '/usr/local/bin/composer',
        require => [Package['php5'], Package['git-core']]
    }

}