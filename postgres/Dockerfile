FROM postgres:18
LABEL org.opencontainers.image.source=https://github.com/petrochenkov-ak-lab/docker-images

RUN mkdir -p /etc/postgresql && chown -R postgres:postgres /etc/postgresql

COPY --chown=postgres:postgres postgres/postgresql.base.conf /etc/postgresql/postgresql.base.conf
COPY --chown=postgres:postgres postgres/pg_hba.conf /etc/postgresql/pg_hba.conf

RUN openssl req -new -x509 -days 3650 -nodes -text -out /etc/postgresql/server.crt \
    -keyout /etc/postgresql/server.key -subj "/CN=localhost" \
    && chmod 600 /etc/postgresql/server.key \
    && chown postgres:postgres /etc/postgresql/server.crt /etc/postgresql/server.key

ENV POSTGRES_HOST_AUTH_METHOD=trust
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres

ENV PGDATA=/var/lib/postgresql/18/docker
# docker-compose.yaml volumes:
# - /var/lib/postgresql/18/{project}:/var/lib/postgresql

USER postgres
# ENTRYPOINT ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]
