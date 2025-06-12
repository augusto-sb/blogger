ng new ngapp
cd ngapp/
ng build
cd ..



#docker build ./ngapp/ -f nginx.Dockerfile  -t webserver:nginx;
docker image build . -f nginx.Dockerfile  -t webserver:nginx;
docker container run --rm -p 8080:8080 webserver:nginx;
curl http://localhost:8080/
#lighthouse
ab -n 65536 -c 4 http://localhost:8080/ > "./nginx.output.3"



#docker build ./ngapp/ -f golang.Dockerfile -t webserver:golang;
docker image build . -f golang.Dockerfile -t webserver:golang;
docker container run --rm -p 8080:8080 --read-only webserver:golang;
curl http://localhost:8080/
#lighthouse
ab -n 65536 -c 4 http://localhost:8080/ > "./golang.output.3"



docker images | grep webserver