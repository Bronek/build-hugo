FROM golang:1.12.1-stretch AS builder
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
ARG REF=master
RUN git clone https://github.com/gohugoio/hugo.git

WORKDIR /work/hugo
RUN git checkout ${REF}
RUN go install --tags extended
