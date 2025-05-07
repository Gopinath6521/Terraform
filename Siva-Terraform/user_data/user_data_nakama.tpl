##!/bin/bash
#rds_password = ${rds_password}
#rds_endpoint = ${rds_endpoint}
#DB_HOST      = ${DB_HOST}
#ecr_tag=$(aws --region=ap-south-1 ssm get-parameter --name '/cf/dev/admin' --output text --query Parameter.Value)
#aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 876529261348.dkr.ecr.ap-south-1.amazonaws.com
#touch .env.list
#aws s3 cp s3://cf-artifact-bucket/dev/admin-service/admin.list .env.list
#sed -i s'|XXXX|${rds_password}|g' .env.list
#sed -i s'|AAAA|${DB_HOST}|g' .env.list
#docker run --env-file .env.list --name cf-main-admin -itd --net="host" --restart always 876529261348.dkr.ecr.ap-south-1.amazonaws.com/cf-admin-repo:${ecr_tag}

