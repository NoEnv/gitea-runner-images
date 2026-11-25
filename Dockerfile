FROM registry.fedoraproject.org/fedora-minimal:45

LABEL maintainer "NoEnv"
LABEL version "1.0.18"
LABEL description "Gitea Action Runner Images based on Fedora"

ENV NODE_VERSION=24.22.3 \
    RUST_VERSION=1.100.0 \
    GT_VERSION=2.0.0 \
    STORAGE_DRIVER=vfs \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN microdnf -y --nodocs install buildah git-core rustup awscli2 openssl-devel gcc-c++ gzip && \
    case "$(arch)" in \
       aarch64|arm64|arm64e) \
         NODE_BINARY_URL="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.gz"; \
         GT_BINARY_URL="https://dl.gitea.com/gitea-cli/$GT_VERSION/gitea-cli-$GT_VERSION-linux-arm64"; \
         ;; \
       x86_64|amd64|i386) \
          NODE_BINARY_URL="https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz"; \
          GT_BINARY_URL="https://dl.gitea.com/gitea-cli/$GT_VERSION/gitea-cli-$GT_VERSION-linux-amd64"; \
         ;; \
       *) \
         echo "Unsupported arch: ${arch}"; \
         exit 1; \
         ;; \
    esac; \
    curl -fsSLo /tmp/node-linux.tar.gz ${NODE_BINARY_URL} && \
    tar -xf /tmp/node-linux.tar.gz -C /usr/local --strip-components=1 --no-same-owner && \
    curl -fsSLo /tmp/gt-linux ${GT_BINARY_URL} && \
    mv /tmp/gt-linux /usr/local/bin/gt && chmod +x /usr/local/bin/gt && \
    rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION  && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
    microdnf -y remove rustup && \
    microdnf clean all && \
    rm -rf /tmp/* /var/tmp/* /var/log/*.log /var/cache/yum/* /var/lib/dnf/* /var/lib/rpm/* /root/.gnupg /tmp/node-linux.tar.xz
