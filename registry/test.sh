docker compose --file docker-compose.yml up --detach

curl http://localhost:5000/v2/_catalog

curl https://localhost:5000/v2/_catalog

curl https://localhost:5000/v2/_catalog -k

curl https://augusto:augusto@localhost:5000/v2/_catalog -k

docker login -u augusto -p augusto localhost:5000

docker image pull docker.io/alpine:3.21.3

docker image tag docker.io/alpine:3.21.3 localhost:5000/alpine:3.21.3

docker push localhost:5000/alpine:3.21.3

curl https://augusto:augusto@localhost:5000/v2/_catalog -k

docker compose -f docker-compose.yml rm --stop --force