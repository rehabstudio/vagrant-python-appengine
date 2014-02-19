# install the appengine sdk inside /opt
archive { 'google_appengine_sdk':
   ensure => present,
   url => 'http://googleappengine.googlecode.com/files/google_appengine_1.8.9.zip',
   target => '/opt',
   follow_redirects => true,
   extension => 'zip',
   checksum => false,
   src_target => '/tmp'
}
