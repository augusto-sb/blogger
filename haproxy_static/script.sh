docker image build . -t haproxystatic:3.0.11 -f Dockerfile.haproxy --build-arg VERSION=3.0.11
docker images | grep haproxy
docker container run --rm haproxystatic:3.0.11
docker container run --rm -v ./haproxy.cfg:/haproxy.cfg:ro haproxystatic:3.0.11 -f /haproxy.cfg