#!/bin/sh

##
# Sets the computer hostname

HOSTNAME="${1:-Coreys-MBP}"

sudo scutil --set ComputerName "$HOSTNAME"
sudo scutil --set HostName "$HOSTNAME"
sudo scutil --set LocalHostName "$HOSTNAME"

dscacheutil -flushcache