#!/bin/bash

URL="https://transitlive.com/ajax/livemap.php?action=stop_times&lim=3&skip=0&ws=0&stop=1559&routes=18"
RESPONSE=$(curl -s "$URL")

BUS1_NUM=$(echo "$RESPONSE" | jq -r '.[0].bus_id')
BUS1_TIME=$(echo "$RESPONSE" | jq -r '.[0].pred_time')
BUS2_NUM=$(echo "$RESPONSE" | jq -r '.[1].bus_id')
BUS2_TIME=$(echo "$RESPONSE" | jq -r '.[1].pred_time')
BUS3_NUM=$(echo "$RESPONSE" | jq -r '.[2].bus_id')
BUS3_TIME=$(echo "$RESPONSE" | jq -r '.[2].pred_time')

CURRENT_TIME=$(date +%s)

TARGET_TIME_SEC1=$(date -d "today $BUS1_TIME" +%s)
DIFF_SEC=$((TARGET_TIME_SEC1 - CURRENT_TIME))
DIFF_MIN=$((DIFF_SEC / 60))
MESSAGE="Next bus in $DIFF_MIN minutes bus $BUS2_NUM arrives at $BUS2_TIME"
echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival

TARGET_TIME_SEC2=$(date -d "today $BUS2_TIME" +%s)
DIFF_SEC=$((TARGET_TIME_SEC2 - CURRENT_TIME))
DIFF_MIN=$((DIFF_SEC / 60))
MESSAGE="Next bus in $DIFF_MIN minutes bus $BUS2_NUM arrives at $BUS2_TIME"
echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival

TARGET_TIME_SEC3=$(date -d "today $BUS3_TIME" +%s)
DIFF_SEC=$((TARGET_TIME_SEC3 - CURRENT_TIME))
DIFF_MIN=$((DIFF_SEC / 60))
MESSAGE="Next bus in $DIFF_MIN minutes bus $BUS3_NUM arrives at $BUS3_TIME"
echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival
