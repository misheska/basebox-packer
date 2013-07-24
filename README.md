basebox
=======

Packer definitions for vagrant VirtualBox and VMware baseboxes. 
These are the vagrant baseboxes I use for my own personal projents. 
This project is run against a private Jenkins instance, and as template
definitions are added and/or updated, links to the generated images are
added below:

Current VMware Baseboxes
========================

* [misheska-centos64](https://www.dropbox.com/s/78amja9zgzsxfcm/misheska-centos64.box) - CentOS 6.4 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)
* [misheska-centos59](https://www.dropbox.com/s/26w92xn6dcwu1zv/misheska-centos59.box) - CentOS 5.9 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)
* [misheska-ubuntu1204](/Users/misheska/Dropbox/basebox-packer/vmware/misheska-ubuntu1204.box) - Ubuntu 12.04.2 server 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)
* [misheska-ubuntu1004](https://www.dropbox.com/s/gaa8frli5g6e2tr/misheska-ubuntu1004.box) - Ubuntu 10.04.4 server 64-bit VMware Fusion basebox (VMware Tools 9.2.2.18018)

Current VirtualBox Baseboxes
============================

* [misheska-centos64](https://www.dropbox.com/s/y733o4ifkowc1w0/misheska-centos64.box) - CentOS 6.4 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-centos59](https://www.dropbox.com/s/to898rawsb5klz1/misheska-centos59.box) - CentOS 5.9 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-ubuntu1204](https://www.dropbox.com/s/yfojlwxq66im9hk/misheska-ubuntu1204.box) - Ubuntu 12.04.2 server 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-ubuntu1004](https://www.dropbox.com/s/i8g9udzui3fm6yf/misheska-ubuntu1004.box) - Ubuntu 10.04.4 server 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)

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
