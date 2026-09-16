FROM debian:bookworm-slim
LABEL org.opencontainers.image.source=https://github.com/petrochenkov-ak-lab/docker-images

ARG RUNNER_VERSION="2.336.0"
# Хэш-сумма для версии 2.336.0 (обновляйте вместе с RUNNER_VERSION)
ARG RUNNER_SHA="04cf0be1aff4c3ec3554466c39124ca250e3effd8873bb7e8d68535aa9505d5d"

ENV DEBIAN_FRONTEND=noninteractive

# Установка зависимостей + библиотеки, необходимые для работы .NET (раннера)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    sudo \
    git \
    jq \
    ca-certificates \
    libicu-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m runner \
    && usermod -aG sudo runner \
    && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER runner
WORKDIR /home/runner/actions-runner

# Динамическое скачивание с использованием переданных аргументов
RUN curl -f -o actions-runner-linux-x64.tar.gz -L "https://github.com{RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
    && echo "${RUNNER_SHA}  actions-runner-linux-x64.tar.gz" | sha256sum -c \
    && tar xzf ./actions-runner-linux-x64.tar.gz \
    && rm ./actions-runner-linux-x64.tar.gz

# Настройка прав для скрипта инициализации
USER root
COPY ./entrypoint.sh /home/runner/actions-runner/entrypoint.sh
RUN chmod +x /home/runner/actions-runner/entrypoint.sh \
    && chown -R runner:runner /home/runner/actions-runner

USER runner
ENTRYPOINT ["./entrypoint.sh"]
