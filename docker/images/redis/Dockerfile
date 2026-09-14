FROM redis:7-alpine

HEALTHCHECK --interval=5s --timeout=5s --retries=120 \
  CMD redis-cli ping | grep -q PONG || exit 1

CMD ["redis-server", "--appendonly", "no", "--save", "900", "1", "--save", "300", "10", "--save", "60", "10000"]
