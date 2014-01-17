class other {
  
  package { [ 'vim',
              'lynx']:
    ensure => present;
  }

  file { 
    '/etc/motd':
      ensure  => present,
      replace => true,
      source  => 'puppet:///modules/other/welcome.txt';
  }

}
