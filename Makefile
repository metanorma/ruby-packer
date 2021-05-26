.PHONY: all clean

all: rubyc-linux-x64

rubyc-linux-x64: ruby
	#./bin/build-linux.sh

ruby: .build/ruby.tar.gz
	tar xzf .build/ruby.tar.gz
	mv ruby-* ruby
	git apply --verbose .patches/*.patch

.build/ruby.tar.gz:
	mkdir -p .build
	curl -L https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.4.tar.gz > .build/ruby.tar.gz

clean:
	rm -rvf .build ruby rubyc-linux-x64
