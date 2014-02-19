# Add a custom bashrc for the vagrant user
file { 'Custom bashrc':
    ensure  => present,
    replace => true,
    path => '/home/vagrant/.bashrc',
    source  => '/vagrant/files/bashrc',
    mode    => '0644',
    owner    => 'vagrant';
}
