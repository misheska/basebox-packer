set -x

# Create the home directory
mkdir -p /home/vagrant
chown vagrant /home/vagrant
cd /home/vagrant

# Install ssh certificates
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chown -R vagrant /home/vagrant/.ssh
cd ..

# 7zip will allow us to extract a file from an ISO
wget http://downloads.sourceforge.net/sevenzip/7z922-x64.msi
msiexec /qb /i 7z922-x64.msi

if [ -f /cygdrive/c/cygwin/VBoxGuestAdditions.iso ]; then
    # Extract the installer from the ISO
    cp /cygdrive/c/cygwin/VBoxGuestAdditions.iso .
    /cygdrive/c/Program\ Files/7-Zip/7z.exe x VBoxGuestAdditions.iso VBoxWindowsAdditions-amd64.exe

    # Mark Oracle as a trusted installer
    cp /cygdrive/a/oracle-cert.cer .
    certutil -addstore -f "TrustedPublisher" oracle-cert.cer

    # Install the Virtualbox Additions
    ./VBoxWindowsAdditions-amd64.exe /S

    # Cleanup
    rm -f /cygdrive/c/cygwin/VBoxGuestAdditions.iso
    rm -f VBoxGuestAdditions.iso
    rm -f VBoxWindowsAdditions-amd64.exe
elif [ -f /cygdrive/c/cygwin/windows.iso ]; then
    # Extract the installer from the ISO
    cp /cygdrive/c/cygwin/windows.iso .
    /cygdrive/c/Program\ Files/7-Zip/7z.exe x windows.iso setup64.exe

    # Install VMware tools
    ./setup64.exe /s /v'/qn REBOOT=R' || true 

    # Cleanup
    rm -f /cygdrive/c/cygwin/windows.iso
    rm -f windows.iso
    rm -f setup64.exe
fi

# Cleanup
rm -f 7z922-x64.msi
