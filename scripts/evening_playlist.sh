#!/bin/bash 

killall -9 mplayer
mplayer -shuffle -playlist /home/pi/Music/evening.txt
