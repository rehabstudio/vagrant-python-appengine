# Adding a global exec statement so we don't have to add paths to every one.
Exec {
    path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin']
}

include other
include nginx
include php
include mysql