basebox
=======

Packer definitions for vagrant VirtualBox and VMware baseboxes.
These are the vagrant baseboxes I use for my own personal projects.
This project is run against a private Jenkins instance, and as template
definitions are added and/or updated, links to the generated images are
generated in [Vagrant Cloud](https://vagrantcloud.com).

All boxes currently support VMware Fusion 6.0.3/VMware Workstation 10.02
via the vmware_desktop provider and VirtualBox via the virtualbox provider.
Refer to the VagrantCloud documentation on [Finding and Using Boxes](https://vagrantcloud.com/help/boxes/using)
for more information on how to integrate these boxes into your projects:

Current Boxes
==============

64-bit boxes:

* [misheska/centos510](https://vagrantcloud.com/misheska/centos510) - CentOS 5.10 64-bit
* [misheska/centos65](https://vagrantcloud.com/misheska/centos65) - CentOS 6.5 64-bit
* [misheska/oracle65](https://vagrantcloud.com/misheska/oracle65) - Oracle Enterprise Linux 6.5 64-bit
* [misheska/ubuntu1204](https://vagrantcloud.com/misheska/ubuntu1204) - Ubuntu 12.04 Server 64-bit
* [misheska/ubuntu1204-docker](https://vagrantcloud.com/misheska/ubuntu1204-docker) - Ubuntu 12.04 Server 64-bit with Docker
* [misheska/ubuntu1404](https://vagrantcloud.com/misheska/ubuntu1404) - Ubuntu 14.04 Server 64-bit
* [misheska/ubuntu1404-docker](https://vagrantcloud.com/misheska/ubuntu1404-docker) - Ubuntu 14.04 Server 64-bit with Docker
 

32-bit boxes:

* [misheska/centos510-i386](https://vagrantcloud.com/misheska/centos510-i386) - CentOS 5.10 32-bit
* [misheska/centos65-i386](https://vagrantcloud.com/misheska/centos65-i386) - CentOS 6.5 32-bit
* [misheska/oracle65-i386](https://vagrantcloud.com/misheska/oracle65-i386) - Oracle Enterprise Linux 6.5 32-bit
* [misheska/ubuntu1204-i386](https://vagrantcloud.com/misheska/ubuntu1204-i386) - Ubuntu 12.04 Server 32-bit
* [misheska/ubuntu1404-i386](https://vagrantcloud.com/misheska/ubuntu1404-i386) - Ubuntu 14.04 Server 32-bit



Getting Started
===============

A GNU Make makefile is provided to support automated builds.  It assumes
that both GNU Make and Packer are in the PATH.  Download and install
Packer from <http://www.packer.io/downloads.html>

To build a VirtualBox box:

    make list
    # Choose a definition, like 'virtualbox/ubuntu1204'
    make virtualbox/ubuntu1204.box

To build a VMware Fusion/VMware Workstation box:

    make list
    # Choose a definition, like 'vmware/centos64'
    make vmware/centos64.box

Provisioners
============

By default, the templates build without installing a provisioning client, like for Chef or Puppet.  You can choose
to install a provisioning client by using the following
Packer [user variables](http://www.packer.io/docs/templates/user-variables.html) when a basebox is built.

The `provisioner` variable controls which client provisioner is installed.  Current values can be:

    -var "provisioner=provisionerless" - the default, no client provisioner is installed
    -var "provisioner=chef"            - the Chef client provisioner is installed

If the 'provisioner' variable is set to something besides `provisionerless`, you can use the `provisioner_version`
variable to specify the version of the provisioner to be installed.  Legal values are:

    -var "provisioner_version=latest"  - install the latest version of the provisioner
    -var "provisioner_version=x.y.z"   - the provisioner version in dotted triplet form (example: 11.8.0)

Both variables should be used together when you specify a provisioner to be installed.  For example, to install the
latest version of the Chef client in an Ubuntu 12.04 basebox, run the following `packer` command in the appropriate
`teamplate` directory:

    packer build -var "provisioner=chef" -var "provisioner_version=11.8.0" ubuntu1204.json

Windows
=======

Microsoft won't allow us to redistribute Windows baseboxes, so you must obtain the appropriate ISO for each
Windows template and build them yourself.

The resultant Windows baseboxes also need the `vagrant-windows` plugin installed to run properly.  Run the following
command to install the `vagrant-windows` plugin:

    vagrant plugin install vagrant-windows

## Vagrantfile Settings

You'll also need to add the following settings to your `Vagrantfile` to enable the correct WinRM settings for
`vagrant` to talk to the Windows guest and set up shared folders properly:

    config.vm.guest = :windows
    config.windows.halt_timeout = 25
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"
    config.vm.network :forwarded_port, guest: 5985, host: 5985

## Other Userful Vagrantfile Settings

### GUI:

If you plan on using Windows in GUI mode, add the following section to your Vagrantfile in order to enable GUI mode:

If you plan on using Windows in GUI mode, add the following section to your
Vagrantfile in order to enable GUI mode:

VirtualBox:

    config.vm.provider :virtualbox do |p|
      p.gui = true
    end

VMware Workstation:

    config.vm.provider :vmware_workstation do |p|
      p.gui = true
    end

VMware Fusion:

    config.vm.provider :vmware_fusion do |p|
      p.gui = true
    end

### Workaround for Virtualbox resolution limitations:

If you are using VirtualBox and want to use a resolution higher than
800x600, add the following extra settings to your `config.vm.provider` block
to increase the amount of video memory, remove guest resolution restrictions,
and to set the default resolution (1024x768 is just an example):

    config.vm.provider :virtualbox do |p|
      p.gui = true
      v.customize ["modifyvm", :id, "--vram", "256"]
      v.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
      v.customize ["setextradata", :id, "CustomVideoMode1", "1024x768x32"]
    end

### Use high-speed virtual NICs on VMware

To use the 10Gb VMXNET3 virtual NIC instead of the default 1Gb E1000 virtual NIC on VMware:

VMware Workstation:

    config.vm.provider :vmware_workstation do |p|
      p.vmx["ethernet0.virtualDev"] = "vmxnet3"
    end

VMware Fusion:

    config.vm.provider :vmware_fusion do |p|
      p.vmx["ethernet0.virtualDev"] = "vmxnet3"
    end

### Allow VNC access via the VMware built-in VNC server

If you want to provider back-door VNC access to your VMware guest instances:

Mware Workstation:

    config.vm.provider :vmware_workstation do |p|
      p.vmx["RemoteDisplay.vnc.enabled"] = "true"
      p.vmx["RemoteDisplay.vnc.port"] = "5900"
    end

VMware Fusion:

    config.vm.provider :vmware_fusion do |p|
      p.vmx["RemoteDisplay.vnc.enabled"] = "true"
      p.vmx["RemoteDisplay.vnc.port"] = "5900"
    end
