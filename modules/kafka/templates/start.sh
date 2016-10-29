#!/usr/bin/env bash

PATH=/usr/local/bin:$PATH

yum install -y jq

curl -L http://s3.amazonaws.com/ec2metadata/ec2-metadata > /usr/local/bin/ec2metadata
chmod +x /usr/local/bin/ec2metadata

INSTANCE_ID=$(/usr/local/bin/ec2metadata -i | cut -d ' ' -f 2)
PUBLIC_HOSTNAME=$(/usr/local/bin/ec2metadata -p | cut -d ' ' -f 2)
PUBLIC_IP=$(/usr/local/bin/ec2metadata -v | cut -d ' ' -f 2)

while [ -z "$instance_arn" ]; do
    sleep 2
    instance_arn=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $NF}' )
done

region=${aws_region}

aws ecs start-task --cluster ${ecs_cluster} --task-definition ${zookeeper_task} --container-instances $instance_arn --region $region --overrides "{\"containerOverrides\": [{\"name\": \"zookeeper\", \"environment\": [{\"name\": \"HOSTNAME\", \"value\": \"$${PUBLIC_HOSTNAME}\"}]}]}"

