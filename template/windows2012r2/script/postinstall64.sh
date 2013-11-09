set -vx

cd $HOME

# Configure ssh for the user with no passphrase
ssh-user-config -y -p ""

# Install vagrant public key
if [ ! -f vagrant.pub ]; then
  wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
fi
cat vagrant.pub >>$HOME/.ssh/authorized_keys
rm -f vagrant.pub

if wmic os get osarchitecture | grep -q 64-bit;then
    ZIP_INSTALL=7z922-x64.msi
    VBOX_INSTALL=VBoxWindowsAdditions-amd64.exe
    VMWARE_INSTALL=setup64.exe
else
    ZIP_INSTALL=7z922.msi
    VBOX_INSTALL=VBoxWindowsAdditions-x86.exe
    VMWARE_INSTALL=setup.exe
fi

# 7zip will allow us to extract a file from an ISO
if [ ! -f $ZIP_INSTALL ]; then
  wget --no-check-certificate http://downloads.sourceforge.net/sevenzip/$ZIP_INSTALL
fi
msiexec /qb /i $ZIP_INSTALL

# Cleanup
rm -f $ZIP_INSTALL

SEVENZIP_HOME=$(reg query HKCU\\SOFTWARE\\7-Zip /v Path | sed -nre 's/^\s*Path\s*REG_SZ\s*(.*)$/\1/ p')

# Add the path to 7zip to the system search path
for pf in "$SEVENZIP_HOME" "$PROGRAMFILES/7-Zip" "$ProgramW6432/7-Zip" "$SYSTEMDRIVE/Program Files/7-Zip"  "$SYSTEMDRIVE/Program Files(x86)/7-Zip"; do
  if [[ -d "$(cygpath "$pf")" ]]; then
    PATH="$PATH:$(cygpath "$pf")"
    break
  fi
done

if [ -f VBoxGuestAdditions.iso ]; then
    # Extract the installer from the ISO
    7z x VBoxGuestAdditions.iso $VBOX_INSTALL

    # Mark Oracle as a trusted installer
    certutil -addstore -f "TrustedPublisher" a:oracle-cert.cer

    # Install the Virtualbox Additions
    ./$VBOX_INSTALL /S

    # Cleanup
    rm -f VBoxGuestAdditions.iso
    rm -f $VBOX_INSTALL
elif [ -f windows.iso ]; then
  # Skip installing VMWare Tools, if it's already installed
  if ! net start | grep -iq "VMware Tools"; then
    # Extract the installer from the ISO
    7z x windows.iso $VMWARE_INSTALL

    # Install VMware tools
    ./$VMWARE_INSTALL /S /v "/qn REBOOT=R ADDLOCAL=ALL"

    # Cleanup
    rm -f $VMWARE_INSTALL
  fi
  rm -f windows.iso
fi

exit 0
