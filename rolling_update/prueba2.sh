echo $PPID
MIP=$(minikube ip)

bash test.sh 1 &
pid1=$!
echo $pid1

bash test.sh 2 &
pid2=$!
echo $pid2

sleep 10;
pkill -P $pid1
pkill -P $pid2