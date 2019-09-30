# Inspired by the work done by Mikhail Chugunkov to package for Arch Linux
# see: https://chugunkov.website/2019/01/30/arch-package.html
#
# Also see regarding potential future built-in native target support:
# https://github.com/scalameta/scalafmt/issues/1172
FROM oracle/graalvm-ce:19.2.0.1 as builder
ARG SCALAFMT_VERSION=v2.1.0

WORKDIR /root

# install sbt
RUN curl https://bintray.com/sbt/rpm/rpm \
    -o /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install -y sbt

# other tools needed
RUN yum install -y git zlib-static

# native-image is no longer bundled with graalvm :-/
RUN gu install native-image

# get the source for the version of scalafmt we want
RUN git clone https://github.com/scalameta/scalafmt \
    --branch ${SCALAFMT_VERSION} --single-branch

# build scalafmt
WORKDIR /root/scalafmt
RUN sbt cli/assembly

# convert to native staticly-linked binary
# requires increase of max heap size to avoid OOM errors :-(
RUN JAVA_OPTS="-Xmx=2g" native-image \
    --static \
    --no-fallback \
    -jar scalafmt-cli/target/scala-2.12/scalafmt.jar \
    scalafmt-native

# scratch image with only binary
FROM scratch
COPY --from=builder /root/scalafmt/scalafmt-native /app/scalafmt
ENTRYPOINT ["/app/scalafmt"]
