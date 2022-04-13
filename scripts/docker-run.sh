# GitHub Actions fails with “the input device is not a TTY”.
[ -t 1 ] && flags='--interactive --tty'
docker build --tag batch .
docker run $flags --mount "type=bind,source=$PWD,destination=/app" --workdir=/app batch "$@"
