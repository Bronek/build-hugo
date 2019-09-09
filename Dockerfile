ARG GO_REL
FROM golang:${GO_REL}-stretch AS builder

WORKDIR /work
ARG COMMIT=master
RUN git clone https://github.com/gohugoio/hugo.git .
RUN git checkout ${COMMIT}
RUN go install --tags extended
