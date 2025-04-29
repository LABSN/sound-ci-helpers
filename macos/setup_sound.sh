#!/bin/bash

set -xeo pipefail
brew fetch --retry --cask background-music
brew install --cask background-music
sudo launchctl kickstart -kp system/com.apple.audio.coreaudiod || sudo killall coreaudiod
