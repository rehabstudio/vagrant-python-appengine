# Applying a custom sign-in message for the box.
file { 'Custom Sign-in Message':
    ensure  => present,
    replace => true,
    path => '/etc/motd',
    source  => '/vagrant/files/welcome.txt';
}
