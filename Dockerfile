FROM alpine:3.10.1
LABEL maintainer="https://github.com/Lowess"

ENV AWS_IAM_AUTHENTICATOR_VERSION="1.15.10" \
    AWS_CLI_VERSION="1.16.200" \
    KUBECTL_VERSION="1.12.7" \
    HELM_VERSION="v3.1.2" \
    HELMFILE_VERSION="v0.111.0" \
    HELM_DIFF_VERSION="v3.0.0-rc.7" \
    HELM_PLATFORM="linux-amd64" \
    PATH="${PATH}:/usr/local/bin"

ENV HELM_ARCHIVE="helm-${HELM_VERSION}-${HELM_PLATFORM}.tar.gz"

# Install curl and utilities
RUN apk --no-cache update \
  && apk --no-cache add python py-pip py-setuptools ca-certificates curl groff less git bash \
  && pip --no-cache-dir install awscli==${AWS_CLI_VERSION} \
  && rm -rf /var/cache/apk/*

# Install AWS vendored Kubernetes clients
RUN curl -Lso /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/${KUBECTL_VERSION}/2019-03-27/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && curl -Lso /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR_VERSION}/2019-03-27/bin/linux/amd64/aws-iam-authenticator \
  && chmod +x /usr/local/bin/aws-iam-authenticator

# Install Helm 3
RUN curl -Lso /tmp/${HELM_ARCHIVE} https://get.helm.sh/${HELM_ARCHIVE} \
  && tar -xzf /tmp/${HELM_ARCHIVE} -C /tmp \
  && cp /tmp/${HELM_PLATFORM}/helm /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm \
  && ln -s /usr/local/bin/helm /usr/local/bin/h${HELM_VERSION:1:1}

# Install Helmfile
RUN curl -Lso /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELM_PLATFORM/-/_} \
  && chmod +x /usr/local/bin/helmfile

# Install Helm plugins
RUN helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION} && \
    helm plugin install https://github.com/futuresimple/helm-secrets && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git && \
    helm plugin install https://github.com/aslafy-z/helm-git.git

ENTRYPOINT ["/usr/local/bin/helm"]
CMD ["-h"]
