FROM docker.io/library/alpine:3.21.4 AS downloader
WORKDIR /home/
ARG VERSION=RELEASE.2025-06-13T11-33-47Z
RUN wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio.${VERSION}
RUN wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio.${VERSION}.sha256sum
RUN wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio.${VERSION}.shasum
RUN wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio.${VERSION}.minisig
RUN wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio.${VERSION}.asc
RUN sha256sum -c minio.${VERSION}.sha256sum
#add sig checking
RUN mv minio.${VERSION} minio
RUN chmod +x minio
RUN ./minio --version

FROM scratch AS final
COPY --from=downloader /home/minio /minio
ENTRYPOINT ["/minio"]
USER 1635:6457
VOLUME ["/data"]
CMD ["--anonymous", "server", "--address", ":9000", "--console-address", ":9001", "/data"]
EXPOSE 9000/tcp
EXPOSE 9001/tcp
#ENV MINIO_ROOT_USER=minio
#ENV MINIO_ROOT_PASSWORD=minio123
#ENV MINIO_BROWSER_REDIRECT_URL=https://domain.com/minio