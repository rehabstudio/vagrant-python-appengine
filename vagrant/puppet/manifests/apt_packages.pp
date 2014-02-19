# Adding extra PPA's for more up to date software.
class { 'apt': }
apt::ppa { 'ppa:git-core/ppa': }


# Installing other useful packages.
package { [
    'curl',
    'unzip',
    'zip',
    'git-core',
    'vim',
    'memcached',
    'python-dev',
    'python-imaging',
    'python-virtualenv',
    'virtualenvwrapper',
]:
    ensure => present,
    require => Apt::Ppa['ppa:git-core/ppa']
}
