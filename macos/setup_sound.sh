#!/bin/bash -e

git clone https://github.com/kyleneideck/BackgroundMusic --depth=50 -b 0.3.x
sudo xcodebuild -project BackgroundMusic/BGMApp/BGMAppTests/NullAudio/AudioDriverExamples.xcodeproj -target NullAudio DSTROOT="/" install
sudo launchctl kickstart -kp system/com.apple.audio.coreaudiod || sudo killall coreaudiod
