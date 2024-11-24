{
  mkShell,
  crystal,
  shards,
  llvm,
  git,
  mandoc,
  ...
}:

mkShell {
  packages = [
    crystal
    shards
    llvm
    git
    mandoc
  ];
}
