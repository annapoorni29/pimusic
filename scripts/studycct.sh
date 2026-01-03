#!/bin/bash

# Configuration
INPUT_FILE="citizen.txt"
TIMER=10

# Function to speak using Festival (use CMU voice + SayText)
say() {
    local msg="$1"
    local cmd="(voice_cmu_us_slt_arctic_hts) (set! *duration_stretch* 1.2) (SayText \"$msg\")"
    echo "$ echo '$cmd' | festival"
    echo "$cmd" | festival
}

# Parse CSV and extract questions
total_questions=$(tail -n +2 "$INPUT_FILE" | wc -l)

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

# Speak question
say "Question: $question"
sleep 1

# Speak options
say "Option A: $opt_a"
sleep 0.5
say "Option B: $opt_b"
sleep 0.5
say "Option C: $opt_c"
sleep 0.5
say "Option D: $opt_d"

# Timer (silent)
for i in $(seq $TIMER -1 1); do
    sleep 1
done

# Map answer letter to answer text
answer_text=""
case "$correct_letter" in
    A) answer_text="$opt_a" ;;
    B) answer_text="$opt_b" ;;
    C) answer_text="$opt_c" ;;
    D) answer_text="$opt_d" ;;
esac

# Speak answer
say "The correct answer is: $correct_letter"
sleep 0.5
say "$answer_text"
