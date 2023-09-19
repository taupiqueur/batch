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
	mandoc -I os= -T html -O style="man-style.css",man="https://man.archlinux.org/man/%N.%S" extra/man/batch.1 > extra/man/batch.1.html

test:
	crystal spec

release: clean build
	mkdir -p releases
	tar caf releases/$(name)-$(version)-$(target).tar.xz bin/batch extra/man/batch.1.gz extra/shell-completion/batch.bash extra/shell-completion/batch.zsh extra/shell-completion/batch.fish

install: build
	install -d ~/.local/bin ~/.local/share/man/man1 ~/.local/share/bash-completion/completions ~/.local/share/zsh/site-functions ~/.local/share/fish/vendor_completions.d
	install -m 0755 bin/batch ~/.local/bin
	install -m 0644 extra/man/batch.1.gz ~/.local/share/man/man1
	install -m 0644 extra/shell-completion/batch.bash ~/.local/share/bash-completion/completions
	install -m 0644 extra/shell-completion/batch.zsh ~/.local/share/zsh/site-functions/_batch
	install -m 0644 extra/shell-completion/batch.fish ~/.local/share/fish/vendor_completions.d

uninstall:
	rm -f ~/.local/bin/batch ~/.local/share/man/man1/batch.1.gz ~/.local/share/bash-completion/completions/batch.bash ~/.local/share/zsh/site-functions/_batch ~/.local/share/fish/vendor_completions.d/batch.fish

clean:
	git clean -d -f -X
