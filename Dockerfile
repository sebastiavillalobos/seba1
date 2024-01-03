FROM golang:1.20 as builder

WORKDIR /go/src/github.com/sebastiavillalobos/seba1

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/seba1

FROM alpine:3.19

COPY --from=builder /go/bin/seba1 /seba1

RUN addgroup -S go-app && adduser -S go-app -G go-app

RUN chown go-app:go-app /seba1

USER go-app

ENTRYPOINT ["/seba1"]

EXPOSE 8282
