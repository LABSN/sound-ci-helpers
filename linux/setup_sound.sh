#!/bin/bash -e

sudo apt update
sudo apt install -y pulseaudio libportaudio2 dbus-x11
dbus-launch pulseaudio --start
