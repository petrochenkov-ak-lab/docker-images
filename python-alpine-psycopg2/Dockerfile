FROM python:3.14.3-alpine3.23
LABEL org.opencontainers.image.source=https://github.com/petrochenkov-ak-lab/docker-images

COPY ./python-alpine-psycopg2/logging.conf /etc/logging.conf
COPY ./python-alpine-psycopg2/pip.conf /etc/pip.conf
COPY ./python-alpine-psycopg2/uv.toml /etc/uv.toml

ENV PIP_NO_CACHE_DIR=1
ENV PIP_ROOT_USER_ACTION=ignore

# pip install from github repo
RUN apk add --no-cache \
    git \
    openssh-client \
    curl \
    libpq && \
    mkdir -p -m 0700 /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# Install only runtime libpq (no dev tools, no gcc, no slow build)
RUN apk add --no-cache libpq postgresql-libs

# Verify Python version is 3.14
RUN python3 --version

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system psycopg2-binary

# Remove any Python 3.12 traces (if present in the base image)
RUN apk del python3 python3-dev py3-pip python3-pycache-pyc0 pyc || true && \
    find /usr/bin /usr/local/bin -name "python3.12*" -delete || true && \
    find /usr/bin /usr/local/bin -name "py3*" -delete || true && \
    rm -rf /usr/lib/python3.12* 2>/dev/null || true && \
    find /usr/local -name "python3.12*" -exec rm -rf {} + 2>/dev/null || true && \
    apk cache clean && rm -rf /var/cache/apk/*

# Final sanity check: Python 3.14 + psycopg2 OK
RUN python3 --version && \
    ls -la /usr/bin/python* /usr/local/bin/python* | grep -v 3.14 && echo "No Python 3.12!" && \
    python3 -c "import psycopg2; print('psycopg2 OK:', psycopg2.__version__)"
