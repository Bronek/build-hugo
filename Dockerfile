ARG GO_REL
FROM golang:${GO_REL}-buster AS builder

WORKDIR /work
ARG RELEASE
RUN curl -fsSL https://github.com/gohugoio/hugo/archive/${RELEASE}.tar.gz | tar -xz --strip-components=1
RUN go install --tags extended
