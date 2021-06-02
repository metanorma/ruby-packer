.PHONY: all clean

all: clean-binary ruby

ruby: .build/ruby.tar.gz
	tar xzf .build/ruby.tar.gz
	mv ruby-* ruby
	git apply --verbose .patches/*.patch

.build/ruby.tar.gz:
	mkdir -p .build
	curl -L https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.0.tar.gz > .build/ruby.tar.gz

clean: clean-archive clean-source clean-binary

clean-archive:
	rm -rvf .build

clean-source:
	rm -rvf ruby

clean-binary:
	rm -vf rubyc-linux-x64
