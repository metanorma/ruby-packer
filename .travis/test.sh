#!/bin/sh

set -uex

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
  OPENSSLDIR="/usr/local/etc/openssl"
  TEMP_DIR="$(mktemp -d)"
else
  OPENSSLDIR="/etc/ssl"
  TEMP_DIR="$(mktemp -d --tmpdir=$HOME .rubyc-build.XXXXXX)"
fi

mksquashfs -version

ruby -Ilib bin/rubyc bin/rubyc \
  --openssl-dir=${OPENSSLDIR} \
  --tmpdir=${TEMP_DIR} \
  --clean-tmpdir \
  --ignore-file=.git \
  --ignore-file=.gitignore \
  --ignore-file=.gitmodules \
  --ignore-file=CHANGELOG.md \
  --ignore-file=ruby.patch \
  --ignore-file=.travis.yml \
  --ignore-file=.travis/test.sh \
  --ignore-file=.travis/install_deps.sh \
  -o rubyc

strip rubyc || true

RUBY_VERSION=`./rubyc --ruby-version`
RUBYC_VERSION=`./rubyc --version`

echo "------------------------------------"
echo "Ruby version: $RUBY_VERSION"
echo "Rubyc version: $RUBYC_VERSION"
echo "------------------------------------"

bundle exec rake test

yes | gzip rubyc

if [ "$TRAVIS_TAG" = "" ]; then
  VERSION="${RUBY_VERSION}-${RUBYC_VERSION}"
else
  VERSION="${TRAVIS_TAG}"
fi

mv rubyc.gz rubyc-${VERSION}-${TRAVIS_OS_NAME}-amd64.gz
ls -al rubyc*gz
