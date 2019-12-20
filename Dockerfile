# Inspired by the work done by Mikhail Chugunkov to package for Arch Linux
# see: https://chugunkov.website/2019/01/30/arch-package.html
#
# Also see regarding potential future built-in native target support:
# https://github.com/scalameta/scalafmt/issues/1172
FROM oracle/graalvm-ce:19.3.0 as builder
ARG SCALAFMT_VERSION=2.3.2

WORKDIR /root/scalafmt

# extra dependencies: zlib-static needed to produce static binaries
RUN yum install -y zlib-static
# graalvm native-image is no longer bundled
RUN gu install native-image

# install coursier
RUN curl -s -Lo /usr/local/bin/coursier https://git.io/coursier-cli && \
    chmod +x /usr/local/bin/coursier

# fetch scalafmt jars
#
# (keep track of where they were stored to use in classpath later,  persisting
# list to file to move across shell invocations)
RUN coursier fetch org.scalameta:scalafmt-cli_2.12:${SCALAFMT_VERSION} -p > .classpath

# convert to native staticly-linked binary
ENV JAVA_OPTS="-Xmx=2g"
RUN export CLASSPATH=$(<.classpath) && native-image \
    --static \
    --no-fallback \
    --report-unsupported-elements-at-runtime \
    --initialize-at-build-time \
    --allow-incomplete-classpath \
    --class-path $CLASSPATH org.scalafmt.cli.Cli \
    scalafmt-native

# make scratch image with only binary
FROM scratch
COPY --from=builder /root/scalafmt/scalafmt-native /app/scalafmt
ENTRYPOINT ["/app/scalafmt"]
