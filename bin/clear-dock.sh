#!/bin/sh

##
# Remove everything from the Dock

defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
