FROM docker.io/library/gcc:14.3.0 AS compiler
WORKDIR /asdasd/
COPY ./whoami.c .
RUN gcc -static -o main whoami.c

FROM scratch AS runner
COPY --from=compiler /asdasd/main /main
ENTRYPOINT ["/main"]