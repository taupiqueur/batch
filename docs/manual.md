# Manual

## Name

```
batch - A tool for batch processing using your favorite text editor.
```

## Synopsis

```
batch [switches] [--] [arguments]
```

## Description

batch is a tool for batch processing using your favorite text editor.

``` sh
batch -e vi -p : -m 'mv -vi --' -d 'rm -vi --'
```

## Usage

Run the following in your terminal.

``` sh
batch *

# The above is equivalent to:
ls | batch
```

This command opens the directory contents in an external editor.

Alternatively, enter `batch` in your terminal, paste the following text and hit `Control+D`.

```
Star Platinum.png
Magician's Red.png
Hermit Purple.png
Hierophant Green.png
Silver Chariot.png
The Fool.png
```

You can also create these files with the `batch -E -p touch` command.

After you edit and save the file, it will generate a shell script
which does the specified actions according to the changes you did in the file.

**Edited file**:

```
star-platinum.png

hermit-purple.png

silver-chariot.png

```

**Generated shell script**:

``` sh
# This file will be executed when you close the editor.
# Please double-check everything, clear the file to abort.

# Action on unchanged items.
pick() {
  echo "$1"
}

# Action on modified items.
map() {
  echo "$1" "$2"
}
map 'Star Platinum.png' 'star-platinum.png'
map 'Hermit Purple.png' 'hermit-purple.png'
map 'Silver Chariot.png' 'silver-chariot.png'

# Action on deleted items.
drop() {
  echo "$1"
}
drop 'Magician'"'"'s Red.png'
drop 'Hierophant Green.png'
drop 'The Fool.png'
```

This shell script is opened in an editor for you to review.
After you close it, it will be executed.

### Advanced usage

batch lets you apply external filters—such as [tr], [sed] or [awk][gawk]—before invoking the editor:

``` sh
batch -f 'sed "s/ /-/g"'
```

This option can be used to ease your editing.

[tr]: https://man.openbsd.org/tr
[sed]: https://gnu.org/software/sed/
[gawk]: https://gnu.org/software/gawk/

Combined with the `--no-edit` flag, batch can be fully automated:

``` sh
batch -f 'sed "s/ /-/g"' -E -m 'echo mv -vi --'
```

Finally, you might want to specify a shell script for your actions:

``` sh
batch -M 'mkdir -vp -- "$(dirname -- "$2")" && mv -vi -- "$1" "$2"'
```

This command allows you to automatically create the destination directory when renaming files.

### In practice?

Depending on my situation here are the tools I use:

- I use [Kakoune] to edit items and [tr] / [iconv] for pre-editing.
- I use [fd] to find entries.

[Kakoune]: https://kakoune.org
[tr]: https://man.openbsd.org/tr
[iconv]: https://manned.org/iconv
[fd]: https://github.com/sharkdp/fd

Since batch does not try to load config files from a specific folder at startup,
the best way to emulate this is by creating an alias in your shell profile.

Here is my personal configuration:

``` sh
# interactive map
imap() {
  batch -f 'iconv -f UTF-8 -t ASCII//TRANSLIT//IGNORE' -f 'tr [:upper:] [:lower:]' -f "tr -s \\'[:blank:] -" -f 'tr -d ?!,' "$@"
}

# auto map
amap() {
  imap -E "$@"
}

# interactive mv
imv() {
  imap -p : -M 'mkdir -vp -- "$(dirname -- "$2")" && mv -vi -- "$1" "$2"' -d 'rm -vi --' "$@"
}
```

## Examples

``` sh
# Process files in the current working directory.
batch *

# Process files from argv.
batch *.png

# Process files from stdin.
find . -type f | batch
```

## Options

###### `-p <command>`
###### `--pick-command=<command>`

Specifies the command to run on unchanged items.

Default is `echo`.

###### `-m <command>`
###### `--map-command=<command>`

Specifies the command to run on modified items.

Default is `echo`.

###### `-d <command>`
###### `--drop-command=<command>`

Specifies the command to run on deleted items.

Default is `echo`.

###### `-P <command>`
###### `--pick-shell-script=<command>`

Specifies the shell script to run on unchanged items.

###### `-M <command>`
###### `--map-shell-script=<command>`

Specifies the shell script to run on modified items.

###### `-D <command>`
###### `--drop-shell-script=<command>`

Specifies the shell script to run on deleted items.

###### `-e <command>`
###### `--editor=<command>`

Specifies the editor to use.

Default is fetch from the `EDITOR` environment variable.

###### `-f <command>`
###### `--filter=<command>`

Adds a filter (repeatable).

###### `-E`
###### `--no-edit`

Do not open editor.

###### `--no-pick`

Do not pick items.

###### `--no-map`

Do not map items.

###### `--no-drop`

Do not drop items.

###### `-`

Read items from **stdin**.

###### `-h`
###### `--help`

Show this help.

###### `-v`
###### `--version`

Show version.

## Environment

The following environment variables have an effect on `batch`.

###### EDITOR

Configures the default text editor.
