# Container Images for K8S

## Container Images
These are some container images with added supports for configuring through environment variables, even if the source software does not officially support this functionality. This makes the images better suited for K8S deployment.

Images are hosted on Github Container Registry [here](https://github.com/kien-truong?tab=packages&repo_name=containers), with support for `linux/amd64`, and `linux/arm64` when possible

## Credits

Many of these images were taken from [k8s-at-home](https://github.com/k8s-at-home/container-images) projects, then modified for my needs, so credit's where it's due.

Environment variables were converted into configuration with [envsubst](https://github.com/a8m/envsubst)