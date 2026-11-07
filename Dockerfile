
FROM quay.io/operator-framework/helm-operator:v1.42.2

ARG VERSION
LABEL org.opencontainers.image.source="https://github.com/appscode-cloud/installer" \
    name="AKP Installer" \
    maintainer=AppsCode \
    vendor=AppsCode \
    version=${VERSION} \
    release=${VERSION} \
    summary="AppsCode Kubernetes Platform Installer" \
    description="AppsCode Kubernetes Platform Installer"

USER root
RUN mkdir -p /licenses
COPY LICENSE.md /licenses/
USER ${USER_UID}

ENV HOME=/opt/helm
COPY watches.yaml ${HOME}/watches.yaml
COPY charts/akp-installer ${HOME}/helm-charts/akp-installer
WORKDIR ${HOME}
