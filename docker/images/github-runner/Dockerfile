# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ENV HOME=/home/runner

# --- ЗАШИВАЕМ ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ ПО УМОЛЧАНИЮ ---
ENV RUNNER_LABELS="linux,x64,my-custom-label"
ENV RUNNER_EPHEMERAL="false"

# Base dependencies
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      jq \
      sudo \
 && rm -rf /var/lib/apt/lists/*

# The runner refuses to run as root.
RUN if id -u 1000 >/dev/null 2>&1; then userdel -r "$(id -nu 1000)"; fi \
 && useradd -m -u 1000 -s /bin/bash runner \
 && echo "runner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner \
 && chmod 0440 /etc/sudoers.d/runner

WORKDIR /actions-runner

# Runner 2.337.0, linux x64, pinned checksum
RUN curl -fsSL -o /tmp/runner.tar.gz \
      "https://github.com" \
 && echo "70920811a4f8ad4328818682bca5c6469c1c942fab52448868071d0063816613  /tmp/runner.tar.gz" | shasum -a 256 -c \
 && tar xzf /tmp/runner.tar.gz -C /actions-runner \
 && rm /tmp/runner.tar.gz \
 && ./bin/installdependencies.sh \
 && chown -R runner:runner /actions-runner

USER runner

COPY --chown=runner:runner entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
