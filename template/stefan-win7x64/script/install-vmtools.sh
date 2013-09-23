set -x

VAGRANT_HOME=/cygdrive/c/Users/vagrant
cd $VAGRANT_HOME

# 7zip will allow us to extract a file from an ISO
wget http://downloads.sourceforge.net/sevenzip/7z922-x64.msi
msiexec /qb /i 7z922-x64.msi

if [ -f VBoxGuestAdditions.iso ]; then
    # Extract the installer from the ISO
    /cygdrive/c/Program\ Files/7-Zip/7z.exe x VBoxGuestAdditions.iso VBoxWindowsAdditions-amd64.exe

    # Mark Oracle as a trusted installer
    certutil -addstore -f "TrustedPublisher" $(cygpath -d /cygdrive/a/oracle-cert.cer)

    # Install the Virtualbox Additions
    ./VBoxWindowsAdditions-amd64.exe /S

    # Cleanup
    rm -f VBoxGuestAdditions.iso
    rm -f VBoxWindowsAdditions-amd64.exe
elif [ -f windows.iso ]; then
    # Extract the installer from the ISO
    /cygdrive/c/Program\ Files/7-Zip/7z.exe x windows.iso setup64.exe

    # Install VMware tools
    ./setup64.exe /s /v'/qn REBOOT=R' || true

    # Cleanup
    rm -f windows.iso
    rm -f setup64.exe
fi

# Cleanup
rm -f 7z922-x64.msi

