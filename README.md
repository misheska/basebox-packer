basebox
=======

Packer definitions for vagrant VirtualBox and VMware baseboxes. 
These are the vagrant baseboxes I use for my own personal projents. 
This project is run against a private Jenkins instance, and as template
definitions are added and/or updated, links to the generated images are
added below:

Current VMware Baseboxes
========================

* [misheska-centos64](https://dl.dropboxusercontent.com/s/78amja9zgzsxfcm/misheska-centos64.box?token_hash=AAE9hgUbbNWVb9Hz-dHmZRvBbC_iF9A8DdrDLOoSSh8Yug&dl=1) - CentOS 6.4 64-bit VMware Fusion/VMware Workstation basebox (VMware Tools 9.2.2.18018 build-893683)
* [misheska-centos59](https://dl.dropboxusercontent.com/s/26w92xn6dcwu1zv/misheska-centos59.box?token_hash=AAFSotlaoJHz26EduPqIt5IEi7o4Q4ZHE1MNs6ecIyyV4g&dl=1) - CentOS 5.9 64-bit VMware Fusion/VMware Workstation basebox (VMware Tools 9.2.2.18018 build-893683)
* [misheska-fedora19](https://dl.dropboxusercontent.com/s/ydcdppet0tgbggl/misheska-fedora19.box?token_hash=AAHJdxY0ER-CjAXY8kWaeLVw4huqFjuTK5poG-ayIiGUHQ&dl=1) - Fedora 19 64-bit VMware Fusion/VMware Workstation basebox (VMware Tools 9.2.2.18018 build-893683)
* [misheska-ubuntu1304](https://dl.dropboxusercontent.com/s/i95ij2nzg9lut2l/misheska-ubuntu1304.box?token_hash=AAGyNj5T7CAEL9_as5MIkgOViow1w8BW76HKcPYG8EbPyg&dl=1) - Ubuntu 13.04 server 64-bit VMware Fusion/VMware Workstation basebox (VMware Tools 9.2.2.18018 build-893683)
* [misheska-ubuntu1204](https://dl.dropboxusercontent.com/s/663x623xvvf571e/misheska-ubuntu1204.box?token_hash=AAEzyWiKRpuU5v321BSKkEzigDUJ2imSN75usrMBnU-5sw&dl=1) - Ubuntu 12.04.2 server 64-bit VMware Fusion/VMware Workstation basebox (VMware Tools 9.2.2.18018 build-893683)
* [misheska-ubuntu1004](https://dl.dropboxusercontent.com/s/gaa8frli5g6e2tr/misheska-ubuntu1004.box?token_hash=AAHlTAZJeb2SxdzlardrfA4rWXN5CcJuRjhhsaW5FqBZeA&dl=1) - Ubuntu 10.04.4 server 64-bit VMware Fusion/VMware Workstaton basebox (VMware Tools 9.2.2.18018 build-893683)
* [misheska-debian71](https://dl.dropboxusercontent.com/s/l96ew3z8auhn8kd/misheska-debian71.box?token_hash=AAGxp64UIE4mVnXawCEWx77zN871ZRTGrpPfB-y_9I3WQA&dl=1) - Debian "wheezy" 7.1 64-bit VMware Fusion/VMware Workstation basebox (VMware Tools 9.2.2.18018 build-893683)

Current VirtualBox Baseboxes
============================

* [misheska-centos64](https://dl.dropboxusercontent.com/s/y733o4ifkowc1w0/misheska-centos64.box?token_hash=AAFQZHmrtNB_Obc1Fvx3HL9Jl3EwQAmpXIKbpxy5IBxrwQ&dl=1) - CentOS 6.4 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-centos59](https://dl.dropboxusercontent.com/s/to898rawsb5klz1/misheska-centos59.box?token_hash=AAFdfkDOzzAwmauLOFgRpzDMxVYu4zPc_lB9MZRNUKkr4g&dl=1) - CentOS 5.9 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-fedora19](https://dl.dropboxusercontent.com/s/dvin3su7tr4rsme/misheska-fedora19.box?token_hash=AAE6Z4EOzW6lliUitACl-tBn76GfuQ4Hyx23j1ZwCfQzZw&dl=1) - Fedora 19 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-ubuntu1304](https://dl.dropboxusercontent.com/s/sacy9xv7065j3i7/misheska-ubuntu1304.box?token_hash=AAHuAaUCPvgms2ULMj_4ZTPYZfbf7XEJ0hU11UpIQmA2fg&dl=1) - Ubuntu 13.04 server 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-ubuntu1204](https://dl.dropboxusercontent.com/s/yfojlwxq66im9hk/misheska-ubuntu1204.box?token_hash=AAFUeOXWpPnRaPh6s_9JHKQiF0Y-q7rE8BrNxQN5d4Qj1Q&dl=1) - Ubuntu 12.04.2 server 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-ubuntu1004](https://dl.dropboxusercontent.com/s/i8g9udzui3fm6yf/misheska-ubuntu1004.box?token_hash=AAH7AKBi5S7A7BJMdbreEiBHb5ZlrmDeefRG-ciiSITNBA&dl=1) - Ubuntu 10.04.4 server 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)
* [misheska-debian71](https://dl.dropboxusercontent.com/s/it2y0qvrencv3jg/misheska-debian71.box?token_hash=AAGkdmtEBG6xpskfaITDKSfsSNqVE2P2mJwsWeSJ76ZyvA&dl=1) - Debian "wheezy" 7.1 64-bit VirtualBox basebox (VirtualBox 4.2.16 Guest Additions)

Getting Started
===============

A GNU Make makefile is provided to support automated builds.  It assumes
that both GNU Make and Packer are in the PATH.  Download and install
Packer from <http://www.packer.io/downloads.html>  

To build a VirtualBox box:

    make list
    # Choose a definition, like 'virtualbox/misheska-ubuntu1204'
    make virtualbox/misheska-ubuntu1204

To build a VMware Fusion/VMware Workstation box:

    make list
    # Choose a definition, like 'misheska-centos64'
    make vmware/misheska-centos64
