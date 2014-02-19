# Installing ruby gems.
package { [
    'sass',
    'compass'
]:
    ensure => 'installed',
    provider => 'gem'
}

