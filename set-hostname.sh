#!/bin/sh

HOSTNAME="Coreys-MBP"

sudo scutil --set ComputerName "$HOSTNAME"
sudo scutil --set HostName "$HOSTNAME"
sudo scutil --set LocalHostName "$HOSTNAME"

dscacheutil -flushcache