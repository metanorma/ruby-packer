#!/bin/sh

set -uex

cd vendor/yaml && ./bootstrap && cd -
cd vendor/libffi && ./autogen.sh && ./configure && cd -

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
  ls /usr/local/opt/gettext/bin/autopoint
  export PATH=/usr/local/opt/gettext/bin:$PATH
else
  apt-get update
  apt-get install -y -q autopoint
fi
which autopoint
cd vendor/gdbm && ./bootstrap && ./configure && cd -

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  chmod -R a+x vendor/gdbm
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
  brew update
  brew install squashfs
  brew install texinfo
  brew install openssl
else
  apt-get update
  apt-get install -y -q openssl squashfs-tools curl install-info info texinfo texi2html
fi
