#!/bin/bash 

killall -9 mplayer
DOW=$(date +%u)
mplayer -shuffle -playlist /home/pi/Music/pimusic/playlists/$DOW.m3u
