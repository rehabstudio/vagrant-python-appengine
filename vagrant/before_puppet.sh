#!/bin/bash
echo -e "\e[1;33m[REHAB-BOX]: Before Puppet Shell. Executing.\e[0m";


if [ ! -f /root/puppetlabs-release-precise.deb ]; then
    echo 'Installing Puppet apt repository'
    cd /root/
    # fetch the puppet release deb for precise
    wget --quiet https://apt.puppetlabs.com/puppetlabs-release-precise.deb
    # install the deb once downloaded
    dpkg -i puppetlabs-release-precise.deb
fi


if [ ! -f /etc/puppet/hiera.yaml ]; then
    echo 'Ensuring hiera configuration file exists'
    # Hiera is a key/value lookup tool for configuration data. We don't
    # actually use it but puppet'll throw an error if this file doesn't exist
    # at provision time
    touch /etc/puppet/hiera.yaml
fi


# install required packages
echo "Updating/Installing required packages"
sudo apt-get -qq update --fix-missing
sudo apt-get -qq install git puppet --assume-yes


if [ -z `which librarian-puppet` ]; then
    echo "Installing librarian-puppet from rubygems"
    # install librarian-puppet gem from rubygems
    sudo gem install librarian-puppet
fi

# install/update puppet module dependencies
echo "Installing puppet module dependencies with librarian-puppet"
cd /vagrant/puppet/
librarian-puppet install
