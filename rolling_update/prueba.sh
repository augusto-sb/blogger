#chmod +x test.sh
go build test.go

echo $PPID
MIP=$(minikube ip)

#bash test.sh 1 &
#./test.sh 1 &
#CLIENT=1 IP=$MIP go run test.go &
CLIENT=1 IP=$MIP ./test &
pid1=$!
echo $pid1

#bash test.sh 2 &
#./test.sh 2 &
#CLIENT=2 IP=$MIP go run test.go &
CLIENT=2 IP=$MIP ./test &
pid2=$!
echo $pid2

#jobs -l
sleep 10;
#kill -s SIGINT $pid1
#kill -s SIGINT $pid2
kill -s SIGKILL $pid1
kill -s SIGKILL $pid2
#jobs -l

kill $(ps -s $$ -o pid=)

### 2

#$(sleep 10 &)
#sleep 10 &
#echo $!
#echo $(ps -s $$ -o pid=)