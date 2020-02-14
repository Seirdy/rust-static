FROM alpine:edge

RUN apk --no-cache update && apk add --no-cache \
	openssl-libs-static \
	lld clang clang-static \
	git \
	linux-headers \
	libxkbcommon-static \
	ca-certificates \
	ncurses-static \
	make \
	g++ \
	libgit2-static \
	libssh2-static \
	cmake
RUN apk add --no-cache --virtual .rustup-deps \
	curl bash \
	&& curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup-init.sh \
	&& bash /tmp/rustup-init.sh --default-toolchain nightly --profile minimal -t x86_64-unknown-linux-musl -y \
	&& rm /tmp/rustup-init.sh \
	&& apk del .rustup-deps \
	&& mkdir -p /root/libs /root/src
ENV PATH=/root/.cargo/bin:/usr/local/musl/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /root/src

# vi:ft=dockerfile
