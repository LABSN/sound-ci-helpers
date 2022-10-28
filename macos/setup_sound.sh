#!/bin/bash -e

curl -L https://github.com/downloads/AVbin/AVbin/AVbin10.pkg -o ~/AVbin10.pkg
sudo installer -pkg ~/AVbin10.pkg -target /
git clone https://github.com/kyleneideck/BackgroundMusic --depth=50 -b 0.3.x
sudo xcodebuild -project BackgroundMusic/BGMApp/BGMAppTests/NullAudio/AudioDriverExamples.xcodeproj -target NullAudio DSTROOT="/" install
sudo launchctl kickstart -kp system/com.apple.audio.coreaudiod || sudo killall coreaudiod
