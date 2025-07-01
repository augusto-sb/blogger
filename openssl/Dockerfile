FROM docker.io/library/alpine:3.21.3 AS build
RUN apk update
RUN apk add make perl gcc musl-dev linux-headers gnupg gpg
WORKDIR /openssl/
ARG VERSION=3.0.16
RUN wget https://github.com/openssl/openssl/releases/download/openssl-${VERSION}/openssl-${VERSION}.tar.gz
RUN wget https://github.com/openssl/openssl/releases/download/openssl-${VERSION}/openssl-${VERSION}.tar.gz.asc
#RUN wget https://github.com/openssl/openssl/releases/download/openssl-${VERSION}/openssl-${VERSION}.tar.gz.sha1
RUN wget https://github.com/openssl/openssl/releases/download/openssl-${VERSION}/openssl-${VERSION}.tar.gz.sha256
#RUN sha1sum -c openssl-${VERSION}.tar.gz.sha1
RUN sha256sum -c openssl-${VERSION}.tar.gz.sha256
ARG KEY=BA5473A2B0587B07FB27CF2D216094DFD0CB81EF
RUN gpg --keyserver 'keys.openpgp.org' --recv-keys ${KEY}
RUN gpg --verify openssl-${VERSION}.tar.gz.asc openssl-${VERSION}.tar.gz
RUN tar -x -f openssl-${VERSION}.tar.gz -C . --strip-components 1
RUN ./config -static
RUN make --jobs=2
RUN make test

FROM scratch
COPY --from=build /openssl/apps/openssl /openssl
ENV OPENSSL_CONF=/openssl.cnf
COPY --from=build /openssl/apps/openssl.cnf /openssl.cnf
USER 1324:1324
ENTRYPOINT ["/openssl"]
CMD ["version"]