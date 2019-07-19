FROM alpine:3.10.1
LABEL maintainer="https://github.com/Lowess"

ENV AWS_IAM_AUTHENTICATOR_VERSION="1.12.7" \
    AWS_CLI_VERSION="1.16.200" \
    KUBECTL_VERSION="1.12.7" \
    HELM_VERSION="v3.0.0-alpha.1" \
    HELM_PLATFORM="linux-amd64" \
    PATH="${PATH}:/usr/local/bin"

ENV HELM_ARCHIVE="helm-${HELM_VERSION}-${HELM_PLATFORM}.tar.gz"

# Install curl
RUN apk --no-cache update \
    && apk --no-cache add python py-pip py-setuptools ca-certificates curl groff less \
    && pip --no-cache-dir install awscli==${AWS_CLI_VERSION} \
    && rm -rf /var/cache/apk/*

# Install AWS vendored Kubernetes clients
RUN curl -so /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBECTL_VERSION}/2019-03-27/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -so /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR_VERSION}/2019-03-27/bin/linux/amd64/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator

# Install Helm
RUN curl -so /tmp/${HELM_ARCHIVE} https://get.helm.sh/${HELM_ARCHIVE} \
    && tar -xzf /tmp/${HELM_ARCHIVE} -C /tmp \
    && cp /tmp/${HELM_PLATFORM}/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && ln -s /usr/local/bin/helm /usr/local/bin/h3

ENTRYPOINT ["/usr/local/bin/helm"]
CMD ["-h"]
