FROM prometheuscommunity/postgres-exporter:v0.18.0
LABEL org.opencontainers.image.source=https://github.com/petrochenkov-ak-lab/docker-images

USER root

COPY postgres-exporter/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
