docker run -d \
  --name squid \
  -p 3128:3128 \
  --restart unless-stopped \
  ghcr.io/petrochenkov-ak-lab/squid:latest

docker ps -a | grep squid
curl -x http://localhost:3128 -I https://google.com
