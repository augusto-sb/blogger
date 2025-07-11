FROM docker.io/library/alpine:3.21.3 AS downloader
WORKDIR /tf/
ARG VERSION=3.4.4
RUN wget https://github.com/traefik/traefik/releases/download/v3.4.4/traefik_v3.4.4_linux_amd64.tar.gz
RUN SUM1=$(sha256sum traefik_v3.4.4_linux_amd64.tar.gz | cut -d ' ' -f 1)
ENV SUM2=083388e06633ecfede6b592c08c1b1cac92be39a341c3b42af1bc772cb699fb6
#sha256:083388e06633ecfede6b592c08c1b1cac92be39a341c3b42af1bc772cb699fb6
RUN if [ "${SUM1}" -ne "${SUM2}" ]; then exit 1; fi;
RUN tar -xf traefik_v3.4.4_linux_amd64.tar.gz

FROM scratch AS last
COPY --from=downloader /tf/traefik /traefik
ENTRYPOINT ["/traefik"]
USER 1324:1324
#EXPOSE 443/tcp
#https://doc.traefik.io/traefik/getting-started/install-traefik/