# Ruby Compiler

*Ahead-of-time (AOT) Compiler designed for Ruby, that just works.*

## Features

- Works on Linux, Mac and Windows
- Creates a binary distribution of your application
- Supports natively any form of `require` and `load`, including dynamic ones (e.g. `load(my_path + 'x.rb'`)
- Native C extensions are fully supported
- Rails applications are fully supported
- Open Source, MIT Licensed

## Get Started

It takes less than 5 minutes to compile any project with Ruby Compiler.

You won't need to modify a single line of code in your application, no matter how you developed it as long as it works in plain Ruby!

### Install on macOS

First install the prerequisites:

* [SquashFS Tools 4.3](http://squashfs.sourceforge.net/): `brew install squashfs`
* [Xcode](https://developer.apple.com/xcode/download/)
  * You also need to install the `Command Line Tools` via Xcode. You can find
    this under the menu `Xcode -> Preferences -> Downloads`
  * This step will install `gcc` and the related toolchain containing `make`
* [Ruby](https://www.ruby-lang.org/)

Then,

    curl -L https://github.com/metanorma/ruby-packer/releases/download/v0.6.0/rubyc-darwin-x64 > rubyc
    chmod +x rubyc
    ./rubyc --help

### Install on Linux

First install the prerequisites:

* [SquashFS Tools 4.3](http://squashfs.sourceforge.net/)
  - `sudo yum install squashfs-tools`
  - `sudo apt-get install squashfs-tools`
* `gcc` or `clang`
* GNU Make
* [Ruby](https://www.ruby-lang.org/)

Then,

    curl -L https://github.com/metanorma/ruby-packer/releases/download/v0.6.0/rubyc-linux-x64 > rubyc
    chmod +x rubyc
    ./rubyc --help

### Install on Windows

First install the prerequisites:

* [SquashFS Tools 4.3](https://github.com/pmq20/squashfuse/files/691217/sqfs43-win32.zip)
* [Visual Studio 2015 Update 3](https://www.visualstudio.com/), all editions
  including the Community edition (remember to select
  "Common Tools for Visual C++ 2015" feature during installation).
* [Ruby](https://www.ruby-lang.org/)

Then download rubyc-x64.zip,
and this zip file contains only one executable.
Unzip it. Optionally,
rename it to `rubyc.exe` and put it under `C:\Windows` (or any other directory that is part of `PATH`).
Execute `rubyc --help` from the command line.

## Usage

If ENTRANCE was not provided, then a single Ruby interpreter executable will be produced.
ENTRANCE can be either a file path, or a "x" string as in bundle exec "x".

    rubyc [OPTION]... [ENTRANCE]
      -r, --root=DIR                   The path to the root of the application
      -o, --output=FILE                The path of the output file
      -d, --tmpdir=DIR                 The directory for temporary files
      -c, --clean-tmpdir               Cleans temporary files before compiling
          --keep-tmpdir                Keeps all temporary files that were generated last time
          --make-args=ARGS             Extra arguments to be passed to make
          --nmake-args=ARGS            Extra arguments to be passed to nmake
          --debug                      Enable debug mode
      -v, --version                    Prints the version of rubyc and exit
          --ruby-version               Prints the version of the Ruby runtime and exit
          --ruby-api-version           Prints the version of the Ruby API and exit
      -h, --help                       Prints this help and exit


## Examples

### Producing a single Ruby interpreter executable

	rubyc
	./a.out (or a.exe on Windows)

### Bootstrapping Ruby Compiler itself

	git clone --depth 1 https://github.com/pmq20/ruby-compiler
	cd ruby-compiler
	rubyc bin/rubyc
	./a.out (or a.exe on Windows)

### Compiling a CLI tool

	git clone --depth 1 https://github.com/pmq20/node-compiler
	cd node-compiler
	rubyc bin/nodec
	./a.out (or a.exe on Windows)

### Compiling a Rails application

	rails new yours
	cd yours
	rubyc bin/rails
	./a.out server (or a.exe server on Windows)

### Compiling a Gem

	rubyc --gem=bundler bundle
	./a.out (or a.exe on Windows)

## See Also

- [Libsquash](https://github.com/pmq20/libsquash): portable, user-land SquashFS that can be easily linked and embedded within your application.
