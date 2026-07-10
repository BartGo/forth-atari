
#!/usr/bin/env bash

# manage includes
# usage: ./preproc.sh input.txt output.txt
# include expression format: { $$file.ext }

set -uo pipefail

MAX_DEPTH=100

declare -A active
declare -a stack

process() {
    local file="$1"
    local depth="$2"

    [[ -f "$file" ]] || {
        echo "ERROR: include file not found: $file" >&2
        return 1
    }

    (( depth <= MAX_DEPTH )) || {
        echo "ERROR: maximum include depth exceeded ($MAX_DEPTH)" >&2
        return 1
    }

    if [[ -n "${active[$file]:-}" ]]; then
        echo "ERROR: circular include detected:" >&2

        local sep=""
        for f in "${stack[@]}"; do
            printf "%s%s" "$sep" "$f" >&2
            sep=" -> "
        done
        printf " -> %s\n" "$file" >&2

        return 1
    fi

    active["$file"]=1
    stack+=("$file")

    while IFS= read -r line || [[ -n "$line" ]]; do


		if [[ "$line" =~ \$\$([^[:space:]}]+) ]]; then
			inc="${BASH_REMATCH[1]}"
			process "$inc" $((depth + 1)) || return 1
			echo
		else
			echo "$line"
		fi


    done < "$file"

    unset 'active[$file]'
    unset 'stack[${#stack[@]}-1]'
}

main() {

    [[ $# -eq 2 ]] || {
        echo "usage: $0 input.txt output.txt" >&2
        exit 1
    }

    local input="$1"
    local output="$2"

    [[ -f "$input" ]] || {
        echo "ERROR: input file not found: $input" >&2
        exit 1
    }

    clear
    echo "Please wait, preprocessing..."

    local tmp="${output}.tmp"

    if process "$input" 0 > "$tmp"; then
        mv "$tmp" "$output"
        echo "Done."
    else
        rm -f "$tmp"
        echo "Failed." >&2
        exit 1
    fi
}

main "$@"
