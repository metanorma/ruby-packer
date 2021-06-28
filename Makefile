RUBY_VERSION = 2.6.3
BUNDLER_VERSION = 2.2.3
GDBM_VERSION = 1.13
LIBFFI_VERSION = 3.2.1
NCURSES_VERSION = 6.2
OPENSSL_VERSION = 1.1.0f
READLINE_VERSION = 7.0
YAML_VERSION = 0.1.7
ZLIB_VERSION = 1.2.11

RUBY_URL = https://cache.ruby-lang.org/pub/ruby/$(basename $(RUBY_VERSION))/ruby-$(RUBY_VERSION).tar.gz
BUNDLER_URL = https://rubygems.org/downloads/bundler-$(BUNDLER_VERSION).gem
GDBM_URL = https://ftp.gnu.org/pub/gnu/gdbm/gdbm-$(GDBM_VERSION).tar.gz
LIBFFI_URL = https://gcc.gnu.org/pub/libffi/libffi-$(LIBFFI_VERSION).tar.gz
NCURSES_URL = https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$(NCURSES_VERSION).tar.gz
OPENSSL_URL = https://www.openssl.org/source/old/1.1.0/openssl-$(OPENSSL_VERSION).tar.gz
READLINE_URL = https://ftp.gnu.org/gnu/readline/readline-$(READLINE_VERSION).tar.gz
YAML_URL = https://pyyaml.org/download/libyaml/yaml-$(YAML_VERSION).tar.gz
ZLIB_URL = https://zlib.net/zlib-$(ZLIB_VERSION).tar.gz

# To avoid removal of intermediate files
.SECONDARY:

.PHONY: usage linux macos dependencies vendor clean

.DEFAULT_GOAL := usage

usage:
	@echo "Please use either 'make linux', or 'make macos'."
	@exit 1

linux: rubyc-linux-x64

rubyc-linux-x64: dependencies
	$(eval TEMP_DIR := $(shell mktemp -d .rubyc-build.XXXXXX))
	cp -r * $(TEMP_DIR)
	bin/rubyc --clean-tmpdir --root "$(TEMP_DIR)" --output $@ "$(TEMP_DIR)/bin/rubyc"
	strip $@

macos: rubyc-darwin-x64

rubyc-darwin-x64: dependencies
	env CC="xcrun clang -mmacosx-version-min=10.10 -Wno-implicit-function-declaration" bin/rubyc --clean-tmpdir --output $@ bin/rubyc

dependencies: clean-binary ruby vendor

vendor: vendor/gdbm vendor/libffi vendor/ncurses vendor/openssl \
        vendor/readline vendor/yaml vendor/zlib

ruby: .archives/ruby-$(RUBY_VERSION).tar.gz
	tar xzf .archives/ruby-$(RUBY_VERSION).tar.gz
	mv ruby-$(RUBY_VERSION) ruby
	git apply --verbose .patches/ruby/*.patch
	$(MAKE) ruby/vendor/bundler-$(BUNDLER_VERSION).gem

ruby-orig: .archives/ruby-$(RUBY_VERSION).tar.gz
	tar xzf .archives/ruby-$(RUBY_VERSION).tar.gz
	mv ruby-$(RUBY_VERSION) ruby

ruby/vendor/bundler-$(BUNDLER_VERSION).gem: .archives/bundler-$(BUNDLER_VERSION).gem
	mkdir -p $(dir $@) && cp $< $@
.archives/bundler-$(BUNDLER_VERSION).gem:
	curl -sSL --create-dirs -o $@ $(BUNDLER_URL)

.archives/ruby-$(RUBY_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(RUBY_URL)

vendor/gdbm: .archives/gdbm-$(GDBM_VERSION).tar.gz
	cd vendor && tar xzf ../.archives/gdbm-$(GDBM_VERSION).tar.gz && mv gdbm-$(GDBM_VERSION) gdbm
	git apply --verbose .patches/gdbm/*.patch
.archives/gdbm-$(GDBM_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(GDBM_URL)

vendor/libffi: .archives/libffi-$(LIBFFI_VERSION).tar.gz
	cd vendor && tar xzf ../.archives/libffi-$(LIBFFI_VERSION).tar.gz && mv libffi-$(LIBFFI_VERSION) libffi
.archives/libffi-$(LIBFFI_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(LIBFFI_URL)

vendor/ncurses: .archives/ncurses-$(NCURSES_VERSION).tar.gz
	cd vendor && tar xzf ../.archives/ncurses-$(NCURSES_VERSION).tar.gz && mv ncurses-$(NCURSES_VERSION) ncurses
.archives/ncurses-$(NCURSES_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(NCURSES_URL)

vendor/openssl: .archives/openssl-$(OPENSSL_VERSION).tar.gz
	cd vendor && tar xzf ../.archives/openssl-$(OPENSSL_VERSION).tar.gz && mv openssl-$(OPENSSL_VERSION) openssl
.archives/openssl-$(OPENSSL_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(OPENSSL_URL)

vendor/readline: .archives/readline-$(READLINE_VERSION).tar.gz
	cd vendor && tar xzf ../.archives/readline-$(READLINE_VERSION).tar.gz && mv readline-$(READLINE_VERSION) readline
.archives/readline-$(READLINE_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(READLINE_URL)

vendor/yaml: .archives/yaml-$(YAML_VERSION).tar.gz
	cd vendor && tar xzf ../.archives/yaml-$(YAML_VERSION).tar.gz && mv yaml-$(YAML_VERSION) yaml
.archives/yaml-$(YAML_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(YAML_URL)

vendor/zlib: .archives/zlib-$(ZLIB_VERSION).tar.gz
	cd vendor && tar xzf ../.archives/zlib-$(ZLIB_VERSION).tar.gz && mv zlib-$(ZLIB_VERSION) zlib
.archives/zlib-$(ZLIB_VERSION).tar.gz:
	curl -sSL --create-dirs -o $@ $(ZLIB_URL)

clean-all: clean clean-archives
clean: clean-ruby clean-vendor clean-binary clean-build

clean-archives:
	rm -rf .archives

clean-ruby:
	rm -rf ruby

clean-vendor: clean-vendor-gdbm clean-vendor-libffi clean-vendor-ncurses \
              clean-vendor-openssl clean-vendor-readline clean-vendor-yaml clean-vendor-zlib

clean-vendor-%:
	rm -rf vendor/$(*)

clean-binary:
	rm -f rubyc-*-x64

clean-build:
	rm -rf .rubyc-build.*
