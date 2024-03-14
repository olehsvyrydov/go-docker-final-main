FROM golang:1.21.0 AS builder

WORKDIR /usr/src/app

COPY . .

RUN go mod download \
    && go get \
    && go build .



##########################
#         PROD           #
##########################

FROM golang:1.21.0 AS prod

RUN addgroup --system gouser \
    && adduser --system --shell /bin/false --group gouser

WORKDIR /usr/src/goapp

COPY --from=builder /usr/src/app/42-docker-final ./docker-file

COPY ./tracker.db ./

RUN chown -R gouser .

USER gouser

ENTRYPOINT ["./docker-file"]

