Windows Basebox Nodes
=====================

Due to licensing restrictions, you will need to build the Windows baseboxes
yourself from the provided templates, using your own install media.  Edit
the template accordingly.

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
