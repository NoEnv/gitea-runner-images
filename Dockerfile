FROM registry.fedoraproject.org/fedora-minimal:44

LABEL maintainer "NoEnv"
LABEL version "1.0.1"
LABEL description "Gitea Action Runner Images based on Fedora"

RUN microdnf -y --nodocs install buildah && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash && \
    \. "$HOME/.nvm/nvm.sh" && \
    nvm install 24 && \
    microdnf clean all && \
    rm -rf /tmp/* /var/tmp/* /var/log/*.log /var/cache/yum/* /var/lib/dnf/* /var/lib/rpm/* /root/.gnupg
