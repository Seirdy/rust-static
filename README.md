rust-static
===========

Yet another musl-based OCI image to compile statically-linked Rust programs.

Unlike some similar projects, this container is Alpine-based; however, that does not
mean that it's small.

Example usage
-------------

``` {.sh}
musl_env() {
	podman run --rm -it \
		-v "$PWD:/root/src" \
		-v "$CARGO_HOME/registry:/root/.cargo/registry" \
		-e CFLAGS -e CXXFLAGS -e CPPFLAGS -e CC -e CXX -e LIBLDFLAGS -e MAKEFLAGS -e LDFLAGS  -e RUSTFLAGS\
		rust-static "$@"
}

# basically cargo build --release for static binaries
cargo_static_lto() {
	musl_env cargo build --release --target=x86_64-unknown-linux-musl \
}
```
