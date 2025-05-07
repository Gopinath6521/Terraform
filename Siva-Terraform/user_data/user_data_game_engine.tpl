#!/bin/bash
ecr_tag=$(aws --region=ap-south-1 ssm get-parameter --name '/cf/dev/game-engine' --output text --query Parameter.Value)
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 876529261348.dkr.ecr.ap-south-1.amazonaws.com
touch .env.list
aws s3 cp s3://cf-artifact-bucket/dev04/game-engine.list .env.list
docker run --env-file .env.list --name cf-game-engine-service -itd --net="host" --restart always 876529261348.dkr.ecr.ap-south-1.amazonaws.com/cf-game-engine-repo:${ecr_tag}
