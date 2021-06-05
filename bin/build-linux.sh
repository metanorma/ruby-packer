#!/bin/bash

set -e

export TEMP_DIR="$(mktemp -d .rubyc-build.XXXXXX)";
cp -r * $TEMP_DIR;
bin/rubyc --clean-tmpdir -r "$TEMP_DIR" -o rubyc-linux-x64 "$TEMP_DIR/bin/rubyc"
strip rubyc-linux-x64
