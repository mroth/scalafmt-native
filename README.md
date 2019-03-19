# scalafmt-native

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/mrothy/scalafmt-native.svg)
![MicroBadger Size](https://img.shields.io/microbadger/image-size/mrothy/scalafmt-native.svg)

Statically-linked GraalVM "native image" binaries of [`scalafmt`] packaged for
Docker. These are totally self-contained, start instantly, and do not require
the JVM to run.

Full size is about 32MB uncompressed.

[`scalafmt`]: https://scalameta.org/scalafmt/

### Usage
Sample usage running on a local `src` directory:

    docker pull mrothy/scalafmt-native
    docker run -v $(PWD)/src:/src --rm -it mrothy/scalafmt-native --test /src
