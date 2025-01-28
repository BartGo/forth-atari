
# this:
#   txt -> atari forth line-32 screen file
# reverse:
#   fold -b -w 32 out.atr > out.fld
#   sed -e :a -e 'N;s/\n\s*$//;ta' out.fld > out.4th
# FIXME: sometimes wrongly removes empty lines mid-file

awk -v max_line_len=32 -v max_file_size=92160 '
BEGIN {
    total_size = 0;
    space_needed = max_file_size;
    error_flag = 0;
}

{
    gsub(/\t/, "  ");
    line = $0;
    line_length = length(line);

    if (line_length > max_line_len) {
        print "Error: Line " NR " is too long (" line_length " characters):" > "/dev/stderr";
        print line > "/dev/stderr";
        error_flag = 1;
        next;
    }

    if (line_length < max_line_len) {
        line = line sprintf("%-*s", max_line_len - line_length, "");
    }

    printf "%s", line;
    total_size += length(line);
}

END {
    if (error_flag == 1) {
        print "Processing ended with errors. File was not created." > "/dev/stderr";
        exit 1;
    }

    if (total_size < max_file_size) {
        space_needed = max_file_size - total_size;
        while (space_needed > 0) {
            printf "%s", " ";
            space_needed--;
        }

        print "Processing completed." > "/dev/stderr";
    }
}
' input.4th | iconv -f UTF-8 -t WINDOWS-1252 > out.atr
