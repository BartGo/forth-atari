#!/bin/bash

if [ $# -eq 1 ]; then
    file="$1"
    output_file="${file%%.*}.ATR"
else
    echo "Usage: $0 [file]"
    exit 1
fi

# 1. Create 16-byte ATR Header (Single Density)
echo -ne "\x96\x02\x80\x16\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" > "$output_file"

# 2. Create Screen 0: Line 0 has the proceed marker, Lines 1-15 are blank (1024 bytes)
printf "%-64s" "  -->  " >> "$output_file"
printf "%*s" 960 "" >> "$output_file" 

# 3. Process the text file starting from Screen 1
awk -v max_line_len=64 -v max_file_size=91120 '
BEGIN {
    total_size = 0;
    line_in_screen = 0;
    screen_count = 1; # Starting at Screen 1
}

{
    gsub(/\t/, "  ");
    gsub(/\r/, "", $0);
    
    # Line 0 of any screen
    if (line_in_screen == 0 && (length($0) == 0 || $0 ~ /^[[:space:]]*$/)) {
        $0 = "( ... )";
    }

    # If we reached the end of a screen (Line 15)
    if (line_in_screen == 15) {
        printf "%-64s", "  -->  ";
        total_size += 64;
        line_in_screen = 0;
        screen_count++;
        
        if (length($0) == 0 || $0 ~ /^[[:space:]]*$/) {
            $0 = "( ... )";
        }
    }

    line = substr($0, 1, max_line_len);
    printf "%-64s", line;
    
    total_size += 64;
    line_in_screen++;

    if (total_size > max_file_size) {
        print "\n*** ERROR: Source text exceeds 90KB disk capacity! ***" > "/dev/stderr";
        exit 1;
    }
}

END {
    # Fill current screen to the 15th line
    while (line_in_screen < 15) {
        printf "%-64s", "";
        total_size += 64;
        line_in_screen++;
    }

    # Termination marker on the 16th line
    if (line_in_screen == 15) {
        printf "%-64s", "  ;S ( END ) ";
        total_size += 64;
    }

    # Pad the remaining disk space to exactly 720 sectors
    if (total_size < max_file_size) {
        padding = max_file_size - total_size;
        for (i = 1; i <= padding; i++) printf " ";
    }
    
    print "\nProcessed " screen_count " Forth screens." > "/dev/stderr";
}
' "$file" >> "$output_file"

if [ $? -eq 0 ]; then
    echo "Success: $output_file created."
fi
