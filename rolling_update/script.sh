minikube start --driver docker --kubernetes-version 1.29.14

docker build . -t rolling:1 -t rolling:2

minikube image load rolling:1 rolling:2

# minikube ssh
#   docker images

kubectl get nodes

kubectl apply -f deployment.yml -f service.yml

curl $(minikube ip):30000

kubectl get pods --watch

# en otro tab: bash test.sh

# en otro tab: kubectl set image deployment/rolling-deployment rolling=rolling:2

minikube stop