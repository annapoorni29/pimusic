#!/bin/bash

killall -9 mplayer
mplayer -playlist /home/pi/Music/wakeup.txt
