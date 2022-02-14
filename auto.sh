#!/bin/bash -ef

THIS_DIR=$(dirname "$0")
case "$OSTYPE" in
	darwin*)  echo "macOS ($OSTYPE)" && $THIS_DIR/macos/setup_sound.sh ;;
	linux*)   echo "Linux ($OSTYPE)" && $THIS_DIR/linux/setup_sound.sh ;;
	*)        echo "Windows ($OSTYPE)" && powershell $THIS_DIR/windows/setup_sound.ps1 ;;
esac
