#! /bin/bash

set -eu

OPTIONS="contract config format corpus-dir test-limit test-mode shrink-limit \
seq-len contract-addr deployer sender seed crytic-args solc-args"

SWITCHES="multi-abi"

# smoelius: `get` works for non-standard variable names like `INPUT_CORPUS-DIR`.
get() {
    env | sed -n "s/^$1=\(.*\)/\1/;T;p"
}

compatibility_link()
{
    HOST_GITHUB_WORKSPACE="$(get INPUT_INTERNAL-GITHUB-WORKSPACE | tr -d \")"
    if [[ -d "$GITHUB_WORKSPACE" ]]; then
        mkdir -p "$(dirname "$HOST_GITHUB_WORKSPACE")"
        ln -s "$GITHUB_WORKSPACE" "$HOST_GITHUB_WORKSPACE"
        echo "[-] Applied compatibility link: $HOST_GITHUB_WORKSPACE -> $GITHUB_WORKSPACE"
    fi
}

compatibility_link

CMD=(echidna-test "$INPUT_FILES")

for OPTION in $OPTIONS; do
    NAME=INPUT_"${OPTION^^}"
    VALUE="$(get "$NAME")"
    if [[ -n "$VALUE" ]]; then
        CMD+=(--"$OPTION" "$VALUE")
    fi
done

for SWITCH in $SWITCHES; do
    NAME=INPUT_"${SWITCH^^}"
    VALUE="$(get "$NAME")"
    if [[ -n "$VALUE" ]]; then
        CMD+=(--"$SWITCH")
    fi
done

echo "Echidna version: $(echidna-test --version)" >&2
echo "Echidna command line: ${CMD[@]}" >&2
echo >&2

SOLC_VERSION="$(get 'INPUT_SOLC-VERSION')"
if [[ -n "$SOLC_VERSION" ]]; then
    solc-select install "$SOLC_VERSION"
    solc-select use "$SOLC_VERSION"
fi

OUTPUT_FILE="$(get 'INPUT_OUTPUT-FILE')"
if [[ -n "$OUTPUT_FILE" ]]; then
    echo "::set-output name=output-file::$OUTPUT_FILE"
    # tee stdout to $OUTPUT_FILE to capture echidna's output
    exec > >(tee "$OUTPUT_FILE")
fi

WORKDIR="$(get 'INPUT_ECHIDNA-WORKDIR')"
if [[ -n "$WORKDIR" ]]; then
    cd "$WORKDIR"
fi

if [[ -n "$(get 'INPUT_NEGATE-EXIT-STATUS')" ]]; then
    ! "${CMD[@]}"
else
    "${CMD[@]}"
fi
