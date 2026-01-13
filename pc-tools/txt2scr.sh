#!/bin/bash
# ---
# convert text file to fig-Forth 1k screens
# tested for Atari 8-bit APX Forth
# - by Gemini & BartGo, 2026
# ---

if [ $# -eq 1 ]; then
    file="$1"
    output_file="${file%%.*}.ATR"
else
    echo "Usage: $0 [file]"
    exit 1
fi

# 1. Create 16-byte ATR Header (Single Density)
echo -ne "\x96\x02\x80\x16\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" > "$output_file"

# 2. Create Screen 0: Line 0 has " --> ", Lines 1-15 are blank (1024 bytes)
printf "%-64s" " --> " >> "$output_file"
printf "%*s" 960 "" >> "$output_file" 

# 3. Process the text file starting from Screen 1
# max_file_size is 92160 (total) - 16 (header) - 1024 (screen 0) = 91120
awk -v max_line_len=64 -v max_file_size=91120 '
BEGIN {
    total_size = 0;
    line_in_screen = 0;
}

{
    gsub(/\t/, "  ");
    gsub(/\r/, "", $0);
    
    if (line_in_screen == 0 && (length($0) == 0 || $0 ~ /^[[:space:]]*$/)) {
        $0 = "( ... )";
    }

    if (line_in_screen == 15) {
        printf "%-64s", " --> ";
        total_size += 64;
        line_in_screen = 0;
        
        if (length($0) == 0 || $0 ~ /^[[:space:]]*$/) {
            $0 = "( ... )";
        }
    }

    line = substr($0, 1, max_line_len);
    printf "%-64s", line;
    
    total_size += 64;
    line_in_screen++;

    # Early warning if we exceed capacity during processing
    if (total_size > max_file_size) {
        print "\n*** ERROR: Source text exceeds 90KB disk capacity! ***" > "/dev/stderr";
        exit 1;
    }
}

END {
    # Fill current screen to the 16th line
    while (line_in_screen < 15) {
        printf "%-64s", "";
        total_size += 64;
        line_in_screen++;
    }

    # Termination marker
    if (line_in_screen == 15) {
        printf "%-64s", " ;S ";
        total_size += 64;
    }

    # Pad the remaining disk space
    if (total_size < max_file_size) {
        padding = max_file_size - total_size;
        for (i = 1; i <= padding; i++) printf " ";
    } else if (total_size > max_file_size) {
         print "\n*** ERROR: Disk image overflowed! ***" > "/dev/stderr";
         exit 1;
    }
}
' "$file" >> "$output_file"

if [ $? -eq 0 ]; then
    echo "Success: $output_file created."
    echo "Structure: Header -> Screen 0 (Link) -> Screen 1+ (Source) -> ;S"
fi
