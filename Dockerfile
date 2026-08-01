FROM golang:1.24 AS build
WORKDIR /workspace/src
COPY context.tgz /tmp/context.tgz
RUN tar -xzf /tmp/context.tgz -C /workspace/src
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -mod=mod -trimpath -ldflags="-s -w" -o /provider ./cmd/provider

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /provider /provider
USER 65532:65532
ENTRYPOINT ["/provider"]
