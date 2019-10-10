#!/bin/sh

set -uex

cd vendor/yaml && ./bootstrap && cd -
cd vendor/libffi && ./autogen.sh && ./configure && cd -

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
  ls /usr/local/opt/gettext/bin/autopoint
  export PATH=/usr/local/opt/gettext/bin:$PATH
else
  sudo apt-get update
  sudo apt-get install -y -q autopoint
fi
which autopoint
cd vendor/gdbm && ./bootstrap && ./configure && cd -

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  sudo chmod -R 777 vendor/gdbm
  ls -lah vendor/gdbm
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
  brew update
  brew install squashfs
  brew install texinfo
  brew install openssl
else
  sudo apt-get update
  sudo apt-get install -y -q openssl squashfs-tools curl install-info info texinfo texi2html
fi
