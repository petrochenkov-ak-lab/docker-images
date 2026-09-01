FROM postgres:18
LABEL org.opencontainers.image.source=https://github.com/petrochenkov-ak-lab/docker-images

RUN mkdir -p /etc/postgresql && chown -R postgres:postgres /etc/postgresql

COPY --chown=postgres:postgres postgres/postgresql.base.conf /etc/postgresql/postgresql.base.conf
COPY --chown=postgres:postgres postgres/pg_hba.conf /etc/postgresql/pg_hba.conf

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
