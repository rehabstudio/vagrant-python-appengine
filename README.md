PHP/NGINX/MySQL VAGRANT BOX
===========================

Simple vagrant build for a general php/mysql setup on nginx. This will boot up an nginx/php/mysql ubuntu box for a single instance. It uses host manager for easy local DNS configuration. 

Requirements
------------

- Virtualbox 4.2
- Vagrant 1.4
- [Vagrant Hostmanager Plugin](https://github.com/smdahlen/vagrant-hostmanager)
- Ruby 1.9.3
- Bundler 1.3.5
- Puppet

Install
-------

1. cd vagrant && vagrant up
2. go to http://rehab.vagrant.local/

Customize
---------

You can install additional software quite simply, by using the following steps.
- Create a folder in the /vagrant/puppet/modules/ directory for your package, eg. 'mysql'
- Create two folders inside that folder called 'files' and 'manifests'
- In the new manifests folder create a file called 'init.pp' and enter the puppet manifest appropriately, eg.
```
class mysql {
    package { [
            (..LIST ALL PACKAGES HERE..)
        ]:
        ensure => present;
    }
    (..ANY OTHER PUPPET COMMANDS..)
}
```
- The 'files' folder should be used for any files that you are using in your manifests. These can be referenced inside your manifest file by using the URI pattern: "puppet:///modules/mysql/my.cnf" (note that 'files/' is skipped in this uri)
- Once your module is complete you can call it from the main puppet manifests file (/puppet/manifests/init.pp) by using the syntax: 'include mysql'
- Run 'vagrant reload --provision' to pull in your new config
To get a better feel for it have a look in the puppet/ directory
