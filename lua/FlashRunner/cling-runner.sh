#!/usr/bin/env bash
set -euo pipefail


# steps:
# cat code.cpp | run_cpp_cling.sh
# run_cpp_cling.sh filename.cpp


TIMEOUT_SECONDS=5
TMPDIR=$(mktemp -d /tmp/cling-run.XXXXXX)
OUT=$TMPDIR/out.txt
ERR=$TMPDIR/err.txt
CODEFILE=$TMPDIR/code.cpp


if [[ $# -eq 0 ]]; then
    cat - > "$CODEFILE"
else
    cp "$1" "$CODEFILE"
fi




# Run with timeout to protect runaway code
if command -v timeout &>/dev/null; then
    timeout "$TIMEOUT_SECONDS" cling -l "$CODEFILE" >"$OUT" 2>"$ERR" || true
else
    cling -l "$CODEFILE" >"$OUT" 2>"$ERR" || true
fi


EXIT_CODE=$?


# Print structured output (first line is exit code)
echo "%s\n" "$EXIT_CODE"
echo "---STDOUT---\n"
cat "$OUT"
echo "\n---STDERR---\n"
cat "$ERR"


rm -rf "$TMPDIR
