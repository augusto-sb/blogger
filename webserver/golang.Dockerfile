FROM docker.io/library/golang:1.23.10-alpine3.21 AS compiler
WORKDIR /lala/
COPY ./main.go .
RUN go build main.go



FROM scratch AS runner
COPY ./ngapp/dist/ngapp/browser/ /html/
COPY --from=compiler /lala/main /main
ENTRYPOINT ["/main"]