#!/bin/bash

killall -9 mplayer
mplayer -volume 100 -playlist /home/pi/Music/pimusic/playlists/vaishu.m3u
