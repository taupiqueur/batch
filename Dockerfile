FROM alpine:edge
RUN apk add make git llvm19-dev gzip xz mandoc crystal shards musl-dev openssl-dev openssl-libs-static yaml-static
WORKDIR /app
COPY . .
# GitHub Actions fails with “fatal: unsafe repository ('/app' is owned by someone else)”.
RUN git config set --global --append safe.directory /app
RUN make static=yes
CMD ["sh"]
