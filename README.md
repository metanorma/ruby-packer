# Ruby Compiler

*Ahead-of-time (AOT) Compiler designed for Ruby, that just works.*

[![Status](https://ci.appveyor.com/api/projects/status/93i36eliiy6v3686/branch/master?svg=true)](https://ci.appveyor.com/project/pmq20/ruby-compiler/branch/master)
[![Status](https://travis-ci.org/pmq20/ruby-compiler.svg?branch=master)](https://travis-ci.org/pmq20/ruby-compiler)
[![GitHub version](https://badge.fury.io/gh/pmq20%2Fruby-compiler.svg)](https://badge.fury.io/gh/pmq20%2Fruby-compiler)

## Features

- Works on Linux, Mac and Windows
- Creates a binary distribution of your application
- Supports natively any form of `require` and `load`, including dynamic ones (e.g. `load(my_path + 'x.rb'`)
- Features zero-config auto-update capabilities to make your compiled project to stay updated
- Native C extensions are fully supported
- Rails applications are fully supported
- Open Source, MIT Licensed

## Get Started

It takes less than 5 minutes to compile any project with Ruby Compiler.

You won't need to modify a single line of code in your application, no matter how you developed it as long as it works in plain Ruby!

|                       | Architecture |           Latest&#160;Stable                 |
|:---------------------:|:------------:|----------------------------------------------|
|       **macOS**       |    x86-64    | http://enclose.io/rubyc/rubyc-darwin-x64.gz  |
|       **Linux**       |    x86-64    | http://enclose.io/rubyc/rubyc-linux-x64.gz   |
|      **Windows**      |    x86-64    | http://enclose.io/rubyc/rubyc-x64.zip        |

For previous releases, cf. http://enclose.io/rubyc

### Install on macOS

First install the prerequisites:

* [SquashFS Tools 4.3](http://squashfs.sourceforge.net/): `brew install squashfs`
* [Xcode](https://developer.apple.com/xcode/download/)
  * You also need to install the `Command Line Tools` via Xcode. You can find
    this under the menu `Xcode -> Preferences -> Downloads`
  * This step will install `gcc` and the related toolchain containing `make`
* [Ruby](https://www.ruby-lang.org/)

Then,

    curl -L http://enclose.io/rubyc/rubyc-darwin-x64.gz | gunzip > rubyc
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

    curl -L http://enclose.io/rubyc/rubyc-linux-x64.gz | gunzip > rubyc
    chmod +x rubyc
    ./rubyc --help

### Install on Windows

First install the prerequisites:

* [SquashFS Tools 4.3](https://github.com/pmq20/squashfuse/files/691217/sqfs43-win32.zip)
* [Visual Studio 2015 Update 3](https://www.visualstudio.com/), all editions
  including the Community edition (remember to select
  "Common Tools for Visual C++ 2015" feature during installation).
* [Ruby](https://www.ruby-lang.org/)

Then download [rubyc-x64.zip](http://enclose.io/rubyc/rubyc-x64.zip),
and this zip file contains only one executable.
Unzip it. Optionally,
rename it to `rubyc.exe` and put it under `C:\Windows` (or any other directory that is part of `PATH`).
Execute `rubyc --help` from the command line.

### Install and use Clang on windows

SEQUENCE:
----------
0. Install MSVS2019(at least MSVC v142, Win10SDK 10.0.18362, cmake, clang)
   (c:\Program Files (x86)\Microsoft Visual Studio\2019\Community\ - default installation path)
1. Install clang 9.0.0 or 8.0.1 (http://releases.llvm.org/9.0.0/LLVM-9.0.0-win64.exe)
   (during installation be sure checkbox 'add clang to %PATH%' set)
2. Install ruby 2.6.5-1 devkit x64
   (https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.5-1/rubyinstaller-devkit-2.6.5-1-x64.exe)
3. Install bison and flex
 3.1 Install bison (http://gnuwin32.sourceforge.net/downlinks/bison.php)
   (Path for installation: "C:\bison" - be sure path has no spaces!!!)
 3.2 Install flex (http://gnuwin32.sourceforge.net/downlinks/flex.php)
 3.3 add bison and flex to path
   set PATH=%PATH%;C:\bison\bin\
5. Set %PATH% for msvc
   set PATH=%PATH%;C:\mcvc2015\VC\bin\
6. Set envs, libs and headers paths from windows sdk etc.
   For MSVS 2019 execute in shell:
   "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
7. Install sed:
   http://sourceforge.net/projects/gnuwin32/files//sed/4.2.1/sed-4.2.1-setup.exe/download
8. Install choco and squashfs tools
   Run powershell as administrator
   Get-ExecutionPolicy			- should be not 'Restricted'
   Set-ExecutionPolicy AllSigned
   Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
   [close/reopen power shell with admin rights]
   choco install --yes squashfs

Build rubyc with clang:
-----
   ruby -Ilib bin\rubyc bin\rubyc -c -o rubyc --nmake-args=CC=clang-cl

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
          --auto-update-url=URL        Enables auto-update and specifies the URL to get the latest version
          --auto-update-base=STRING    Enables auto-update and specifies the base version string
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
- [Libautoupdate](https://github.com/pmq20/libautoupdate): cross-platform C library to enable your application to auto-update itself in place.
