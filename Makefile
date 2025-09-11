PREFIX ?= $(HOME)/.local

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
	tar caf releases/$(name)-$(version)-$(target).tar.xz bin/batch extra/man/batch.1.gz extra/shell-completion/batch.bash extra/shell-completion/batch.zsh extra/shell-completion/batch.fish extra/shell-completion/batch-completions.elv extra/shell-completion/batch-completions.nu

install: build
	install -d $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/share/man/man1 $(DESTDIR)$(PREFIX)/share/bash-completion/completions $(DESTDIR)$(PREFIX)/share/zsh/site-functions $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d $(DESTDIR)$(PREFIX)/share/elvish/lib $(DESTDIR)$(PREFIX)/share/nushell/vendor/autoload
	install -m 0755 bin/batch $(DESTDIR)$(PREFIX)/bin
	install -m 0644 extra/man/batch.1.gz $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 0644 extra/shell-completion/batch.bash $(DESTDIR)$(PREFIX)/share/bash-completion/completions
	install -m 0644 extra/shell-completion/batch.zsh $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_batch
	install -m 0644 extra/shell-completion/batch.fish $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d
	install -m 0644 extra/shell-completion/batch-completions.elv $(DESTDIR)$(PREFIX)/share/elvish/lib
	install -m 0644 extra/shell-completion/batch-completions.nu $(DESTDIR)$(PREFIX)/share/nushell/vendor/autoload

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/batch $(DESTDIR)$(PREFIX)/share/man/man1/batch.1.gz $(DESTDIR)$(PREFIX)/share/bash-completion/completions/batch.bash $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_batch $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d/batch.fish $(DESTDIR)$(PREFIX)/share/elvish/lib/batch-completions.elv $(DESTDIR)$(PREFIX)/share/nushell/vendor/autoload/batch-completions.nu

clean:
	git clean -d -f -X
