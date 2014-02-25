Python/Appengine Vagrant box
============================

![vagrant-python-appengine](https://dl.dropboxusercontent.com/u/266793/vagrant/vagrant-appengine.png)


Simple vagrant box for a Python/Google Appengine development environment. This will boot up an ubuntu 12.04 instance and install an entire appengine development environment. It uses host manager for easy local DNS configuration.


Requirements
------------

Before you can use this project, you'll need to install a few dependencies:

- [Virtualbox >= 4.2](https://www.virtualbox.org)
- [Vagrant >= 1.4](http://www.vagrantup.com)
- [Vagrant Vbguest Plugin](https://github.com/dotless-de/vagrant-vbguest)
- [Vagrant Hostmanager Plugin](https://github.com/smdahlen/vagrant-hostmanager)


Installation/Provisioning
-------------------------

Using this box is simple, you can be up and running with a few short commands:

First, clone this repository to an appropriate location.

``` bash
git clone git@github.com:rehabstudio/vagrant-python-appengine.git myproject
```

Next, navigate inside the vagrant folder and provision the guest instance.

``` bash
cd myproject/vagrant
vagrant up
```

Once provisioned, you can ssh into the running box and start the appengine development server:

``` bash
vagrant ssh
runserver  # a globally installed alias for dev_appserver.py with some sensible defaults
```


Node Dependencies (NPM)
-----------------------

There is a statement included in the puppet files to search your application root for a `package.json` file. If one is found, then the command `npm install` will be run on your behalf. The longer a project runs the more likely its dependencies will change. If you add or remove packages from your `package.json` file, simply run `vagrant provision` to have it re-run the `npm install` command.


Appengine Python SDK
--------------------

The Python SDK for Google Appengine will be downloaded and installed during provisioning of the box along with all necessary dependencies. The appropriate paths will be added to the system path to make the SDK's binaries accessible from any location within the box. A simple `runserver` alias for `dev_appserver.py` is provided that will allow you to run your app with sensible default settings.

``` bash
alias runserver='dev_appserver.py /home/vagrant/app --host 0.0.0.0 --admin_host 0.0.0.0 --storage_path /home/vagrant/storage --skip_sdk_update_check'
```
