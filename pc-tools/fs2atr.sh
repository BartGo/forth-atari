#!/bin/bash

# yet untested
# by: Buki
# for APX Forth, Atari 8-bit
# from https://forums.atariage.com/topic/297112-atari-forth-programming/#comment-5482697


# Check if the script is provided with a file argument
if [ $# -eq 0 ]; then
    files=(*.fs)
elif [ $# -eq 1 ]; then
    files=("$1")
else
    echo "Usage: $0 [file]"
    exit 1
fi

# Loop through each .fs file
for input_file in "${files[@]}"; do
    # Check if the input file exists
    if [ ! -f "$input_file" ]; then
        echo "File '$input_file' does not exist."
        continue
    fi

    # Add the header to the file
    echo -ne "\x96\x02\x80\x16\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" > "${input_file}.tmp"

    # Pad with 1024 bytes of '00' after the header
    for ((i=0; i<1024; i++)); do
        echo -ne "\x00" >> "${input_file}.tmp"
    done

    # Convert text to uppercase, replace newlines with spaces, and append to the temporary file
    tr '[:lower:]' '[:upper:]' < "$input_file" | tr '\n' ' ' >> "${input_file}.tmp"

    # Calculate the number of spaces needed to pad the file
    num_bytes=$(stat -c %s "${input_file}.tmp")
    padding=$((92176 - num_bytes))

    # Pad the file with spaces
    for ((i=0; i<padding; i++)); do
        echo -ne " " >> "${input_file}.tmp"
    done

    # Rename the temporary file to the original filename
    mv "${input_file}.tmp" "${input_file%.fs}.atr"

    echo "Processed: ${input_file%.fs}.atr"
done

echo "Processing completed."
