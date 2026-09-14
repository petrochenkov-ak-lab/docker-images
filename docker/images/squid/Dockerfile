FROM alpine:3.20

RUN apk add --no-cache squid

COPY ./etc/squid/squid.conf /etc/squid/squid.conf

EXPOSE 3128

CMD ["squid", "-NYd", "1"]
