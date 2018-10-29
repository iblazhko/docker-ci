# Docker-based CI/CD Workflow

This repository demonstrates how to implement
CI/CD workflow using Docker containers.

## CI

### Stage 1. Build + Unit Tests + Publish

This stage uses Docker image `microsoft/dotnet:2.1-sdk` for the following steps:

1. build the source code
2. run unit tests
3. produce runtime-specific build output

Source code is passed to the build container using mounted volume.

```bash
docker run -it --rm -v "C:\Projects\POC\docker-ci":/srv/ci microsoft/dotnet:2.1-sdk /srv/ci/build/build.sh -t Publish -c Release -r linux-x64
```

## CD

TODO
