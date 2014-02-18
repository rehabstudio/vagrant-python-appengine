echo -e "\e[1;33m[REHAB-BOX]: Before Puppet Shell. Executing.\e[0m";


# fetch the puppet release deb for precise
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
# install the deb once downloaded
sudo dpkg -i puppetlabs-release-precise.deb

# install required packages
sudo apt-get -qq update --fix-missing
sudo apt-get install git puppet --assume-yes

# install librarian-puppet gem from rubygems
sudo gem install librarian-puppet

# install all module dependencies
cd /vagrant/puppet/
librarian-puppet install
