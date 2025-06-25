FROM docker.io/library/ubuntu:24.04 AS builder
WORKDIR /home/
RUN apt update
RUN apt upgrade -y
RUN apt install -y python3 g++ make python3-pip wget
ARG VERSION=20.19.3
RUN wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz --show-progress
#RUN wget https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz --show-progress --output-document=node.tar.gz
RUN wget https://nodejs.org/dist/v${VERSION}/SHASUMS256.txt
RUN wget https://nodejs.org/dist/v${VERSION}/SHASUMS256.txt.sig
RUN wget https://nodejs.org/dist/v${VERSION}/SHASUMS256.txt.asc
RUN sha256sum --check SHASUMS256.txt --ignore-missing
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