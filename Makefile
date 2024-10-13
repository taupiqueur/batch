# General options
name = batch
version = $(shell git describe --tags --always)
target = $(shell llvm-config --host-target)

# Build options
static = no

ifeq ($(static),yes)
  flags += --static
endif

# Installation directories
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
BASH_COMPLETION_DIR ?= $(PREFIX)/share/bash-completion/completions
ZSH_COMPLETION_DIR ?= $(PREFIX)/share/zsh/site-functions
FISH_COMPLETION_DIR ?= $(PREFIX)/share/fish/vendor_completions.d
DESTDIR ?=

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
	install -d $(DESTDIR)$(BINDIR) $(DESTDIR)$(MANDIR) $(DESTDIR)$(BASH_COMPLETION_DIR) $(DESTDIR)$(ZSH_COMPLETION_DIR) $(DESTDIR)$(FISH_COMPLETION_DIR)
	install -m 0755 bin/batch $(DESTDIR)$(BINDIR)
	install -m 0644 extra/man/batch.1.gz $(DESTDIR)$(MANDIR)
	install -m 0644 extra/shell-completion/batch.bash $(DESTDIR)$(BASH_COMPLETION_DIR)/batch
	install -m 0644 extra/shell-completion/batch.zsh $(DESTDIR)$(ZSH_COMPLETION_DIR)/_batch
	install -m 0644 extra/shell-completion/batch.fish $(DESTDIR)$(FISH_COMPLETION_DIR)/batch.fish

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/batch \
		 $(DESTDIR)$(MANDIR)/batch.1.gz \
		 $(DESTDIR)$(BASH_COMPLETION_DIR)/batch \
		 $(DESTDIR)$(ZSH_COMPLETION_DIR)/_batch \
		 $(DESTDIR)$(FISH_COMPLETION_DIR)/batch.fish

clean:
	git clean -d -f -X
