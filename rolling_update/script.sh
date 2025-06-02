minikube start --driver docker --kubernetes-version 1.29.15

# wget https://dl.k8s.io/v1.29.15/bin/linux/amd64/kubectl -O kubectl-v1.29.15

sleep 60;

#docker build . -t rolling:1 -t rolling:2
docker build . -t rolling:1 --build-arg MESSAGEARG=ok_old
docker build . -t rolling:2 --build-arg MESSAGEARG=ok_new

go build test.go

minikube image load rolling:1 rolling:2

# minikube ssh
#   docker images

kubectl get nodes

kubectl apply -f deployment.yml -f service.yml

sleep 60;

# start tests

echo $PPID
MIP=$(minikube ip)
CLIENT=1 IP=$MIP ./test &
pid1=$!
echo $pid1
CLIENT=2 IP=$MIP ./test &
pid2=$!
echo $pid2

sleep 60;

# update deployment
echo 'updating'
kubectl set image deployment/rolling-deployment rolling=rolling:2

sleep 1;
kubectl rollout status deployments.apps/rolling-deployment;
sleep 1;
kubectl rollout status deployments.apps/rolling-deployment;

sleep 60;

kill -s SIGKILL $pid1
kill -s SIGKILL $pid2

# con los logs vemos que anduvo

# curl $(minikube ip):30000

# kubectl get pods --watch

# # en otro tab: bash test.sh

# # en otro tab: kubectl set image deployment/rolling-deployment rolling=rolling:2

kubectl delete services/rolling-service deployments.apps/rolling-deployment

sleep 60;

minikube stop