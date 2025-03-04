#!/bin/bash

if [[ `id -nu` != "pi" ]];then
   echo "Not pi user, exiting.."
   exit 1
fi

mopidy &

echo "$SCRIPT_NAME: COMPLETELY FINISHED" 
