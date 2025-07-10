FROM docker.io/library/alpine:3.21.3 AS builder
WORKDIR /home/
RUN apk update
RUN apk upgrade
RUN apk add python3 g++ make linux-headers
ARG VERSION=20.19.3
RUN wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz
RUN wget https://nodejs.org/dist/v${VERSION}/SHASUMS256.txt
#RUN wget https://nodejs.org/dist/v${VERSION}/SHASUMS256.txt.sig
#RUN wget https://nodejs.org/dist/v${VERSION}/SHASUMS256.txt.asc
#RUN gpg --import SHASUMS256.txt.sig ???
#RUN gpg --verify SHASUMS256.txt.asc ???
#RUN sha256sum -c SHASUMS256.txt
#RUN cat SHASUMS256.txt | grep "node-v${VERSION}.tar.gz" | sha256sum -c -
RUN mkdir node
RUN tar --extract --file=node-v${VERSION}.tar.gz --directory=node --strip-components=1
WORKDIR /home/node/
RUN ./configure --fully-static --enable-static
RUN make --jobs=8
#RUN ldd out/Release/node

FROM scratch
COPY --from=builder /home/node/out/Release/node /node
USER 1324:1324
ENTRYPOINT ["/node"]
CMD ["--version"]