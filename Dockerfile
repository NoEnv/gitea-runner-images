FROM registry.fedoraproject.org/fedora-minimal:44

LABEL maintainer "NoEnv"
LABEL version "1.0.10"
LABEL description "Gitea Action Runner Images based on Fedora"

ENV NODE_VERSION=24.19.0 \
    TEA_VERSION=0.15.1 \
    STORAGE_DRIVER=vfs

RUN microdnf -y --nodocs install buildah git-core cargo awscli2 openssl-devel gcc-c++ && \
    case "$(arch)" in \
       aarch64|arm64|arm64e) \
         NODE_BINARY_URL="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.gz"; \
         TEA_BINARY_URL="https://dl.gitea.com/tea/$TEA_VERSION/tea-$TEA_VERSION-linux-arm64"; \
         ;; \
       x86_64|amd64|i386) \
          NODE_BINARY_URL="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz"; \
          TEA_BINARY_URL="https://dl.gitea.com/tea/$TEA_VERSION/tea-$TEA_VERSION-linux-amd64"; \
         ;; \
       *) \
         echo "Unsupported arch: ${arch}"; \
         exit 1; \
         ;; \
    esac; \
    curl -fsSLo /tmp/node-linux.tar.gz ${NODE_BINARY_URL} && \
    tar -xf /tmp/node-linux.tar.gz -C /usr/local --strip-components=1 --no-same-owner && \
    curl -fsSLo /tmp/tea-linux ${TEA_BINARY_URL} && \
    mv /tmp/tea-linux /usr/local/bin/tea && chmod +x /usr/local/bin/tea && \
    microdnf clean all && \
    rm -rf /tmp/* /var/tmp/* /var/log/*.log /var/cache/yum/* /var/lib/dnf/* /var/lib/rpm/* /root/.gnupg /tmp/node-linux.tar.xz
