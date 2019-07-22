# Docker Helm3

Docker container with Helm / AWSCli / EKS Vendored Kubctl and AWS-IAM-Authenticator

## Build it!

`make build`

## Run it!

```
#--runit--

docker run \
    -it --rm \
    -v ~/.aws:/root/.aws \
    -v ~/.kube:/root/.kube \
    lowess/helm
```
