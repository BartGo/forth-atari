
# this:
#   txt -> atari forth line-32 screen file (atr, NO HEADER)

# reverse:
#   fold -b -w 32 out.atr > out.fld
#   sed -e :a -e 'N;s/\n\s*$//;ta' out.fld > out.4th

# atr2txt:
#     tail +17c  source.atr > noheader.atr # general valforth & apxforth, remove header
#   OR:
#     tail +1041 source.atr > noheader.atr # hack for apxforth (17+1024), remove header and "difficulties" (carefully)
#   THEN:
#   fold -b -w 32 ./noheader.ATR > temp.txt

# FIXME: sometimes wrongly removes empty lines mid-file

timestamp=$(date "+%Y%m%d-%H%M%S")

awk -v max_line_len=64 -v max_file_size=92160 '
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

    if (line_length< max_line_len ) {
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
' LINER.4TH | iconv -f UTF-8 -t WINDOWS-1252 > "OUTPUT-$timestamp.ATR"
