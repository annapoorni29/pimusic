#!/bin/bash

# Configuration
INPUT_FILE="citizen.txt"
TIMER=10

# Check if Festival is installed
if ! command -v festival &> /dev/null; then
    echo "Festival is not installed. Install it with: sudo apt-get install festival"
    exit 1
fi

# Function to speak using Festival
say() {
    echo "$1" | festival --tts
}

# Function to print and speak
utter() {
    echo -e "$1"
    say "$1"
}

# 1. Prepare the data: Identify question blocks
# We treat lines starting with a number as the start of a new record
blocks=$(grep -n "^[0-9]\+\." "$INPUT_FILE" | cut -d: -f1)
total_questions=$(echo "$blocks" | wc -l)

echo "Found $total_questions questions in $INPUT_FILE."

while true; do
    # Pick a random question index
    target_idx=$(( (RANDOM % total_questions) + 1 ))
    start_line=$(echo "$blocks" | sed -n "${target_idx}p")
    
    # Get the next question's start line to define the block end
    next_idx=$((target_idx + 1))
    end_line=$(echo "$blocks" | sed -n "${next_idx}p")
    
    if [ -z "$end_line" ]; then
        # If it's the last question, read to the end of file
        block=$(sed -n "${start_line},$ p" "$INPUT_FILE")
    else
        block=$(sed -n "${start_line},$((end_line - 1))p" "$INPUT_FILE")
    fi

    # Parse Question (Line 1 of the block)
    question=$(echo "$block" | sed -n '1p')
    
    # Parse Options (Lines starting from the first non-empty line after the question)
    # This cleans up strings like "(correct answer)" or "(you got it right)" for the TTS
    options=$(echo "$block" | tail -n +2 | grep -v "^$" | head -n 4)
    
    # Find the correct answer by searching for markers
    correct_answer=$(echo "$block" | grep -Ei "\(correct answer\)|\(you got it right\)" | sed 's/(.*)//g' | xargs)

    # UTTERANCE PHASE
    clear
    utter "Question $question"
    sleep 1

    # Read options one by one
    count=1
    while read -r opt; do
        clean_opt=$(echo "$opt" | sed 's/(.*)//g' | xargs)
        letter=$(printf "\x$(printf %x $((64 + count)))") # Generates A, B, C, D
        utter "Option $letter: $clean_opt"
        count=$((count + 1))
    done <<< "$options"

    # TIMER PHASE
    echo -e "\n--- You have $TIMER seconds to think ---"
    for i in $(seq $TIMER -1 1); do
        echo -ne "$i... \r"
        sleep 1
    done

    # REVEAL PHASE
    if [ -n "$correct_answer" ]; then
        utter "The correct answer is: $correct_answer"
    else
        utter "I couldn't identify the correct answer in the text for this one."
    fi

    echo -e "\n------------------------------------------"
    say "Ready for the next question?"
    sleep 3
done
