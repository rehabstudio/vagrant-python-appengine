# install the appengine sdk inside /opt
archive { 'google_appengine_sdk':
    ensure => present,
    url => 'http://googleappengine.googlecode.com/files/google_appengine_1.8.9.zip',
    target => '/opt',
    follow_redirects => true,
    extension => 'zip',
    checksum => false,
    src_target => '/tmp',
    require => Package['unzip']
}

# ensure the sdk install directory is on the system path
file_line { 'appengine path':
    ensure => present,
    path   => '/etc/bash.bashrc',
    line   => 'export PATH="$PATH:/opt/google_appengine"',
}

# add a handy alias so users can run the sdk with sensible defaults
file_line { 'appengine alias':
    ensure => present,
    path   => '/etc/bash.bashrc',
    line   => 'alias runserver="dev_appserver.py /home/vagrant/app --host 0.0.0.0 --admin_host 0.0.0.0 --storage_path /home/vagrant/storage --skip_sdk_update_check"',
}
