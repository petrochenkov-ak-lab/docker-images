# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ENV HOME=/home/runner

# Base dependencies
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      jq \
      sudo \
 && rm -rf /var/lib/apt/lists/*

# The runner refuses to run as root
RUN useradd -m -u 1000 -s /bin/bash runner \
 && echo "runner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner \
 && chmod 0440 /etc/sudoers.d/runner

WORKDIR /actions-runner

# Runner 2.337.0, linux x64, pinned checksum
RUN curl -fsSL -o /tmp/runner.tar.gz \
      "https://github.com/actions/runner/releases/download/v2.337.0/actions-runner-linux-x64-2.337.0.tar.gz" \
 && echo "70920811a4f8ad4328818682bca5c6469c1c942fab52448868071d0063816613  /tmp/runner.tar.gz" | shasum -a 256 -c \
 && tar xzf /tmp/runner.tar.gz -C /actions-runner \
 && rm /tmp/runner.tar.gz \
 && ./bin/installdependencies.sh \
 && chown -R runner:runner /actions-runner

USER runner

COPY --chown=runner:runner entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
