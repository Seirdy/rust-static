rust-static
===========

[![GitLab](https://img.shields.io/badge/repository-GitLab-orange.svg?logo=gitlab)](https://gitlab.com/Seirdy/rust-static)
[![GitHub
mirror](https://img.shields.io/badge/mirror-GitHub-black.svg?logo=github)](https://github.com/Seirdy/rust-static)
[![Container Repository on
Quay](https://quay.io/repository/seirdy/rust-static/status "Docker Repository on Quay")](https://quay.io/repository/seirdy/rust-static)

`rust-static` is yet another musl-based OCI image to compile statically-linked Rust
programs.

Unlike some similar projects, this container is Alpine-based; however, it's not as
tiny as you might think. Several packages have been pre-installed to allow building
some popular rust programs.

The following packages can be built in this container:

- [lsd](github.com/Peltoche/lsd)
- [fd](github.com/sharkdp/fd)
- [diskus](github.com/sharkdp/diskus)
- [eva](github.com/NerdyPepper/eva)
- [roflcat](github.com/jameslzhu/roflcat)

Example usage
-------------

Sourcing this shell script will provide the `cargo_static` function, which behaves
like the `cargo` command but runs everything inside the `rust-static` container.
Executables built using `cargo_static` will be statically-linked with link-time
optimization (fat objects). Remember to pull the `rust-static` container first!

``` sh
# use Podman instead of Docker if it's available
command -v podman >/dev/null && =podman || docker=docker

# share the above environment variables and the cargo registry with
# the container
musl_env() {
	$docker run --rm -it \
		-v "$PWD:/root/src" \
		-v "$CARGO_HOME/registry:/root/.cargo/registry" \
		-e CC=clang \
		-e CXX=clang++ \
		-e CFLAGS='-DNDEBUG -g -pipe -s -flto -fuse-ld=lld -L.' \
		-e LDFLAGS="$CFLAGS" CXXFLAGS="$CFLAGS" CPPFLAGS="$CFLAGS" \
		-e LIBLDFLAGS='-z lazy' \
		-e MAKEFLAGS="-j $(getconf _NPROCESSORS_ONLN)" \
		-e RUSTFLAGS="-L. -C linker-plugin-lto -C linker=clang -C link-arg=-fuse-ld=lld -C target-feature=+crt-static -C lto=fat"
		rust-static "$@"
}

# it acts like the cargo command, but static!
cargo_static() {
	musl_env cargo "$@"
}

git clone https://github.com/Peltoche/lsd
cd ./lsd
cargo_static build --release --target=x86_64-unknown-linux-musl \
```

For a larger, more advanced example, my dotfiles contain [this
script](https://gitlab.com/Seirdy/dotfiles/blob/master/Executables/shell-scripts/updates/cargo.sh)
to update my rust binaries.
