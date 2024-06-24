#!/bin/bash

set -xeo pipefail

sudo apt update
sudo apt install -y pulseaudio libportaudio2 dbus-x11 libasound-dev
systemctl --user restart pulseaudio.service
systemctl --user restart pulseaudio.socket
pactl list
