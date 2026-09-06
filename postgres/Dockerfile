FROM postgres:18
LABEL org.opencontainers.image.source=https://github.com/petrochenkov-ak-lab/docker-images

RUN mkdir -p /etc/postgresql && chown -R postgres:postgres /etc/postgresql

COPY --chown=postgres:postgres postgres/postgresql.base.conf /etc/postgresql/postgresql.base.conf
COPY --chown=postgres:postgres postgres/pg_hba.conf /etc/postgresql/pg_hba.conf

RUN openssl req -new -x509 -days 365 -nodes -text -out /var/lib/postgresql/server.crt \
    -keyout /var/lib/postgresql/server.key -subj "/CN=localhost" \
    && chmod 600 /var/lib/postgresql/server.key \
    && chown postgres:postgres /var/lib/postgresql/server.crt /var/lib/postgresql/server.key

ENV POSTGRES_HOST_AUTH_METHOD=trust
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres

ENV PGDATA=/var/lib/postgresql/18/docker
# docker-compose.yaml volumes:
# - /var/lib/postgresql/18/{project}:/var/lib/postgresql

USER postgres
# ENTRYPOINT ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]
