# sudo apt install apache2-utils

echo "nginx";
nginxid=$(docker container run --rm -p 8080:8080 --detach nginxinc/nginx-unprivileged:1.28.0-alpine-slim);
sleep 5;
time bash test.sh "nginx";
docker container stop $nginxid;

echo "golang";
go build main.go;
./main &
golangpid=$!
sleep 5;
time bash test.sh "golang";
#kill -$golangpid
#kill -9 -- -$golangpid
#pkill -TERM -P $golangpid
kill $golangpid
rm ./main

diff *.output