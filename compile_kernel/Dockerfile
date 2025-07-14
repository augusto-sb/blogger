FROM docker.io/library/debian:12.11 AS everything
RUN apt update
RUN apt upgrade -y
RUN apt install wget gnupg2 xz-utils make gcc flex bison kmod dpkg-dev debhelper bc cpio libelf-dev:native libssl-dev:native libssl-dev rsync -y
#kmod for localmodconfig
RUN gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org
WORKDIR /mykernel/
ARG VERSION=6.12.38
RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${VERSION}.tar.xz
RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${VERSION}.tar.sign
RUN unxz linux-${VERSION}.tar.xz
RUN gpg2 --verify linux-${VERSION}.tar.sign
RUN tar -xf linux-${VERSION}.tar
WORKDIR /mykernel/linux-${VERSION}/
#RUN make help
RUN make defconfig
RUN make localmodconfig
RUN bash scripts/config --disable DEBUG_INFO
RUN bash scripts/config --disable CPU_SUP_HYGON
RUN bash scripts/config --disable CPU_SUP_CENTAUR
RUN bash scripts/config --disable CPU_SUP_ZHAOXIN
RUN make clean
#RUN apt install build-essential dkms procps -y
RUN make --jobs=4 bindeb-pkg ARCH=x86_64 LOCALVERSION=augusto