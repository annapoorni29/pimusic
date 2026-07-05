#!/bin/bash

ROUTE_NUMBER="108"
LATITUDE="51.079417"
LONGITUDE="-114.194222"
URL="https://hastinfo.calgarytransit.com/HastinfoMVCWeb/api/NextPassingTimesAPI/GetStopsNearLocation?latitude=$LATITUDE&longitude=$LONGITUDE"
RESPONSE=$(curl -s "$URL")

STOP_ID=$(echo "$RESPONSE" | jq -r '.[0].Stop.Identifier // empty')
if [ -z "$STOP_ID" ]; then
    STOP_ID="2608"
fi

MESSAGE="Calgary bus $ROUTE_NUMBER at stop $STOP_ID"
echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival
