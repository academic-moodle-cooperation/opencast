FROM openjdk:8-jdk-slim AS BUILDER

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      tar gzip git \
      ca-certificates openssl \
      maven make gcc g++ libc-dev ffmpeg
