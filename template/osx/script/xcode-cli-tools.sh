#!/bin/bash

[[ ! $INSTALL_XCODE_CLI_TOOLS ]] && exit
 
# Get and install Xcode CLI tools
OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')
 
# on 10.9, we can leverage SUS to get the latest CLI tools
if [ "$OSX_VERS" -ge 9 ]; then

    # create the placeholder file that's checked by CLI updates' .dist code 
    # in Apple's SUS catalog
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    # find the update with "Developer" in the name
    PROD=$(softwareupdate -l | grep -B 1 "Developer" | head -n 1 | awk -F"*" '{print $2}')

    # install it
    # amazingly, it won't find the update if we put the update ID in double-quotes
    softwareupdate -i $PROD -v
 
# on 10.7/10.8, we instead download from public download URLs, which can be found in
# the dvtdownloadableindex:
# https://devimages.apple.com.edgekey.net/downloads/xcode/simulators/index-3905972D-B609-49CE-8D06-51ADC78E07BC.dvtdownloadableindex
else
    [ "$OSX_VERS" -eq 7 ] && DMGURL=http://devimages.apple.com/downloads/xcode/command_line_tools_for_xcode_os_x_lion_april_2013.dmg
    [ "$OSX_VERS" -eq 8 ] && DMGURL=http://devimages.apple.com/downloads/xcode/command_line_tools_for_xcode_os_x_mountain_lion_march_2014.dmg

    TOOLS=clitools.dmg
    curl "$DMGURL" -o "$TOOLS"
    TMPMOUNT=`/usr/bin/mktemp -d /tmp/clitools.XXXX`
    hdiutil attach "$TOOLS" -mountpoint "$TMPMOUNT"
    installer -pkg "$(find $TMPMOUNT -name '*.mpkg')" -target /
    hdiutil detach "$TMPMOUNT"
    rm -rf "$TMPMOUNT"
    rm "$TOOLS"
    exit
fi
