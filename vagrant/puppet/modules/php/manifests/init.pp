class php {

  package { ['php5',
             'php5-cli',
             'php5-fpm',
             'php-apc',
             'php5-curl',
             'php5-dev',
             'php5-gd',
             'php5-imagick',
             'php5-mcrypt',
             'php5-memcache',
             'php5-mysql',
             'php5-pspell',
             'php5-tidy',
             'php5-xdebug',
             'php5-xmlrpc',
             'php5-xsl']:
    ensure => present;
  }

}
