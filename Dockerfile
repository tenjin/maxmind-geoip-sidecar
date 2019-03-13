FROM golang:alpine3.9 AS buildenv

ENV GO111MODULE=on
ARG VERSION=v4.0.2
ARG WORKDIR=/go/src/github.com/maxmind/geoipupdate

RUN apk add --no-cache \
	git \
	wget \
	build-base \
	ca-certificates

RUN git clone https://github.com/maxmind/geoipupdate.git ${WORKDIR}
WORKDIR ${WORKDIR}
RUN go get -u github.com/maxmind/geoipupdate/cmd/geoipupdate
RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -a -installsuffix cgo -o /geoipupdate ./cmd/geoipupdate

FROM alpine:3.9
RUN apk --no-cache add ca-certificates
COPY --from=buildenv /geoipupdate /bin/geoipupdate
CMD ["geoipupdate"]
