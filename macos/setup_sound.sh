#!/bin/bash

set -xeo pipefail
brew install --cask background-music
sudo launchctl kickstart -kp system/com.apple.audio.coreaudiod || sudo killall coreaudiod
