ARG VERSION=3.0.10

FROM docker.io/library/debian:12.11 AS compiler
RUN apt update
RUN apt upgrade -y
RUN apt install -y build-essential wget
WORKDIR /lala/
ARG VERSION
# download
RUN wget https://www.haproxy.org/download/3.0/src/haproxy-${VERSION}.tar.gz
RUN wget https://www.haproxy.org/download/3.0/src/haproxy-${VERSION}.tar.gz.sha256
RUN wget https://www.haproxy.org/download/3.0/src/haproxy-${VERSION}.tar.gz.md5
# verify
RUN sha256sum -c haproxy-${VERSION}.tar.gz.sha256
RUN md5sum -c haproxy-${VERSION}.tar.gz.md5
RUN tar -xf haproxy-${VERSION}.tar.gz
WORKDIR /lala/haproxy-${VERSION}/
RUN make -j 1 TARGET=generic CPU=native LDFLAGS="-static -static-libgcc"



FROM scratch AS runner
ARG VERSION
COPY --from=compiler /lala/haproxy-${VERSION}/haproxy /haproxy
ENTRYPOINT ["/haproxy"]
CMD ["-v"]
USER 1001:1001
ENV HAPROXY_VERSION=${VERSION}