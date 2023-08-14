# General options
name = batch
version = $(shell git describe --tags --always)
target = $(shell llvm-config --host-target)

# Build options
static = no

ifeq ($(static),yes)
  flags += --static
endif

build:
	shards build --release $(flags)
	gzip -9 -f -k extra/man/batch.1

test:
	crystal spec

release: clean build
	mkdir -p releases
	tar caf releases/$(name)-$(version)-$(target).tar.xz bin/batch extra/man/batch.1.gz extra/shell-completion/batch.bash

install: build
	install -d ~/.local/bin ~/.local/share/man/man1 ~/.local/share/bash-completion/completions
	install -m 0755 bin/batch ~/.local/bin
	install -m 0644 extra/man/batch.1.gz ~/.local/share/man/man1
	install -m 0644 extra/shell-completion/batch.bash ~/.local/share/bash-completion/completions

uninstall:
	rm -f ~/.local/bin/batch ~/.local/share/man/man1/batch.1.gz ~/.local/share/bash-completion/completions/batch.bash

clean:
	git clean -d -f -X
