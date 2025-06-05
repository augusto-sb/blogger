FROM docker.io/library/rust:1.85.1-slim AS compiler
WORKDIR /asdasd/
COPY main.rs
RUN rustc -o main ./main.rs

FROM scratch AS runner
COPY --from=compiler /asdasd/main /main
ENTRYPOINT ["/main"]
EXPOSE 80/tcp