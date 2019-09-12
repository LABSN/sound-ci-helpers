#!/bin/bash -e

sudo apt install -y pulseaudio
dbus-launch pulseaudio --start
