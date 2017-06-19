# route53-export
Export all of your Route53 zones in BIND format and transfer them to S3

# Configuration
This is primarily designed to be run from AWS ECS as a scheduled task.  As such, you will need:

* A pre-existing S3 location where the Route53 zone files will be dumped
* A role that allows read to Route53 and read/write to the S3 bucket (and key) you wish to write the exports to
* a task definition referencing the container (signiant/route53-export) and passing the S3 location as the docker command (ie. s3://mybucket/mykey)
  * A sample ECS taskdef is included in this project

# Running from the command line
If you wish to run from the command line, a sample docker run command is

```bash
docker run \
   -e AWS_ACCESS_KEY_ID='YOUR_AK' \
   -e AWS_SECRET_ACCESS_KEY='YOUR SK' \
   signiant/route53-export s3://mybucket/mykey
```
