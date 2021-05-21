#!/bin/bash

killall -9 mplayer
mplayer -volume 77 -playlist /home/pi/Music/pimusic/playlists/wakeup.m3u
