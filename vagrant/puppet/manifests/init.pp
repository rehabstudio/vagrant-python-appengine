include 'stdlib'


# import our sub-manifests (because a big monolithic manifest is ugly and
# harder to maintain)
import 'appengine.pp'
import 'apt_packages.pp'
import 'bashrc.pp'
import 'motd.pp'
import 'nodejs.pp'
import 'rubygems.pp'


# Adding a global exec statement so we don't have to add paths to every one.
Exec {
    path => ['/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin']
}
