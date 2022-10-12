#!/bin/sh

LOCAL_READLINK=readlink

# https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)    LOCAL_READLINK=greadlink;;
esac

pwsh -noprofile -nologo -file "$(dirname $(${LOCAL_READLINK} -f $0))/StartPlugin.ps1"
