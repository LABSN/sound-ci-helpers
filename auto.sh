#!/bin/bash -ef

case "$OSTYPE" in
	darwin*)  echo "macOS ($OSTYPE)" && macos/setup_sound.sh ;; 
	linux*)   echo "Linux ($OSTYPE)" && linux/setup_sound.sh ;;
	*)        echo "Windows ($OSTYPE)" && powershell windows/setup_sound.ps1 ;;
esac
