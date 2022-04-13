# batch

batch is a tool for batch processing using your favorite text editor.

``` sh
batch -e vi -p : -m 'mv -vi --' -d 'rm -vi --'
```

See [Usage] for examples.

[Usage]: docs/manual.md#usage

## Features

- Uses your favorite text editor for batch processing.
- Customizable **pick**, **map** and **drop** actions.
- Automate repetitive tasks with external filters—such as [tr], [sed] or [awk][gawk]—before invoking the editor.
- Lets you review inlined actions in your text editor before processing.

[tr]: https://man.openbsd.org/tr
[sed]: https://gnu.org/software/sed/
[gawk]: https://gnu.org/software/gawk/

## Installation

### Nightly builds

Download the [Nightly builds].

[Nightly builds]: https://github.com/taupiqueur/batch/releases/nightly

### Build from source

[Install Crystal] with [the shards command].

[Install Crystal]: https://crystal-lang.org/install/
[The shards command]: https://crystal-lang.org/reference/master/the_shards_command/

``` sh
git clone https://github.com/taupiqueur/batch.git
cd batch
make install
```

## Documentation

See the [manual] for setup and usage instructions.

[Manual]: docs/manual.md
