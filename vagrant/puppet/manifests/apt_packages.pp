# Adding extra PPA's for more up to date software.
class { 'apt': }
apt::ppa { 'ppa:git-core/ppa': }

# Installing other useful packages.
package { [
    # latest stable git
    'git-core',
    # vim 'cos vim
    'vim',
    # in-memory cache
    'memcached',
    # because we need to uncompress things
    'unzip',
    'zip',
    # python development dependencies
    # we only install a minimal set of packages, anything else can be
    # installed inside a virtualenv as required on the box
    'python-dev',
    'python-virtualenv',
    'virtualenvwrapper',
    # we'll make an exception for PIL and install it globally from apt because
    # it's the simplest way to make it work nicely with the appengine sdk
    # NOTE: this is futile in versions of ubuntu after 12.04, in that case
    # install Pillow in a virtualenv instead.
    'python-imaging',
]:
    ensure => present,
    require => Apt::Ppa['ppa:git-core/ppa']
}

# install the build dependencies for both PIL and mysqldb, this allows both to
# be easily built inside a virtualenv when required
apt::builddep { 'python-imaging': }
apt::builddep { 'python-mysqldb': }
