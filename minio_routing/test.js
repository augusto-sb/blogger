//const Minio = require('minio');
import * as Minio from 'minio'
//const Minio = require('minio');

const minioClient = new Minio.Client({
  endPoint: 'localhost',
  port: 8080,
  useSSL: false,
  accessKey: 'adminadmin',
  secretKey: 'adminadmin',
})

const bucket = 'js-test-bucket'
const exists = await minioClient.bucketExists(bucket)
if (exists) {
  console.log('Bucket ' + bucket + ' exists.')
} else {
  await minioClient.makeBucket(bucket, 'us-east-1')
  console.log('Bucket ' + bucket + ' created in "us-east-1".')
}