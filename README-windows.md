Windows Basebox Notes
=====================

Due to licensing restrictions, you will need to build the Windows baseboxes
yourself from the provided templates, using your own install media.  Edit
the templates accordingly.

Windows Guest Bug
-----------------

As of this writing, despite setting `config.vm.guest` properly in your `Vagrantfile` 
per the Vagrant documentation:

    config.vm.guest = :windows
    
You will still see the following warning message (and vagrant will return an error code)
when you run `vagrant up` against a Windows basebox:

    The guest operating system of the machine could not be detected!
    Vagrant requires this knowledge to perform specific tasks such
    as mounting shared folders and configuring networks. Please add
    the ability to detect this guest operating system to Vagrant
    by creating a plugin or reporting a bug.

Despite the warning, and `vagrant up` returning an error code, the message is benign and if
the templates from this repository are used, the box will load and function correctly and
shared folders will behave as expected.  It just affects integration with tools like Chef's 
`test-kitchen` which (correctly) looks at the failure exit code and treat it as an error,
preventing test runs using these Windows baseboxes.  This issue has been reported to 
the vagrant folks as an bug

GUI
---

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

Also, if you are using VirtualBox and want to use a resolution bigger than
800x600, add the following extra settings to your `config.vm.provider` block
to increase the amount of video memory, remove guest resolution restrictions,
and to set the default resolution (1024x768 is just an example):

    config.vm.provider :virtualbox do |p|
      p.gui = true
      v.customize ["modifyvm", :id, "--vram", "256"]
      v.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
      v.customize ["setextradata", :id, "CustomVideoMode1", "1024x768x32"]
    end
