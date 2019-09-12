#!/bin/bash -e

sudo apt install -y pulseaudio libportaudio2
dbus-launch pulseaudio --start
