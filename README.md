# batch

batch is a tool for batch processing using your favorite text editor.

The command takes a list of items, lets you edit the list in your favorite text editor,
then generates a shell script to batch process unchanged items, renamed items, and deleted items.
You can edit the script to add your own logic for how to process each kind of item, and then run it.

By default, the batch utility reads a list of items from standard input
and writes unchanged items, renamed items, and deleted items to standard output.

In addition to interactive use,
you can supply shell script fragments to automate the editing and batch processing stages.

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

## Contributing

Report bugs on the [issue tracker],
ask questions on the [IRC channel],
send patches on the [mailing list].

[Issue tracker]: https://github.com/taupiqueur/batch/issues
[IRC channel]: https://web.libera.chat/gamja/#taupiqueur
[Mailing list]: https://github.com/taupiqueur/batch/pulls
