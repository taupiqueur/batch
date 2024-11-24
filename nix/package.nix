{
  stdenv,
  crystal,
  shards,
  llvm,
  git,
  mandoc,
  ...
}:

stdenv.mkDerivation {
  pname = "batch";
  version = "0.1.0";
  src = ../.;
  nativeBuildInputs = [
    crystal
    shards
    llvm
    git
    mandoc
  ];
  makeFlags = [
    "PREFIX=$(out)"
  ];
}
