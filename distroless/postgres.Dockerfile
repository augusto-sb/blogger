ARG VERSION=15.13

FROM docker.io/library/postgres:${VERSION}-alpine AS base
RUN which postgres
RUN ldd /usr/local/bin/postgres
RUN echo '' > /tmp/postgresql.conf

FROM scratch AS final
COPY --from=base /usr/local/bin/postgres /usr/local/bin/postgres
COPY --from=base /usr/lib/ /usr/lib/
COPY --from=base /lib/ /lib/
COPY --from=base /usr/local/lib/ /usr/local/lib/
USER 1234:1234
WORKDIR /pg/
COPY --from=base /tmp/postgresql.conf /pg/postgresql.conf
ENV PGDATA=/pg
ENTRYPOINT ["/usr/local/bin/postgres"]