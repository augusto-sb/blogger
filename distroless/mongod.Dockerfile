FROM docker.io/library/ubuntu:jammy-20250714 AS dwnld
WORKDIR /root/
RUN apt update
RUN apt upgrade -y
RUN apt install -y wget
ARG VERSION=6.0.25
RUN wget https://repo.mongodb.org/apt/ubuntu/dists/jammy/mongodb-org/6.0/multiverse/binary-amd64/mongodb-org-server_${VERSION}_amd64.deb
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y ./mongodb-org-server_${VERSION}_amd64.deb
RUN which mongod
RUN ldd /usr/bin/mongod

FROM scratch AS final
COPY --from=dwnld /usr/bin/mongod /mongod
COPY --from=dwnld /lib/ /lib/
COPY --from=dwnld /lib64/ /lib64/
COPY --from=dwnld /usr/lib/ /usr/lib/
COPY --from=dwnld /usr/lib64/ /usr/lib64/
USER 1324:1234
#create tmp dir...
WORKDIR /tmp/
WORKDIR /
ENTRYPOINT ["/mongod"]
VOLUME ["/data/db"]
#VOLUME ["/data/db", "/data/configdb"] # if you want as config server
EXPOSE 27017/tcp
CMD ["--bind_ip_all"]