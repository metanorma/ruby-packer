#!/bin/bash

env CC="xcrun clang -mmacosx-version-min=10.10 -Wno-implicit-function-declaration" bin/rubyc --clean-tmp bin/rubyc -o rubyc-darwin-x64
