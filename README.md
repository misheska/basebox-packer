basebox
=======

Packer definitions for vagrant VirtualBox and VMware Fusion baseboxes. 
These are the vagrant baseboxes I use for my own personal projents. 
This project is run against a private Jenkins instance, and as template
definitions are added and/or updated, links to the generated images are
added below:

Current VMware Fusion Baseboxes
===============================

* [misheska-centos-6.4](https://www.dropbox.com/s/z939ia4kurfuw6h/misheska-centos-6.4.box) - CentOS 6.4 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)
* [misheska-centos-5.9](https://www.dropbox.com/s/j9y298amevw7sfh/misheska-centos-5.9.box) - CentOS 5.9 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)
* [misheska-ubuntu-12.04](https://www.dropbox.com/s/z2pa3qvrgyl77k1/misheska-ubuntu-12.04.box) - Ubuntu 12.04.2 server 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)
* [misheska-ubuntu-10.04](https://www.dropbox.com/s/1rl14o3u3b8y5ea/misheska-ubuntu-10.04.box) - Ubuntu 10.04.4 server 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)

Current VirtualBox Baseboxes
============================

* [misheska-centos-6.4](https://www.dropbox.com/s/y42egyh9cqsge24/misheska-centos-6.4.box) - CentOS 6.4 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-centos-5.9](https://www.dropbox.com/s/5wpk5mhy3ovs0av/misheska-centos-5.9.box) - CentOS 5.9 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-ubuntu-12.04](https://www.dropbox.com/s/dauh3gn69dp1bfq/misheska-ubuntu-10.04.box) - Ubuntu 12.04.2 server 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-ubuntu-10.04](https://www.dropbox.com/s/m47nubjupedduvh/misheska-ubuntu-12.04.box) - Ubuntu 10.04.4 server 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)

Getting Started
===============

A GNU Make makefile is provided to support automated builds.  It assumes
that both GNU Make and Packer are in the PATH.

To build a VirtualBox box:

    make list
    # Choose a definition, like 'virtualbox/misheska-ubuntu1204'
    make virtualbox/misheska-ubuntu1204

To build a VMware Fusion box:

    make list
    # Choose a definition, like 'misheska-centos64'
    make vmware/misheska-centos64
