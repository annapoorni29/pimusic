#!/bin/bash

# Configuration
INPUT_FILE="citizen.txt"
TIMER=10

# Function to speak using Festival (use CMU voice + SayText)
say() {
    local msg="$1"
    local msg_escaped
    msg_escaped=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$msg_escaped\")" | festival
}

# Function to print and speak
utter() {
    echo -e "$1"
    say "$1"
}

# Pre-process the file to find where each numbered question starts
blocks=$(grep -n "^[0-9]\+\." "$INPUT_FILE" | cut -d: -f1)
total_questions=$(echo "$blocks" | wc -l)

clear
echo "Starting Hands-Free Study Session..."
echo "Found $total_questions questions. Press Ctrl+C to stop."
say "Starting your citizenship study session."

while true; do
    # Pick a random question index
    target_idx=$(( (RANDOM % total_questions) + 1 ))
    start_line=$(echo "$blocks" | sed -n "${target_idx}p")
    
    # Define the end of the question block
    next_idx=$((target_idx + 1))
    end_line=$(echo "$blocks" | sed -n "${next_idx}p")
    
    if [ -z "$end_line" ]; then
        block=$(sed -n "${start_line},$ p" "$INPUT_FILE")
    else
        block=$(sed -n "${start_line},$((end_line - 1))p" "$INPUT_FILE")
    fi

    # 1. Parse Question (Line 1)
    question=$(echo "$block" | sed -n '1p')
    
    # 2. Parse Options and identify the correct one
    # We clean the text to remove the markers so the voice doesn't spoil it early
    options=$(echo "$block" | tail -n +2 | grep -v "^$")
    correct_answer=$(echo "$block" | grep -Ei "\(correct answer\)|\(you got it right\)" | sed 's/(.*)//g' | xargs)

    # UTTERANCE PHASE
    echo "------------------------------------------"
    utter "Question: $question"
    sleep 1

    count=1
    while read -r opt; do
        # Remove markers for the options reading phase
        clean_opt=$(echo "$opt" | sed 's/(.*)//g' | xargs)
        letter=$(printf "\x$(printf %x $((64 + count)))")
        utter "Option $letter: $clean_opt"
        count=$((count + 1))
        [ $count -gt 4 ] && break # Ensure we only read 4 options
    done <<< "$options"

    # TIMER PHASE
    echo -ne "\nThinking time: "
    for i in $(seq $TIMER -1 1); do
        echo -ne "$i... "
        sleep 1
    done
    echo -e "\n"

    # REVEAL PHASE
    if [ -n "$correct_answer" ]; then
        utter "The correct answer is: $correct_answer"
    else
        utter "Review the text for this answer."
    fi

    sleep 4 # Brief pause before the next random question
done
