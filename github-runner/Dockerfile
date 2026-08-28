# 1. Base image: stable LTS version of Ubuntu
FROM ubuntu:24.04

# 2. Pin the runner version. GitHub automatically blocks outdated versions.
ARG RUNNER_VERSION="2.336.0"

# 3. Disable interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# 4. Install essential dependencies required by the GitHub Actions agent
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    jq \
    ca-certificates \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 5. Security: Create a non-root user (the GitHub agent refuses to run under root)
# Add the user to sudoers so your workflows can run 'sudo apt install' if needed
RUN useradd -m runner \
    && usermod -aG sudo runner \
    && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 6. Switch to the newly created user and its home directory
USER runner
WORKDIR /home/runner

# 7. Download, extract, and clean up the official GitHub Actions runner binary
RUN mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com{RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# 8. Copy and set permissions for the initialization script (entrypoint.sh)
USER root
COPY entrypoint.sh /home/runner/actions-runner/entrypoint.sh
RUN chmod +x /home/runner/actions-runner/entrypoint.sh \
    && chown -R runner:runner /home/runner/actions-runner

USER runner
WORKDIR /home/runner/actions-runner

# 9. Trigger the script that registers the runner with your GitHub organization on startup
ENTRYPOINT ["./entrypoint.sh"]
