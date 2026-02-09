#!/bin/bash
pkill wl-paste
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
