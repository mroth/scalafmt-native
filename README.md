# scalafmt-native

[
    ![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/mrothy/scalafmt-native.svg)
    ![MicroBadger Size](https://img.shields.io/microbadger/image-size/mrothy/scalafmt-native.svg)
](https://hub.docker.com/r/mrothy/scalafmt-native)

Statically-linked GraalVM "native image" binaries of [`scalafmt`] packaged for
Linux, macOS, and Docker. These are totally self-contained, start instantly, and
do not require the JVM to run.

Full size is about 32MB uncompressed.

[`scalafmt`]: https://scalameta.org/scalafmt/

### macOS and Linux

Download the latest version from the [releases page](https://github.com/mroth/scalafmt-native/releases/latest).

### Docker
Sample usage running on a local `src` directory:

    docker pull mrothy/scalafmt-native
    docker run -v $(PWD)/src:/src --rm -it mrothy/scalafmt-native --test /src
