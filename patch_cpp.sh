#!/usr/bin/env bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <path_to_cpp_file> <namespace>"
    exit 1
fi

file_path="$1"
namespace="$2"

if [ ! -f "$file_path" ]; then
    echo "Error: File does not exist."
    exit 1
fi

RESULT=$(sed "$(grep -n "^#include" ${file_path} | cut -d ':' -f 1 | tail -n 1) a\\
\\
namespace ${namespace} {\\

; /^#include <assert\\.h>\$/ d; s/^assert(/check(/; $ a\\
}\\
" ${file_path})

echo "$RESULT" > ${file_path}
