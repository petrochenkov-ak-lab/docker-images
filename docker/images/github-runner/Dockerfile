# 1. Используем ультра-легкий, но стабильный Debian Slim
FROM debian:bookworm-slim
LABEL org.opencontainers.image.source=https://github.com/petrochenkov-ak-lab/docker-images

# 2. Версия раннера
ARG RUNNER_VERSION="2.336.0"

# 3. Отключаем интерактивные диалоги
ENV DEBIAN_FRONTEND=noninteractive

# 4. Установка ТОЛЬКО необходимых зависимостей в один слой
# Использование --no-install-recommends экономит сотни мегабайт
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    sudo \
    git \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 5. Создание безопасного пользователя
RUN useradd -m runner \
    && usermod -aG sudo runner \
    && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER runner
WORKDIR /home/runner/actions-runner

# https://github.com/organizations/petrochenkov-ak-lab/settings/actions/runners/new?arch=x64&os=linux
RUN curl -f -o actions-runner-linux-x64-2.336.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.336.0/actions-runner-linux-x64-2.336.0.tar.gz \
    && echo "04cf0be1aff4c3ec3554466c39124ca250e3effd8873bb7e8d68535aa9505d5d  actions-runner-linux-x64-2.336.0.tar.gz" | sha256sum -c \
    && tar xzf ./actions-runner-linux-x64-2.336.0.tar.gz \
    && rm ./actions-runner-linux-x64-2.336.0.tar.gz

# 8. Copy and set permissions for the initialization script (entrypoint.sh)
USER root
COPY ./github-runner/entrypoint.sh /home/runner/actions-runner/entrypoint.sh
RUN chmod +x /home/runner/actions-runner/entrypoint.sh \
    && chown -R runner:runner /home/runner/actions-runner

USER runner
WORKDIR /home/runner/actions-runner

# 9. Trigger the script that registers the runner with your GitHub organization on startup
ENTRYPOINT ["./entrypoint.sh"]
