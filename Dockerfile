FROM golang:1.22.0 AS builder

WORKDIR /usr/src/app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /parcel-delivery



FROM alpine:3.19

WORKDIR /usr/src/goapp

COPY --from=builder /parcel-delivery ./

COPY ./tracker.db ./

ENTRYPOINT ["./parcel-delivery"]

