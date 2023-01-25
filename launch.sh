#!/bin/bash

IMAGE=$1
INPUTS=$(env | cut -f1 -d= | grep '^INPUT_')

CMD=(docker run --rm -v "$PWD:/github/workspace" --workdir /github/workspace -e GITHUB_WORKSPACE=/github/workspace)

for VARNAME in $INPUTS; do
    CMD+=(-e "$VARNAME")
done

CMD+=("$IMAGE")

"${CMD[@]}"
