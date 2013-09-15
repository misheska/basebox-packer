basebox
=======

Packer definitions for vagrant VirtualBox and VMware baseboxes. 
These are the vagrant baseboxes I use for my own personal projents. 
For more informations, see original project
<https://github.com/misheska/basebox-packer>
This project is a fork running packer on a Windows host.

Getting Started
===============

For Unix, a GNU Make makefile is provided to support automated builds.  It
assumes that both GNU Make and Packer are in the PATH.  Download and install
Packer from <http://www.packer.io/downloads.html>  
On a Windows host, use the make.bat instead.

To build a VirtualBox box:

    make list
    # Choose a definition, like 'virtualbox/stefan-win7x64'
    make virtualbox/stefan-win7x64

To build a VMware Fusion/VMware Workstation box:

    make list
    # Choose a definition, like 'stefan-win7x64'
    make vmware/stefan-win7x64
