#!/bin/bash

# Configuration
INPUT_FILE="citizen.txt"
TIMER=10

# Function to speak using Festival (use CMU voice + SayText)
say() {
    local msg="$1"
    local msg_escaped
    msg_escaped=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "(voice_cmu_us_slt_arctic_hts) (SayText \"$msg_escaped\")" | festival --interactive
}

# Function to print and speak
utter() {
    echo -e "$1"
    say "$1"
}

# Parse CSV and extract questions
# Skip header and extract total number of questions
total_questions=$(tail -n +2 "$INPUT_FILE" | wc -l)

clear
echo "Starting Hands-Free Study Session..."
echo "Found $total_questions questions. Press Ctrl+C to stop."
say "Starting your citizenship study session."

while true; do
    # Pick a random question index (1-based)
    target_idx=$(( (RANDOM % total_questions) + 1 ))
    
    # Extract the specific line (skip header, so add 1)
    line_num=$((target_idx + 1))
    record=$(sed -n "${line_num}p" "$INPUT_FILE")
    
    # Parse CSV fields using awk
    # Fields: Question,Option A,Option B,Option C,Option D,Correct Answer
    question=$(echo "$record" | awk -F',' '{print $1}' | tr -d '"')
    opt_a=$(echo "$record" | awk -F',' '{print $2}' | tr -d '"')
    opt_b=$(echo "$record" | awk -F',' '{print $3}' | tr -d '"')
    opt_c=$(echo "$record" | awk -F',' '{print $4}' | tr -d '"')
    opt_d=$(echo "$record" | awk -F',' '{print $5}' | tr -d '"')
    correct_letter=$(echo "$record" | awk -F',' '{print $6}' | tr -d '"')

    # UTTERANCE PHASE
    echo "------------------------------------------"
    utter "Question: $question"
    sleep 1

    # Read options
    utter "Option A: $opt_a"
    sleep 0.5
    utter "Option B: $opt_b"
    sleep 0.5
    utter "Option C: $opt_c"
    sleep 0.5
    utter "Option D: $opt_d"

    # TIMER PHASE
    echo -ne "\nThinking time: "
    for i in $(seq $TIMER -1 1); do
        echo -ne "$i... "
        sleep 1
    done
    echo -e "\n"

    # REVEAL PHASE
    utter "The correct answer is: $correct_letter"

    sleep 4 # Brief pause before the next random question
done
