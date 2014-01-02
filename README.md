basebox
=======

Packer definitions for vagrant VirtualBox and VMware baseboxes. 
These are the vagrant baseboxes I use for my own personal projects. 
For more informations, see original project
<https://github.com/misheska/basebox-packer>
This project is a fork running packer on a Windows host.

Getting Started
===============

To install Packer on a Windows host, use this command:

    cinst packer

If you don't know what cinst is, head over to <http://chocolatey.org> and install Chocolatey first. You also propably need VirtualBox which could be installed with

    cinst virtualbox

For Windows there is a make.bat file which does some helpful steps for you.

To build a VirtualBox box:

    make list
    # Choose a definition, like 'virtualbox/win7x64en-enterprise'
    make virtualbox/win7x64en-enterprise

To build a VMware Fusion/VMware Workstation box:

    make list
    # Choose a definition, like 'vmware/win7x64en-enterprise'
    make vmware/win7x64en-enterprise

To fix all packer templates after a packer update (eg. 0.4.x -> 0.5.0)
call this:

    make fix

