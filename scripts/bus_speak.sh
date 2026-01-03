#!/bin/bash

convert_time_to_words() {
    local input_time="$1"

    # Convert time using sed
    local spoken_time=$(echo "$input_time" | sed -E '
        s/([0-9]+):([0-9]+) ([AP]M)/\1 \2 \3/;
        s/\b0?1\b/one/;  s/\b0?2\b/two/;  s/\b0?3\b/three/;
        s/\b0?4\b/four/; s/\b0?5\b/five/; s/\b0?6\b/six/;
        s/\b0?7\b/seven/; s/\b0?8\b/eight/; s/\b0?9\b/nine/;
        s/\b10\b/ten/;   s/\b11\b/eleven/; s/\b12\b/twelve/;
        s/\b13\b/thirteen/; s/\b14\b/fourteen/; s/\b15\b/fifteen/;
        s/\b16\b/sixteen/; s/\b17\b/seventeen/; s/\b18\b/eighteen/;
        s/\b19\b/nineteen/; s/\b20\b/twenty/;
        s/\b21\b/twenty one/; s/\b22\b/twenty two/; s/\b23\b/twenty three/;
        s/\b24\b/twenty four/; s/\b25\b/twenty five/; s/\b26\b/twenty six/;
        s/\b27\b/twenty seven/; s/\b28\b/twenty eight/; s/\b29\b/twenty nine/;
        s/\b30\b/thirty/; s/\b31\b/thirty one/; s/\b32\b/thirty two/;
        s/\b33\b/thirty three/; s/\b34\b/thirty four/; s/\b35\b/thirty five/;
        s/\b36\b/thirty six/; s/\b37\b/thirty seven/; s/\b38\b/thirty eight/;
        s/\b39\b/thirty nine/; s/\b40\b/forty/;
        s/\b41\b/forty one/; s/\b42\b/forty two/; s/\b43\b/forty three/;
        s/\b44\b/forty four/; s/\b45\b/forty five/; s/\b46\b/forty six/;
        s/\b47\b/forty seven/; s/\b48\b/forty eight/; s/\b49\b/forty nine/;
        s/\b50\b/fifty/; s/\b51\b/fifty one/; s/\b52\b/fifty two/;
        s/\b53\b/fifty three/; s/\b54\b/fifty four/; s/\b55\b/fifty five/;
        s/\b56\b/fifty six/; s/\b57\b/fifty seven/; s/\b58\b/fifty eight/;
        s/\b59\b/fifty nine/;
        s/\bAM\b/ay em/; s/\bPM\b/pee em/
    ')
    echo "$spoken_time"
}

URL="https://transitlive.com/ajax/livemap.php?action=stop_times&lim=3&skip=0&ws=0&stop=1559&routes=18"
RESPONSE=$(curl -s "$URL")


BUS1_NUM=$(echo "$RESPONSE" | jq -r '.[0].bus_id')
BUS1_TIME=$(echo "$RESPONSE" | jq -r '.[0].pred_time')
BUS1_OUT=$(convert_time_to_words "$BUS1_TIME")
CURRENT_TIME=$(date +%s)
TARGET_TIME_SEC1=$(date -d "today $BUS1_TIME" +%s)
DIFF_SEC=$((TARGET_TIME_SEC1 - CURRENT_TIME))
DIFF_MIN=$((DIFF_SEC / 60))
MESSAGE="Next bus in $DIFF_MIN minutes"
echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival
MESSAGE="Bus $BUS1_NUM arrives at $BUS1_OUT"
echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival

#sleep 3
#BUS2_NUM=$(echo "$RESPONSE" | jq -r '.[1].bus_id')
#BUS2_TIME=$(convert_time_to_words $(echo "$RESPONSE" | jq -r '.[1].pred_time'))
#TARGET_TIME_SEC2=$(date -d "today $BUS2_TIME" +%s)
#DIFF_SEC=$((TARGET_TIME_SEC2 - CURRENT_TIME))
#DIFF_MIN=$((DIFF_SEC / 60))
#MESSAGE="Next bus in $DIFF_MIN minutes"
#echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival
#sleep 1
#MESSAGE="Bus $BUS2_NUM arrives at $BUS2_TIME"
#echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival

#sleep 3
#BUS3_NUM=$(echo "$RESPONSE" | jq -r '.[2].bus_id')
#BUS3_TIME=$(convert_time_to_words $(echo "$RESPONSE" | jq -r '.[2].pred_time'))
#TARGET_TIME_SEC3=$(date -d "today $BUS3_TIME" +%s)
#DIFF_SEC=$((TARGET_TIME_SEC3 - CURRENT_TIME))
#DIFF_MIN=$((DIFF_SEC / 60))
#MESSAGE="Next bus in $DIFF_MIN minutes"
#echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival
#sleep 1
#MESSAGE="Bus $BUS3_NUM arrives at $BUS3_TIME"
#echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$MESSAGE\")" | festival
