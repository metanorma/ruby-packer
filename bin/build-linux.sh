#!/bin/bash

RUBY_VERSION=$(cat .ruby-version)
docker run -v $(pwd):/rubyc -w /rubyc ruby:$RUBY_VERSION bash -c '
apt-get update -y && apt-get install -y squashfs-tools bison flex texinfo;
echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections;
export TEMP_DIR="$(mktemp -d .rubyc-build.XXXXXX)";
cp -r * $TEMP_DIR;
bin/rubyc --clean-tmpdir -r "$TEMP_DIR" -o rubyc-linux-x64 "$TEMP_DIR/bin/rubyc"
'
