FROM docker.io/library/golang:1.22.12-alpine3.21 AS cmplr
WORKDIR /lala/
COPY ./program.go ./main.go
RUN go build -o main main.go

FROM scratch AS rnnr
ARG MESSAGEARG
ENV MESSAGE=$MESSAGEARG
USER 1001:1001
COPY --from=cmplr /lala/main /main
ENTRYPOINT ["/main"]