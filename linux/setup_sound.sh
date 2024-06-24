#!/bin/bash

set -xeo pipefail

sudo apt update
sudo apt install -y pulseaudio libportaudio2 dbus-x11 libasound-dev
dbus-launch pulseaudio --start
