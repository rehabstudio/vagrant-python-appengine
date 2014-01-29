PHP/NGINX/MySQL VAGRANT BOX
===========================

Simple vagrant build for a general php/mysql setup on nginx. This will boot up an nginx/php/mysql ubuntu box for a single instance. It uses host manager for easy local DNS configuration. 

Requirements
------------

- [Virtualbox 4.2](https://www.virtualbox.org)
- [Vagrant 1.4](http://www.vagrantup.com)
- [Vagrant Hostmanager Plugin](https://github.com/smdahlen/vagrant-hostmanager)
- Ruby 1.9.3
- Bundler 1.3.5

Installation
-------

1. Clone this repository and install git submodules:
`git submodule update --init`

2. Navigate inside the vagrant folder and create the guest machine
`cd vagrant && vagrant up`

3. After the installation finishes, visit the chosen domain:
`http://rehab.vagrant.local`

Customisation
------------

The Vagrantfile `vagrant\Vagrantfile` and main puppet manifest `vagrant/puppet/manifests/init.pp` have a variety of configuration options at the top of their files that should be tweaked per project. Some of the configuration options affect things such as the bound ip address of the box, vhost settings, nginx log locations, database users, php settings and much more.

By default, MySQL has a root user whose password is also root. A project-specific user is also created, whose credentials can be set via the supplied configuration options. A schema is also imported on your behalf. Replace the existing schema with your own, or, repoint the schema path to a different one. It is important to ensure your schema uses `IF NOT EXISTS` statements to ensure data is not overwritten when reprovisioning your box.

Alongide PHP being installed, PHPUnit and Composer are already present. PHP settings are changed using a tool known as [Augeas](http://augeas.net/) which has a specific syntax to follow. This should be taken into consideration if you are wanting to change PHP.ini settings other than those already listed/changed. You can also change the installed extensions by finding the `php::extension` declaration.

It should also be noted that this is just a base for you to build upon. These scripts should be adapted to best suit your project and to mirror your live location as closely as possible.

Writing Your Own Module
-------

You can install additional software quite simply, by using the following steps.
- Create a folder in `vagrant/puppet/modules/` directory for your package, eg. 'dummy'
- Create two folders inside that folder called `files` and `manifests`
- In the new manifests folder create a file called `init.pp` and enter the puppet manifest appropriately, eg.

```
class dummy {
    package { [
            (..LIST ALL PACKAGES HERE..)
        ]:
        ensure => present;
    }
    (..ANY OTHER PUPPET COMMANDS..)
}
```
- The `files` folder should be used for any files that you are using in your manifest. These can be referenced inside your manifest file by using the URI pattern: `puppet:///modules/dummy/my.cnf` (note that `files/` is skipped in this URI).
- Once your module is complete you can call it from the main puppet manifest file `puppet/manifests/init.pp` by using the syntax: `include dummy`
- Run `vagrant reload --provision` to pull in your new config

MySQL Access
------------

MySQL can be access internally on the box by SSHing into it using `vagrant ssh`, or, by using a desktop client (or command-line) from your host machine. The MySQL server package has been pre-configured to allow access from your remote machine (using the private IP address from vagrant). You can connect using a command (from your host machine) like the following:

``` bash
mysql --host=192.168.33.10 --user=username --password=password
```