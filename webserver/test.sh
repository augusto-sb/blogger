# curl localhost:8080 -v -s -o "./${1}.output" # one output for comparison
# --verbose --silent --output
### curl localhost:8080 --silent --output "./${1}.output" # one output for comparison
### for i in $(seq 1 4096); do
###   curl localhost:8080 --output /dev/null --silent
### done

ab -n 65536 -c 4 http://localhost:8080/ > "./${1}.output.2"

# ab -n 16384 -c 8 http://localhost:8080/
# This is ApacheBench, Version 2.3 <$Revision: 1903618 $>
# Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
# Licensed to The Apache Software Foundation, http://www.apache.org/
# 
# Benchmarking localhost (be patient)
# Completed 1638 requests
# Completed 3276 requests
# Completed 4914 requests
# Completed 6552 requests
# Completed 8190 requests
# Completed 9828 requests
# Completed 11466 requests
# Completed 13104 requests
# Completed 14742 requests
# Completed 16380 requests
# Finished 16384 requests
# 
# 
# Server Software:        nginx/1.28.0
# Server Hostname:        localhost
# Server Port:            8080
# 
# Document Path:          /
# Document Length:        615 bytes
# 
# Concurrency Level:      8
# Time taken for tests:   0.692 seconds
# Complete requests:      16384
# Failed requests:        0
# Total transferred:      13893632 bytes
# HTML transferred:       10076160 bytes
# Requests per second:    23676.98 [#/sec] (mean)
# Time per request:       0.338 [ms] (mean)
# Time per request:       0.042 [ms] (mean, across all concurrent requests)
# Transfer rate:          19607.50 [Kbytes/sec] received
# 
# Connection Times (ms)
              # min  mean[+/-sd] median   max
# Connect:        0    0   0.0      0       0
# Processing:     0    0   0.4      0      17
# Waiting:        0    0   0.4      0      17
# Total:          0    0   0.4      0      17
# 
# Percentage of the requests served within a certain time (ms)
  # 50%      0
  # 66%      0
  # 75%      0
  # 80%      0
  # 90%      0
  # 95%      0
  # 98%      0
  # 99%      0
 # 100%     17 (longest request)






# ab -n 16384 -c 8 http://localhost:8080/
# This is ApacheBench, Version 2.3 <$Revision: 1903618 $>
# Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
# Licensed to The Apache Software Foundation, http://www.apache.org/
# 
# Benchmarking localhost (be patient)
# Completed 1638 requests
# Completed 3276 requests
# Completed 4914 requests
# Completed 6552 requests
# Completed 8190 requests
# Completed 9828 requests
# Completed 11466 requests
# Completed 13104 requests
# Completed 14742 requests
# Completed 16380 requests
# Finished 16384 requests
# 
# 
# Server Software:        
# Server Hostname:        localhost
# Server Port:            8080
# 
# Document Path:          /
# Document Length:        615 bytes
# 
# Concurrency Level:      8
# Time taken for tests:   0.567 seconds
# Complete requests:      16384
# Failed requests:        0
# Total transferred:      11993088 bytes
# HTML transferred:       10076160 bytes
# Requests per second:    28900.94 [#/sec] (mean)
# Time per request:       0.277 [ms] (mean)
# Time per request:       0.035 [ms] (mean, across all concurrent requests)
# Transfer rate:          20659.66 [Kbytes/sec] received
# 
# Connection Times (ms)
              # min  mean[+/-sd] median   max
# Connect:        0    0   0.0      0       0
# Processing:     0    0   0.0      0       1
# Waiting:        0    0   0.0      0       0
# Total:          0    0   0.0      0       1
# 
# Percentage of the requests served within a certain time (ms)
  # 50%      0
  # 66%      0
  # 75%      0
  # 80%      0
  # 90%      0
  # 95%      0
  # 98%      0
  # 99%      0
 # 100%      1 (longest request)