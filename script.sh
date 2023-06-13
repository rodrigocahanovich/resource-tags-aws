#!/bin/bash

#aws resourcegroupstaggingapi get-resources | jq '.ResourceTagMappingList[].ResourceARN' | sed -e 's/"//g' > resources.txt
#Cria Arquivo CSVs
echo "Regiao,DomainName;Status;NotAfter;Type" > acm.csv
echo "Regiao;RestApi;Name;TipoEndpoint;StartTime" > apigateway-restapi.csv
echo "Regiao;BackupVault;NumberOfRecoveryPoints;StartTime" > backup-backupvault.csv
echo "Regiao;StackName;CreationTime;LastUpdatedTime" > cloudformation-stack.csv
echo "Regiao;SnapshotId;VolumeId;VolumeSize;StartTime" > ec2-snapshot.csv
echo "Regiao;AllocationId;PublicIp;AssociationId" > ec2-elastic-ip.csv
echo "Regiao;InstanceId;InstanceType;LaunchTime;PublicDnsName;PlatformDetails" > ec2-instances.csv
echo "Regiao;ImageId;VirtualizationType;PlatformDetails;State;Public" > ec2-images.csv
echo "Regiao;LaunchTemplateId;LatestVersionNumber;LaunchTemplateName;CreateTime;KeyName;InstanceType" > ec2-launch-template.csv
echo "Regiao;NatGatewayId;PublicIp;ConnectivityType;NetworkInterfaceId;CreateTime" > ec2-nat-gateway.csv
echo "Regiao;NetworkInterfaceId;InterfaceType;PublicIp;PrivateIpAddress;Status" > ec2-network-interface.csv
echo "Regiao;RouteTableId;VpcId" > ec2-route-tables.csv
echo "Regiao;GroupId;GroupName;VpcId" > ec2-security-groups.csv
echo "Regiao;SubnetId;State;AvailabilityZone;CidrBlock;AvailableIpAddressCount;VpcId;MapPublicIpOnLaunch" > ec2-subnets.csv
echo "Regiao;VolumeId;State;Size;VolumeType;SnapshotId;CreateTime" > ec2-volumes.csv
echo "Regiao;VpcId;CidrBlock" > ec2-vpc.csv
echo "Regiao;VpcPeeringConnectionId;AcceptVpcId;AcceptOwnerId;RequestVpcIdCidrBlock;RequestOwnerId" > ec2-vpc-peering.csv
echo "Regiao;VpnConnectionId;VpnGatewayId;CustomerGatewayId" > ec2-vpn-connections.csv
echo "Regiao;VpcEndpointId;VpcEndpointType;VpcId;ServiceName" > ec2-vpc-endpoint.csv
echo "Regiao;VpnGatewayId;State;VpcId" > ec2-vpn-gateway.csv
echo "Regiao;InternetGatewayId;State;VpcId" > ec2-internet-gateway.csv
echo "Regiao;CustomerGatewayId;IpAddress" > ec2-customer-gateway.csv
echo "Regiao;name;version;endpoint;vpcId;endpointPublicAccess" > eks-cluster.csv
echo "Regiao;name;nodegroup;capacityType;instanceTypes;minSize;maxSize;desiredSize" > eks-nodegroup.csv
echo "Regiao;ApplicationName;TierName; TierType;SolutionStackName" > elasticbeanstalk.csv
echo "Regiao;DBClusterIdentifier;Engine;Endpoint;BackupRetentionPeriod;MultiAZ;EngineVersion" > rds.csv
echo "Regiao;DBInstanceIdentifier;DBInstanceClass;Engine;Endpoint;BackupRetentionPeriod;MultiAZ;EngineVersion;PubliclyAccessible" > rds-db.csv
echo "Regiao;DBClusterIdentifier;DBClusterSnapshotIdentifier;SnapshotCreateTime" > rds-snapshot.csv
echo "Regiao;DBSnapshotIdentifier;DBInstanceIdentifier;SnapshotType;SnapshotCreateTime" > rds-manualsnapshot.csv
echo "Regiao;QueueName;QueueUrl;VisibilityTimeout;MaximumMessageSize;MessageRetentionPeriod;RedrivePolicy" > sqs.csv
echo "Regiao;TopicName;SubscriptionsConfirmed" > sns.csv
echo "Regiao;ReplicationGroupId;CacheClusterId;CacheNodeType;Engine;EngineVersion;SnapshotRetentionLimit" > elasticache.csv
echo "Regiao;CacheClusterId;SnapshotName;CacheSize;SnapshotCreateTime" > elasticache-snapshot.csv
echo "Regiao;LoadBalancerName;DNSName;VPCId;Scheme;Type" > elb.csv
echo "Regiao;LoadBalancerName;DNSName;VPCId;Scheme;Type" > elbv2.csv
echo "Regiao;FunctionName;Runtime;CodeSize;MemorySize;VpcId;Architectures;EphemeralStorage" > lambda.csv
echo "Regiao;BucketName;Objects;Size" > s3.csv
echo "Regiao;repositoryName;registryId;imageTagMutability" > ecr.csv

for geral in $(aws resourcegroupstaggingapi get-resources | jq '.ResourceTagMappingList[].ResourceARN' | sed -e 's/"//g'); do
	servico=$(echo $geral | cut -d ':' -f 3)
	if [ "$servico" == "apigateway" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		if [ "$recurso" == "restapis" ]; then
			Stage=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 4)
			if [ "$Stage" != "stages" ]; then
				subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 3)			
				regiao=$(echo $geral | cut -d ':' -f 4)
		    	echo -n $regiao >> apigateway-restapi.csv
				echo -n ";" >> apigateway-restapi.csv
				echo -n $subrecurso >> apigateway-restapi.csv
				echo -n ";" >> apigateway-restapi.csv
				Name=$(aws apigateway get-rest-api --rest-api-id $subrecurso | jq .'name' | cut -d '[' -f 1 | cut -d ']' -f 1 | sed -e '/^$/d' | cut -d '"' -f 2)
				echo -n $Name >> apigateway-restapi.csv
				echo -n ";" >> apigateway-restapi.csv
				TipoEndpoint=$(aws apigateway get-rest-api --rest-api-id $subrecurso | jq .'endpointConfiguration[]' | cut -d '[' -f 1 | cut -d ']' -f 1 | sed -e '/^$/d' | cut -d '"' -f 2)
				echo -n $TipoEndpoint >> apigateway-restapi.csv
				echo -n ";" >> apigateway-restapi.csv
				StartTime=$(aws apigateway get-rest-api --rest-api-id $subrecurso | jq '.createdDate' | cut -d 'T' -f 1 | cut -d '"' -f 2)
				echo -n $StartTime >> apigateway-restapi.csv
				echo '' >> apigateway-restapi.csv
			fi
        fi
	elif [ "$servico" == "backup" ]; then			
		recurso=$(echo $geral | cut -d ':' -f 6)
		if [ "$recurso" == "backup-vault" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)			
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> backup-backupvault.csv
			echo -n ";" >> backup-backupvault.csv
			echo -n $subrecurso >> backup-backupvault.csv
			echo -n ";" >> backup-backupvault.csv
			NumberOfRecoveryPoints=$(aws backup describe-backup-vault --backup-vault-name $subrecurso | jq '.NumberOfRecoveryPoints')
			echo -n $NumberOfRecoveryPoints >> backup-backupvault.csv
			echo -n ";" >> backup-backupvault.csv
			StartTime=$(aws backup describe-backup-vault --backup-vault-name $subrecurso | jq '.CreationDate' | cut -d 'T' -f 1 | cut -d '"' -f 2)
			echo -n $StartTime >> backup-backupvault.csv
			echo '' >> backup-backupvault.csv
		else
			echo $geral
		fi
	elif [ "$servico" == "cloudformation" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)		
		if [ "$recurso" == "stack" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> cloudformation-stack.csv
			echo -n ";" >> cloudformation-stack.csv
			echo -n $subrecurso >> cloudformation-stack.csv
			echo -n ";" >> cloudformation-stack.csv
			CreationTime=$(aws cloudformation describe-stacks --stack-name $subrecurso | jq '.Stacks[].CreationTime' | cut -d 'T' -f 1 | cut -d '"' -f 2)
			echo -n $CreationTime >> cloudformation-stack.csv
			echo -n ";" >> cloudformation-stack.csv
			LastUpdatedTime=$(aws cloudformation describe-stacks --stack-name $subrecurso | jq '.Stacks[].LastUpdatedTime' | cut -d 'T' -f 1 | cut -d '"' -f 2)
			echo -n $LastUpdatedTime >> cloudformation-stack.csv
			echo '' >> cloudformation-stack.csv
		else
			echo $geral
		fi
	elif [ "$servico" == "cloudwatch" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "codepipeline" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "codebuild" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "dms" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "logs" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "appsync" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "transfer" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "ecs" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "es" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "dynamodb" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
	elif [ "$servico" == "ec2" ];then
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)		
		if [ "$recurso" == "snapshot" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-snapshot.csv
			echo -n ";" >> ec2-snapshot.csv
			echo -n $subrecurso >> ec2-snapshot.csv
			echo -n ";" >> ec2-snapshot.csv
			VolumeId=$(aws ec2 describe-snapshots --snapshot-ids $subrecurso | jq '.Snapshots[].VolumeId' | cut -d '"' -f 2)
			echo -n $VolumeId >> ec2-snapshot.csv
			echo -n ";" >> ec2-snapshot.csv
			VolumeSize=$(aws ec2 describe-snapshots --snapshot-ids $subrecurso | jq '.Snapshots[].VolumeSize')
			echo -n $VolumeSize >> ec2-snapshot.csv
			echo -n ";" >> ec2-snapshot.csv
			StartTime=$(aws ec2 describe-snapshots --snapshot-ids $subrecurso | jq '.Snapshots[].StartTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
			echo -n $StartTime >> ec2-snapshot.csv
			echo '' >> ec2-snapshot.csv
		elif [ "$recurso" == "elastic-ip" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-elastic-ip.csv
			echo -n ";" >> ec2-elastic-ip.csv
			echo -n $subrecurso >> ec2-elastic-ip.csv
			echo -n ";" >> ec2-elastic-ip.csv
			PublicIp=$(aws ec2 describe-addresses --allocation-ids $subrecurso | jq '.Addresses[].PublicIp' | cut -d '"' -f 2)
			echo -n $PublicIp >> ec2-elastic-ip.csv
			echo -n ";" >> ec2-elastic-ip.csv
			AssociationId=$(aws ec2 describe-addresses --allocation-ids $subrecurso | jq '.Addresses[].AssociationId' | cut -d '"' -f 2)
			echo -n $AssociationId >> ec2-elastic-ip.csv
			echo '' >> ec2-elastic-ip.csv
		elif [ "$recurso" == "instance" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-instances.csv
			echo -n ";" >> ec2-instances.csv
			echo -n $subrecurso >> ec2-instances.csv
			echo -n ";" >> ec2-instances.csv
			InstanceType=$(aws ec2 describe-instances --instance-ids $subrecurso | jq '.Reservations[].Instances[].InstanceType' | cut -d '"' -f 2)
			echo -n $InstanceType >> ec2-instances.csv
			echo -n ";" >> ec2-instances.csv
			LaunchTime=$(aws ec2 describe-instances --instance-ids $subrecurso | jq '.Reservations[].Instances[].LaunchTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
			echo -n $LaunchTime >> ec2-instances.csv
			echo -n ";" >> ec2-instances.csv
			PublicDnsName=$(aws ec2 describe-instances --instance-ids $subrecurso | jq '.Reservations[].Instances[].PublicDnsName' | cut -d '"' -f 2)
			echo -n $PublicDnsName >> ec2-instances.csv
			echo -n ";" >> ec2-instances.csv
			PlatformDetails=$(aws ec2 describe-instances --instance-ids $subrecurso | jq '.Reservations[].Instances[].PlatformDetails' | cut -d '"' -f 2)
			echo -n $PlatformDetails >> ec2-instances.csv
			echo '' >> ec2-instances.csv
		elif [ "$recurso" == "image" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)		
			regiao=$(echo $geral | cut -d ':' -f 4)
			echo -n $regiao >> ec2-images.csv
			echo -n ";" >> ec2-images.csv
			echo -n $subrecurso >> ec2-images.csv
			echo -n ";" >> ec2-images.csv
			VirtualizationType=$(aws ec2 describe-images --image-ids $subrecurso | jq '.Images[].VirtualizationType' | cut -d '"' -f 2)
			echo -n $VirtualizationType >> ec2-images.csv
			echo -n ";" >> ec2-images.csv
			PlatformDetails=$(aws ec2 describe-images --image-ids $subrecurso | jq '.Images[].PlatformDetails' | cut -d '"' -f 2)
			echo -n $PlatformDetails >> ec2-images.csv
			echo -n ";" >> ec2-images.csv
			State=$(aws ec2 describe-images --image-ids $subrecurso | jq '.Images[].PlatformDetails' | cut -d '"' -f 2)
			echo -n $State >> ec2-images.csv
			echo -n ";" >> ec2-images.csv
			Public=$(aws ec2 describe-images --image-ids $subrecurso | jq '.Images[].Public' | cut -d '"' -f 2)
			echo -n $Public >> ec2-images.csv
			echo '' >> ec2-images.csv
		elif [ "$recurso" == "key-pair" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)		
			regiao=$(echo $geral | cut -d ':' -f 4)
		elif [ "$recurso" == "transit-gateway" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)		
			regiao=$(echo $geral | cut -d ':' -f 4)
		elif [ "$recurso" == "launch-template" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)						
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-launch-template.csv
			echo -n ";" >> ec2-launch-template.csv
			echo -n $subrecurso >> ec2-launch-template.csv
			echo -n ";" >> ec2-launch-template.csv
			LatestVersionNumber=$(aws ec2 describe-launch-templates --launch-template-id $subrecurso | jq '.LaunchTemplates[].LatestVersionNumber' | cut -d '"' -f 2)
			echo -n $LatestVersionNumber >> ec2-launch-template.csv
			echo -n ";" >> ec2-launch-template.csv
			LaunchTemplateName=$(aws ec2 describe-launch-templates --launch-template-id $subrecurso | jq '.LaunchTemplates[].LaunchTemplateName' | cut -d '"' -f 2)
			echo -n $LaunchTemplateName >> ec2-launch-template.csv
			echo -n ";" >> ec2-launch-template.csv
			CreateTime=$(aws ec2 describe-launch-templates --launch-template-id $subrecurso | jq '.LaunchTemplates[].CreateTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
			echo -n $CreateTime >> ec2-launch-template.csv
			echo -n ";" >> ec2-launch-template.csv
			KeyName=$(aws ec2 describe-launch-template-versions --launch-template-id $subrecurso --versions $LatestVersionNumber | jq '.LaunchTemplateVersions[].LaunchTemplateData.KeyName' | cut -d '"' -f 2)
			echo -n $KeyName >> ec2-launch-template.csv
			echo -n ";" >> ec2-launch-template.csv
			InstanceType=$(aws ec2 describe-launch-template-versions --launch-template-id $subrecurso --versions $LatestVersionNumber | jq '.LaunchTemplateVersions[].LaunchTemplateData.InstanceType' | cut -d '"' -f 2)
			echo -n $InstanceType >> ec2-launch-template.csv
			echo '' >> ec2-launch-template.csv
		elif [ "$recurso" == "natgateway" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)						
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-nat-gateway.csv
			echo -n ";" >> ec2-nat-gateway.csv
			echo -n $subrecurso >> ec2-nat-gateway.csv
			echo -n ";" >> ec2-nat-gateway.csv
			PublicIp=$(aws ec2 describe-nat-gateways --nat-gateway-ids $subrecurso | jq '.NatGateways[].NatGatewayAddresses[].PublicIp' | cut -d '"' -f 2)
			echo -n $PublicIp >> ec2-nat-gateway.csv
			echo -n ";" >> ec2-nat-gateway.csv
			ConnectivityType=$(aws ec2 describe-nat-gateways --nat-gateway-ids $subrecurso | jq '.NatGateways[].ConnectivityType' | cut -d '"' -f 2)
			echo -n $ConnectivityType >> ec2-nat-gateway.csv
			echo -n ";" >> ec2-nat-gateway.csv
			NetworkInterfaceId=$(aws ec2 describe-nat-gateways --nat-gateway-ids $subrecurso | jq '.NatGateways[].NatGatewayAddresses[].NetworkInterfaceId' | cut -d '"' -f 2)
			echo -n $NetworkInterfaceId >> ec2-nat-gateway.csv
			echo -n ";" >> ec2-nat-gateway.csv
			CreateTime=$(aws ec2 describe-nat-gateways --nat-gateway-ids $subrecurso | jq '.NatGateways[].CreateTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
			echo -n $CreateTime >> ec2-nat-gateway.csv
			echo '' >> ec2-nat-gateway.csv
		elif [ "$recurso" == "network-insights-access-scope" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			
		elif [ "$recurso" == "network-interface" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-network-interface.csv
			echo -n ";" >> ec2-network-interface.csv
			echo -n $subrecurso >> ec2-network-interface.csv
			echo -n ";" >> ec2-network-interface.csv
			InterfaceType=$(aws ec2 describe-network-interfaces --network-interface-ids $subrecurso | jq '.NetworkInterfaces[].InterfaceType' | cut -d '"' -f 2)
			echo -n $InterfaceType >> ec2-network-interface.csv
			echo -n ";" >> ec2-network-interface.csv
			PublicIp=$(aws ec2 describe-network-interfaces --network-interface-ids $subrecurso | jq '.NetworkInterfaces[].Association.PublicIp' | cut -d '"' -f 2)
			echo -n $PublicIp >> ec2-network-interface.csv
			echo -n ";" >> ec2-network-interface.csv
			PrivateIpAddress=$(aws ec2 describe-network-interfaces --network-interface-ids $subrecurso | jq '.NetworkInterfaces[].PrivateIpAddress' | cut -d '"' -f 2)
			echo -n $PrivateIpAddress >> ec2-network-interface.csv
			echo -n ";" >> ec2-network-interface.csv
			Status=$(aws ec2 describe-network-interfaces --network-interface-ids $subrecurso | jq '.NetworkInterfaces[].Status' | cut -d '"' -f 2)
			echo -n $Status >> ec2-network-interface.csv
			echo '' >> ec2-network-interface.csv
		elif [ "$recurso" == "route-table" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)						
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-route-tables.csv
			echo -n ";" >> ec2-route-tables.csv
			echo -n $subrecurso >> ec2-route-tables.csv
			echo -n ";" >> ec2-route-tables.csv
			VpcId=$(aws ec2 describe-route-tables --route-table-ids $subrecurso | jq '.RouteTables[].VpcId' | cut -d '"' -f 2)
			echo -n $VpcId >> ec2-route-tables.csv
			echo '' >> ec2-route-tables.csv
		elif [ "$recurso" == "security-group" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-security-groups.csv
			echo -n ";" >> ec2-security-groups.csv
			echo -n $subrecurso >> ec2-security-groups.csv
			echo -n ";" >> ec2-security-groups.csv
			GroupName=$(aws ec2 describe-security-groups --group-ids $subrecurso | jq '.SecurityGroups[].GroupName' | cut -d '"' -f 2)
			echo -n $GroupName >> ec2-security-groups.csv
			echo -n ";" >> ec2-security-groups.csv
			VpcId=$(aws ec2 describe-security-groups --group-ids $subrecurso | jq '.SecurityGroups[].VpcId' | cut -d '"' -f 2)
			echo -n $VpcId >> ec2-security-groups.csv
			echo '' >> ec2-security-groups.csv
		elif [ "$recurso" == "subnet" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-subnets.csv
			echo -n ";" >> ec2-subnets.csv
			echo -n $subrecurso >> ec2-subnets.csv
			echo -n ";" >> ec2-subnets.csv
			State=$(aws ec2 describe-subnets --subnet-ids $subrecurso | jq '.Subnets[].State' | cut -d '"' -f 2)
			echo -n $State >> ec2-subnets.csv
			echo -n ";" >> ec2-subnets.csv
			AvailabilityZone=$(aws ec2 describe-subnets --subnet-ids $subrecurso | jq '.Subnets[].AvailabilityZone' | cut -d '"' -f 2)
			echo -n $AvailabilityZone >> ec2-subnets.csv
			echo -n ";" >> ec2-subnets.csv
			CidrBlock=$(aws ec2 describe-subnets --subnet-ids $subrecurso | jq '.Subnets[].CidrBlock' | cut -d '"' -f 2)
			echo -n $CidrBlock >> ec2-subnets.csv
			echo -n ";" >> ec2-subnets.csv
			AvailableIpAddressCount=$(aws ec2 describe-subnets --subnet-ids $subrecurso | jq '.Subnets[].AvailableIpAddressCount' | cut -d '"' -f 2)
			echo -n $AvailableIpAddressCount >> ec2-subnets.csv
			echo -n ";" >> ec2-subnets.csv
			VpcId=$(aws ec2 describe-subnets --subnet-ids $subrecurso | jq '.Subnets[].VpcId' | cut -d '"' -f 2)
			echo -n $VpcId >> ec2-subnets.csv
			echo -n ";" >> ec2-subnets.csv
			MapPublicIpOnLaunch=$(aws ec2 describe-subnets --subnet-ids $subrecurso | jq '.Subnets[].MapPublicIpOnLaunch' | cut -d '"' -f 2)
			echo -n $MapPublicIpOnLaunch >> ec2-subnets.csv
			echo '' >> ec2-subnets.csv
		elif [ "$recurso" == "volume" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)	
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-volumes.csv
			echo -n ";" >> ec2-volumes.csv
			echo -n $subrecurso >> ec2-volumes.csv
			echo -n ";" >> ec2-volumes.csv
			State=$(aws ec2 describe-volumes --volume-ids $subrecurso | jq '.Volumes[].State' | cut -d '"' -f 2)
			echo -n $State >> ec2-volumes.csv
			echo -n ";" >> ec2-volumes.csv
			Size=$(aws ec2 describe-volumes --volume-ids $subrecurso | jq '.Volumes[].Size' | cut -d '"' -f 2)
			echo -n $Size >> ec2-volumes.csv
			echo -n ";" >> ec2-volumes.csv
			VolumeType=$(aws ec2 describe-volumes --volume-ids $subrecurso | jq '.Volumes[].VolumeType' | cut -d '"' -f 2)
			echo -n $VolumeType >> ec2-volumes.csv
			echo -n ";" >> ec2-volumes.csv
			SnapshotId=$(aws ec2 describe-volumes --volume-ids $subrecurso | jq '.Volumes[].SnapshotId' | cut -d '"' -f 2)
			echo -n $SnapshotId >> ec2-volumes.csv
			echo -n ";" >> ec2-volumes.csv
			CreateTime=$(aws ec2 describe-volumes --volume-ids $subrecurso | jq '.Volumes[].CreateTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
			echo -n $CreateTime >> ec2-volumes.csv
			echo '' >> ec2-volumes.csv
		elif [ "$recurso" == "vpc" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)						
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-vpc.csv
			echo -n ";" >> ec2-vpc.csv
			echo -n $subrecurso >> ec2-vpc.csv
			echo -n ";" >> ec2-vpc.csv
			CidrBlock=$(aws ec2 describe-vpcs --vpc-ids $subrecurso | jq '.Vpcs[].CidrBlock' | cut -d '"' -f 2)
			echo -n $CidrBlock >> ec2-vpc.csv
			echo '' >> ec2-vpc.csv
		elif [ "$recurso" == "vpc-peering-connection" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-vpc-peering.csv
			echo -n ";" >> ec2-vpc-peering.csv
			echo -n $subrecurso >> ec2-vpc-peering.csv
			echo -n ";" >> ec2-vpc-peering.csv
			AcceptVpcId=$(aws ec2 describe-vpc-peering-connections --vpc-peering-connection-ids $subrecurso | jq '.VpcPeeringConnections[].AccepterVpcInfo.VpcId' | cut -d '"' -f 2)
			echo -n $AcceptVpcId >> ec2-vpc-peering.csv
			echo -n ";" >> ec2-vpc-peering.csv
			AcceptOwnerId=$(aws ec2 describe-vpc-peering-connections --vpc-peering-connection-ids $subrecurso | jq '.VpcPeeringConnections[].AccepterVpcInfo.OwnerId' | cut -d '"' -f 2)
			echo -n $AcceptOwnerId >> ec2-vpc-peering.csv
			echo -n ";" >> ec2-vpc-peering.csv
			RequestVpcIdCidrBlock=$(aws ec2 describe-vpc-peering-connections --vpc-peering-connection-ids $subrecurso | jq '.VpcPeeringConnections[].RequesterVpcInfo.VpcId' | cut -d '"' -f 2)
			echo -n $RequestVpcIdCidrBlock >> ec2-vpc-peering.csv
			echo -n ";" >> ec2-vpc-peering.csv
			RequestOwnerId=$(aws ec2 describe-vpc-peering-connections --vpc-peering-connection-ids $subrecurso | jq '.VpcPeeringConnections[].RequesterVpcInfo.OwnerId' | cut -d '"' -f 2)
			echo -n $RequestOwnerId >> ec2-vpc-peering.csv
			echo '' >> ec2-vpc-peering.csv
		elif [ "$recurso" == "vpn-connection" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-vpn-connections.csv
			echo -n ";" >> ec2-vpn-connections.csv
			echo -n $subrecurso >> ec2-vpn-connections.csv
			echo -n ";" >> ec2-vpn-connections.csv
			VpnGatewayId=$(aws ec2 describe-vpn-connections --vpn-connection-ids $subrecurso | jq '.VpnConnections[].VpnGatewayId' | cut -d '"' -f 2)
			echo -n $VpnGatewayId >> ec2-vpn-connections.csv
			echo -n ";" >> ec2-vpn-connections.csv
			CustomerGatewayId=$(aws ec2 describe-vpn-connections --vpn-connection-ids $subrecurso | jq '.VpnConnections[].CustomerGatewayId' | cut -d '"' -f 2)
			echo -n $CustomerGatewayId >> ec2-vpn-connections.csv
			echo '' >> ec2-vpn-connections.csv
		elif [ "$recurso" == "vpc-endpoint" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)	
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-vpc-endpoint.csv
			echo -n ";" >> ec2-vpc-endpoint.csv
			echo -n $subrecurso >> ec2-vpc-endpoint.csv
			echo -n ";" >> ec2-vpc-endpoint.csv
			VpcEndpointType=$(aws ec2 describe-vpc-endpoints --vpc-endpoint-ids $subrecurso | jq '.VpcEndpoints[].VpcEndpointType' | cut -d '"' -f 2)
			echo -n $VpcEndpointType >> ec2-vpc-endpoint.csv
			echo -n ";" >> ec2-vpc-endpoint.csv
			VpcId=$(aws ec2 describe-vpc-endpoints --vpc-endpoint-ids $subrecurso | jq '.VpcEndpoints[].VpcId' | cut -d '"' -f 2)
			echo -n $VpcId >> ec2-vpc-endpoint.csv
			echo -n ";" >> ec2-vpc-endpoint.csv
			ServiceName=$(aws ec2 describe-vpc-endpoints --vpc-endpoint-ids $subrecurso | jq '.VpcEndpoints[].ServiceName' | cut -d '"' -f 2)
			echo -n $ServiceName >> ec2-vpc-endpoint.csv
			echo '' >> ec2-vpc-endpoint.csv
		elif [ "$recurso" == "vpn-gateway" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)
		    echo -n $regiao >> ec2-vpn-gateway.csv
			echo -n ";" >> ec2-vpn-gateway.csv
			echo -n $subrecurso >> ec2-vpn-gateway.csv
			echo -n ";" >> ec2-vpn-gateway.csv
			State=$(aws ec2 describe-vpn-gateways --vpn-gateway-ids $subrecurso | jq '.VpnGateways[].VpcAttachments[].State' | cut -d '"' -f 2)
			echo -n $State >> ec2-vpn-gateway.csv
			echo -n ";" >> ec2-vpn-gateway.csv
			VpcId=$(aws ec2 describe-vpn-gateways --vpn-gateway-ids $subrecurso | jq '.VpnGateways[].VpcAttachments[].VpcId' | cut -d '"' -f 2)
			echo -n $VpcId >> ec2-vpn-gateway.csv
			echo '' >> ec2-vpn-gateway.csv
		elif [ "$recurso" == "internet-gateway" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)	
            regiao=$(echo $geral | cut -d ':' -f 4)
			echo -n $regiao >> ec2-internet-gateway.csv
			echo -n ";" >> ec2-internet-gateway.csv
			echo -n $subrecurso >> ec2-internet-gateway.csv
			echo -n ";" >> ec2-internet-gateway.csv
			State=$(aws ec2 describe-internet-gateways --internet-gateway-ids $subrecurso | jq '.InternetGateways[].Attachments[].State' | cut -d '"' -f 2)
			echo -n $State >> ec2-internet-gateway.csv
			echo -n ";" >> ec2-internet-gateway.csv
			VpcId=$(aws ec2 describe-internet-gateways --internet-gateway-ids $subrecurso | jq '.InternetGateways[].Attachments[].VpcId' | cut -d '"' -f 2)
			echo -n $VpcId >> ec2-internet-gateway.csv
			echo '' >> ec2-internet-gateway.csv
		elif [ "$recurso" == "customer-gateway" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			regiao=$(echo $geral | cut -d ':' -f 4)			
			echo -n $regiao >> ec2-customer-gateway.csv
			echo -n ";" >> ec2-customer-gateway.csv
			echo -n $subrecurso >> ec2-customer-gateway.csv
			echo -n ";" >> ec2-customer-gateway.csv
			IpAddress=$(aws ec2 describe-customer-gateways --customer-gateway-ids $subrecurso | jq '.CustomerGateways[].IpAddress' | cut -d '"' -f 2)
			echo -n $IpAddress >> ec2-customer-gateway.csv
			echo '' >> ec2-customer-gateway.csv
		elif [ "$recurso" == "dhcp-options" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		elif [ "$recurso" == "network-acl" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		else
			echo $geral
		fi
	elif [ "$servico" == "ecs" ]; then	
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		if [ "$recurso" == "task-definition" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		else
			echo $geral
		fi
	elif [ "$servico" == "rds" ]; then	
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		if [ "$recurso" == "cluster" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)			
			regiao=$(echo $geral | cut -d ':' -f 4)			
			echo -n $regiao >> rds.csv
			echo -n ";" >> rds.csv
			echo -n $subrecurso >> rds.csv
			echo -n ";" >> rds.csv
			DBClusterIdentifier=$(aws rds describe-db-clusters --db-cluster-identifier $subrecurso | jq  '.DBClusters[].DBClusterIdentifier' | cut -d '"' -f 2)
			echo -n $DBInstanceIdentifier >> rds.csv
			echo -n ";" >> rds.csv			
			Engine=$(aws rds describe-db-clusters --db-cluster-identifier $subrecurso | jq  '.DBClusters[].Engine' | cut -d '"' -f 2)
			echo -n $Engine >> rds.csv
			echo -n ";" >> rds.csv
			Endpoint=$(aws rds describe-db-clusters --db-cluster-identifier $subrecurso | jq  '.DBClusters[].Endpoint' | cut -d '"' -f 2)
			echo -n $Endpoint >> rds.csv
			echo -n ";" >> rds.csv
			BackupRetentionPeriod=$(aws rds describe-db-clusters --db-cluster-identifier $subrecurso | jq  '.DBClusters[].BackupRetentionPeriod' | cut -d '"' -f 2)
			echo -n $BackupRetentionPeriod >> rds.csv
			echo -n ";" >> rds.csv
			MultiAZ=$(aws rds describe-db-clusters --db-cluster-identifier $subrecurso | jq  '.DBClusters[].MultiAZ' | cut -d '"' -f 2)
			echo -n $MultiAZ >> rds.csv
			echo -n ";" >> rds.csv
			EngineVersion=$(aws rds describe-db-clusters --db-cluster-identifier $subrecurso | jq  '.DBClusters[].EngineVersion' | cut -d '"' -f 2)
			echo -n $EngineVersion >> rds.csv
			echo '' >> rds.csv
		elif [ "$recurso" == "cluster-snapshot" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)			
			echo -n $regiao >> rds-snapshot.csv
			echo -n ";" >> rds-snapshot.csv
			echo $geral
			semrds=$(echo $geral | cut -d ':' -f 7)
			if [ "$semrds" = "rds" ]; then
				DBClusterSnapshotIdentifier=$(echo $geral | cut -d ':' -f 8)
				DBClusterIdentifier=$(aws rds describe-db-cluster-snapshots --db-cluster-snapshot-identifier rds:$DBClusterSnapshotIdentifier | jq '.DBClusterSnapshots[].DBClusterIdentifier' | cut -d '"' -f 2)
				echo -n $DBClusterIdentifier >> rds-snapshot.csv
				echo -n ";" >> rds-snapshot.csv
				echo -n $DBClusterSnapshotIdentifier >> rds-snapshot.csv
				echo -n ";" >> rds-snapshot.csv
				SnapshotCreateTime=$(aws rds describe-db-cluster-snapshots --db-cluster-snapshot-identifier rds:$DBClusterSnapshotIdentifier | jq '.DBClusterSnapshots[].SnapshotCreateTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
				echo -n $SnapshotCreateTime >> rds-snapshot.csv
				echo '' >> rds-snapshot.csv
			else 				
				DBClusterSnapshotIdentifier=$(echo $geral | cut -d ':' -f 7)
				DBClusterIdentifier=$(aws rds describe-db-cluster-snapshots --db-cluster-snapshot-identifier $DBClusterSnapshotIdentifier | jq '.DBClusterSnapshots[].DBClusterIdentifier' | cut -d '"' -f 2)
				echo -n $DBClusterIdentifier >> rds-snapshot.csv
				echo -n ";" >> rds-snapshot.csv
				echo -n $DBClusterSnapshotIdentifier >> rds-snapshot.csv
				echo -n ";" >> rds-snapshot.csv
				SnapshotCreateTime=$(aws rds describe-db-cluster-snapshots --db-cluster-snapshot-identifier $DBClusterSnapshotIdentifier | jq '.DBClusterSnapshots[].SnapshotCreateTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
				echo -n $SnapshotCreateTime >> rds-snapshot.csv
				echo '' >> rds-snapshot.csv
			fi
		elif [ "$recurso" == "snapshot" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
			regiao=$(echo $geral | cut -d ':' -f 4)
			if [ "$subrecurso" != "rds" ]; then
				echo -n $regiao >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				echo -n $subrecurso >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				DBInstanceIdentifier=$(aws rds describe-db-snapshots --db-snapshot-identifier $subrecurso | jq '.DBSnapshots[].DBInstanceIdentifier' | cut -d '"' -f 2)
				echo -n $DBInstanceIdentifier >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				SnapshotType=$(aws rds describe-db-snapshots --db-snapshot-identifier $subrecurso | jq '.DBSnapshots[].SnapshotType' | cut -d '"' -f 2)
				echo -n $SnapshotType >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				SnapshotCreateTime=$(aws rds describe-db-snapshots --db-snapshot-identifier $subrecurso | jq '.DBSnapshots[].SnapshotCreateTime' | cut -d '"' -f 2 | cut -d "T" -f 1)
				echo -n $SnapshotCreateTime >> rds-manualsnapshot.csv
				echo "" >> rds-manualsnapshot.csv
			elif [ "$subrecurso" == "rds" ]; then 
				subrecurso=$(echo $geral | cut -d ':' -f 8)				
				echo -n $regiao >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				echo -n $subrecurso >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				DBInstanceIdentifier=$(aws rds describe-db-snapshots --db-snapshot-identifier rds:$subrecurso | jq '.DBSnapshots[].DBInstanceIdentifier' | cut -d '"' -f 2)
				echo -n $DBInstanceIdentifier >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				SnapshotType=$(aws rds describe-db-snapshots --db-snapshot-identifier rds:$subrecurso | jq '.DBSnapshots[].SnapshotType' | cut -d '"' -f 2)
				echo -n $SnapshotType >> rds-manualsnapshot.csv
				echo -n ";" >> rds-manualsnapshot.csv
				SnapshotCreateTime=$(aws rds describe-db-snapshots --db-snapshot-identifier rds:$subrecurso | jq '.DBSnapshots[].SnapshotCreateTime' | cut -d '"' -f 2 | cut -d "T" -f 1)
				echo -n $SnapshotCreateTime >> rds-manualsnapshot.csv
				echo "" >> rds-manualsnapshot.csv
			else
				echo $geral
			fi
		elif [ "$recurso" == "pg" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		elif [ "$recurso" == "og" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		elif [ "$recurso" == "es" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		elif [ "$recurso" == "db" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
			regiao=$(echo $geral | cut -d ':' -f 4)			
			echo -n $regiao >> rds-db.csv
			echo -n ";" >> rds-db.csv
			echo -n $subrecurso >> rds-db.csv
			echo -n ";" >> rds-db.csv						
			DBInstanceClass=$(aws rds describe-db-instances  --db-instance-identifier $subrecurso | jq '.DBInstances[].DBInstanceClass' | cut -d '"' -f 2)
			echo -n $DBInstanceClass >> rds-db.csv
			echo -n ";" >> rds-db.csv
			Engine=$(aws rds describe-db-instances  --db-instance-identifier $subrecurso | jq '.DBInstances[].Engine' | cut -d '"' -f 2)
			echo -n $Engine >> rds-db.csv
			echo -n ";" >> rds-db.csv
			Endpoint=$(aws rds describe-db-instances  --db-instance-identifier $subrecurso | jq '.DBInstances[].Endpoint.Address' | cut -d '"' -f 2)
			echo -n $Endpoint >> rds-db.csv
			echo -n ";" >> rds-db.csv
			BackupRetentionPeriod=$(aws rds describe-db-instances  --db-instance-identifier $subrecurso | jq '.DBInstances[].BackupRetentionPeriod' | cut -d '"' -f 2)
			echo -n $BackupRetentionPeriod >> rds-db.csv
			echo -n ";" >> rds-db.csv
			MultiAZ=$(aws rds describe-db-instances  --db-instance-identifier $subrecurso | jq '.DBInstances[].MultiAZ' | cut -d '"' -f 2)
			echo -n $MultiAZ >> rds-db.csv
			echo -n ";" >> rds-db.csv
			EngineVersion=$(aws rds describe-db-instances  --db-instance-identifier $subrecurso | jq '.DBInstances[].EngineVersion' | cut -d '"' -f 2)
			echo -n $EngineVersion >> rds-db.csv
			echo -n ";" >> rds-db.csv
			PubliclyAccessible=$(aws rds describe-db-instances  --db-instance-identifier $subrecurso | jq '.DBInstances[].PubliclyAccessible' | cut -d '"' -f 2)
			echo -n $PubliclyAccessible >> rds-db.csv
			echo '' >> rds-db.csv
		elif [ "$recurso" == "og" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		elif [ "$recurso" == "subgrp" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		elif [ "$recurso" == "secgrp" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		elif [ "$recurso" == "cluster-pg" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		else
			echo $geral
		fi
	elif [ "$servico" == "sqs" ]; then	
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)		
		subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		regiao=$(echo $geral | cut -d ':' -f 4)			
		echo -n $regiao >> sqs.csv
		echo -n ";" >> sqs.csv
		echo -n $subrecurso >> sqs.csv
		echo -n ";" >> sqs.csv
		QueueUrl=$(aws sqs get-queue-url --queue-name $subrecurso | jq '.QueueUrl' | sed -e 's/"//g')
		echo -n $QueueUrl >> sqs.csv
		echo -n ";" >> sqs.csv
		VisibilityTimeout=$(aws sqs get-queue-attributes --queue-url "$QueueUrl" --attribute-names All | jq '.Attributes.VisibilityTimeout' | cut -d '"' -f 2)
		echo -n $VisibilityTimeout >> sqs.csv
		echo -n ";" >> sqs.csv
		MaximumMessageSize=$(aws sqs get-queue-attributes --queue-url "$QueueUrl" --attribute-names All | jq '.Attributes.MaximumMessageSize' | cut -d '"' -f 2)
		echo -n $MaximumMessageSize >> sqs.csv
		echo -n ";" >> sqs.csv
		MessageRetentionPeriod=$(aws sqs get-queue-attributes --queue-url "$QueueUrl" --attribute-names All | jq '.Attributes.MessageRetentionPeriod' | cut -d '"' -f 2)
		echo -n $MessageRetentionPeriod >> sqs.csv
		echo -n ";" >> sqs.csv
		RedrivePolicy=$(aws sqs get-queue-attributes --queue-url "$QueueUrl" --attribute-names All | jq '.Attributes.RedrivePolicy' | cut -d '"' -f 5 | cut -d '\' -f 1)
		echo -n $RedrivePolicy >> sqs.csv
		echo '' >> sqs.csv
	elif [ "$servico" == "sns" ]; then	
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		regiao=$(echo $geral | cut -d ':' -f 4)			
		echo -n $regiao >> sns.csv
		echo -n ";" >> sns.csv
		echo -n $subrecurso >> sns.csv
		echo -n ";" >> sns.csv
		SubscriptionsConfirmed=$(aws sns get-topic-attributes --topic-arn $geral | jq '.Attributes.SubscriptionsConfirmed' | cut -d '"' -f 2)
		echo -n $SubscriptionsConfirmed >> sns.csv
		echo '' >> sns.csv
	elif [ "$servico" == "kms" ]; then	
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		
	elif [ "$servico" == "cloudtrail" ]; then	
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)

	elif [ "$servico" == "eks" ]; then	
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		if [ "$recurso" == "cluster" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			regiao=$(echo $geral | cut -d ':' -f 4)			
			echo -n $regiao >> eks-cluster.csv
			echo -n ";" >> eks-cluster.csv
			echo -n $subrecurso >> eks-cluster.csv
			echo -n ";" >> eks-cluster.csv
			version=$(aws eks describe-cluster --name $subrecurso | jq '.cluster.version' | cut -d '"' -f 2)
			echo -n $version >> eks-cluster.csv
			echo -n ";" >> eks-cluster.csv
			endpoint=$(aws eks describe-cluster --name $subrecurso | jq '.cluster.endpoint' | cut -d '"' -f 2)
			echo -n $endpoint >> eks-cluster.csv
			echo -n ";" >> eks-cluster.csv
			vpcId=$(aws eks describe-cluster --name $subrecurso | jq '.cluster.resourcesVpcConfig.vpcId' | cut -d '"' -f 2)
			echo -n $vpcId >> eks-cluster.csv
			echo -n ";" >> eks-cluster.csv
			endpointPublicAccess=$(aws eks describe-cluster --name $subrecurso | jq '.cluster.resourcesVpcConfig.endpointPublicAccess' | cut -d '"' -f 2)
			echo -n $endpointPublicAccess >> eks-cluster.csv
			echo '' >> eks-cluster.csv
		elif [ "$recurso" == "nodegroup" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)			
			regiao=$(echo $geral | cut -d ':' -f 4)			
			echo -n $regiao >> eks-nodegroup.csv
			echo -n ";" >> eks-nodegroup.csv
			echo -n $subrecurso >> eks-nodegroup.csv
			echo -n ";" >> eks-nodegroup.csv
			nodegroup=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 3)
			echo -n $nodegroup >> eks-nodegroup.csv
			echo -n ";" >> eks-nodegroup.csv
			capacityType=$(aws eks describe-nodegroup --cluster-name  $subrecurso --nodegroup-name $nodegroup | jq '.nodegroup.capacityType' | cut -d '"' -f 2)
			echo -n $capacityType >> eks-nodegroup.csv
			echo -n ";" >> eks-nodegroup.csv
			instanceTypes=$(aws eks describe-nodegroup --cluster-name  $subrecurso --nodegroup-name $nodegroup | jq '.nodegroup.instanceTypes[]' | cut -d '"' -f 2)
			echo -n $instanceTypes >> eks-nodegroup.csv
			echo -n ";" >> eks-nodegroup.csv
			minSize=$(aws eks describe-nodegroup --cluster-name  $subrecurso --nodegroup-name $nodegroup | jq '.nodegroup.scalingConfig.minSize' | cut -d '"' -f 2)
			echo -n $minSize >> eks-nodegroup.csv
			echo -n ";" >> eks-nodegroup.csv
			maxSize=$(aws eks describe-nodegroup --cluster-name  $subrecurso --nodegroup-name $nodegroup | jq '.nodegroup.scalingConfig.maxSize' | cut -d '"' -f 2)
			echo -n $maxSize >> eks-nodegroup.csv
			echo -n ";" >> eks-nodegroup.csv
			desiredSize=$(aws eks describe-nodegroup --cluster-name  $subrecurso --nodegroup-name $nodegroup | jq '.nodegroup.scalingConfig.desiredSize' | cut -d '"' -f 2)
			echo -n $desiredSize >> eks-nodegroup.csv
			echo '' >> eks-nodegroup.csv
		else
			echo $geral
		fi
	elif [ "$servico" == "elasticbeanstalk" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		if [ "$recurso" == "application" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			regiao=$(echo $geral | cut -d ':' -f 4)			
			echo -n $regiao >> elasticbeanstalk.csv
			echo -n ";" >> elasticbeanstalk.csv
			echo -n $recurso >> elasticbeanstalk.csv
			echo -n ";" >> elasticbeanstalk.csv
			TierName=$(aws elasticbeanstalk describe-environments --application-name $subrecurso | jq '.Environments[].Tier.Name' | cut -d '/' -f 2)
			echo -n $TierName >> elasticbeanstalk.csv
			echo -n ";" >> elasticbeanstalk.csv
			TierType=$(aws elasticbeanstalk describe-environments --application-name $subrecurso | jq '.Environments[].Tier.Type' | cut -d '/' -f 2)
			echo -n $TierType >> elasticbeanstalk.csv
			SolutionStackName=$(aws elasticbeanstalk describe-environments --application-name $subrecurso | jq '.Environments[].SolutionStackName' | cut -d '/' -f 2)
			echo -n $SolutionStackName >> elasticbeanstalk.csv
			echo '' >> elasticbeanstalk.csv
		elif [ "$recurso" == "environment" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		else
			echo $geral
		fi
	elif [ "$servico" == "elasticache" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		if [ "$recurso" == "cluster" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
			regiao=$(echo $geral | cut -d ':' -f 4)						
			echo -n $regiao >> elasticache.csv
			echo -n ";" >> elasticache.csv
			ReplicationGroupId=$(aws elasticache describe-cache-clusters --cache-cluster-id $subrecurso | jq '.CacheClusters[].ReplicationGroupId' | cut -d '"' -f 2)
			echo -n $ReplicationGroupId >> elasticache.csv
			echo -n ";" >> elasticache.csv
			echo -n $subrecurso >> elasticache.csv
			echo -n ";" >> elasticache.csv
			CacheNodeType=$(aws elasticache describe-cache-clusters --cache-cluster-id $subrecurso | jq '.CacheClusters[].CacheNodeType' | cut -d '"' -f 2)
			echo -n $CacheNodeType >> elasticache.csv
			echo -n ";" >> elasticache.csv
			Engine=$(aws elasticache describe-cache-clusters --cache-cluster-id $subrecurso | jq '.CacheClusters[].Engine' | cut -d '"' -f 2)
			echo -n $Engine >> elasticache.csv
			echo -n ";" >> elasticache.csv
			EngineVersion=$(aws elasticache describe-cache-clusters --cache-cluster-id $subrecurso | jq '.CacheClusters[].EngineVersion' | cut -d '"' -f 2)
			echo -n $EngineVersion >> elasticache.csv
			echo -n ";" >> elasticache.csv
			SnapshotRetentionLimit=$(aws elasticache describe-cache-clusters --cache-cluster-id $subrecurso | jq '.CacheClusters[].SnapshotRetentionLimit' | cut -d '"' -f 2)
			echo -n $SnapshotRetentionLimit >> elasticache.csv
			echo '' >> elasticache.csv
		elif [ "$recurso" == "replicationgroup" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
			regiao=$(echo $geral | cut -d ':' -f 4)	
		elif [ "$recurso" == "snapshot" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
			regiao=$(echo $geral | cut -d ':' -f 4)	
			echo -n $regiao >> elasticache-snapshot.csv
			echo -n ";" >> elasticache-snapshot.csv
			CacheClusterId=$(aws elasticache describe-snapshots --snapshot-name $subrecurso | jq '.Snapshots[].CacheClusterId' | cut -d '"' -f 2)
			echo -n $CacheClusterId >> elasticache-snapshot.csv
			echo -n ";" >> elasticache-snapshot.csv
			echo -n $subrecurso >> elasticache-snapshot.csv
			echo -n ";" >> elasticache-snapshot.csv
			CacheSize=$(aws elasticache describe-snapshots --snapshot-name $subrecurso | jq '.Snapshots[].NodeSnapshots[].CacheSize' | cut -d '"' -f 2)
			echo -n $CacheSize >> elasticache-snapshot.csv
			echo -n ";" >> elasticache-snapshot.csv
			SnapshotCreateTime=$(aws elasticache describe-snapshots --snapshot-name $subrecurso | jq '.Snapshots[].NodeSnapshots[].SnapshotCreateTime' | cut -d '"' -f 2 | cut -d 'T' -f 1)
			echo -n $SnapshotCreateTime >> elasticache-snapshot.csv
			echo '' >> elasticache-snapshot.csv
		else
			echo $geral
		fi
	elif [ "$servico" == "elasticloadbalancing" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 1)
		if [ "$recurso" == "listener-rule" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
		elif [ "$recurso" == "listener" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
		elif [ "$recurso" == "loadbalancer" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
			if [ "$subrecurso" != "app" ]; then
				regiao=$(echo $geral | cut -d ':' -f 4)
				echo -n $regiao >> elb.csv
				echo -n ";" >> elb.csv
				echo -n $subrecurso >> elb.csv
				echo -n ";" >> elb.csv
				DNSName=$(aws elb describe-load-balancers --load-balancer-names $subrecurso | jq .'LoadBalancerDescriptions[].DNSName' | cut -d '"' -f 2)
				echo -n $DNSName >> elb.csv
				echo -n ";" >> elb.csv
				VPCId=$(aws elb describe-load-balancers --load-balancer-names $subrecurso | jq .'LoadBalancerDescriptions[].VPCId' | cut -d '"' -f 2)
				echo -n $VPCId >> elb.csv
				echo -n ";" >> elb.csv
				Scheme=$(aws elb describe-load-balancers --load-balancer-names $subrecurso | jq .'LoadBalancerDescriptions[].Scheme' | cut -d '"' -f 2)
				echo -n $Scheme >> elb.csv
				echo -n ";" >> elb.csv
				echo -n "Classic" >> elb.csv
				echo '' >> elb.csv
			elif [ "$subrecurso" == "app" ]; then
				regiao=$(echo $geral | cut -d ':' -f 4)
				subrecurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 3)
				echo -n $regiao >> elbv2.csv
				echo -n ";" >> elbv2.csv
				echo -n $subrecurso >> elbv2.csv
				echo -n ";" >> elbv2.csv
				DNSName=$(aws elbv2 describe-load-balancers --names $subrecurso | jq '.LoadBalancers[].DNSName' | cut -d '"' -f 2)
				echo -n $DNSName >> elbv2.csv
				echo -n ";" >> elbv2.csv
				VpcId=$(aws elbv2 describe-load-balancers --names $subrecurso | jq '.LoadBalancers[].VpcId' | cut -d '"' -f 2)
				echo -n $VpcId >> elbv2.csv
				echo -n ";" >> elbv2.csv
				Scheme=$(aws elbv2 describe-load-balancers --names $subrecurso | jq '.LoadBalancers[].Scheme' | cut -d '"' -f 2)
				echo -n $Scheme >> elbv2.csv
				echo -n ";" >> elbv2.csv
				Type=$(aws elbv2 describe-load-balancers --names $subrecurso | jq '.LoadBalancers[].Type' | cut -d '"' -f 2)
				echo -n $Type >> elbv2.csv
				echo '' >> elbv2.csv
			else
				echo $geral
			fi
		elif [ "$recurso" == "targetgroup" ]; then
			subrecurso=$(echo $geral | cut -d ':' -f 7)
			regiao=$(echo $geral | cut -d ':' -f 4)
		else
			echo $geral
		fi
	elif [ "$servico" == "events" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
	elif [ "$servico" == "lambda" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 7)
		regiao=$(echo $geral | cut -d ':' -f 4)
		echo -n $regiao >> lambda.csv
		echo -n ";" >> lambda.csv
		echo -n $recurso >> lambda.csv
		echo -n ";" >> lambda.csv
		Runtime=$(aws lambda get-function --function-name $recurso | jq '.Configuration.Runtime' | cut -d '"' -f 2)
		echo -n $Runtime >> lambda.csv
		echo -n ";" >> lambda.csv
		CodeSize=$(aws lambda get-function --function-name $recurso | jq '.Configuration.CodeSize' | cut -d '"' -f 2)
		echo -n $CodeSize >> lambda.csv
		echo -n ";" >> lambda.csv
		MemorySize=$(aws lambda get-function --function-name $recurso | jq '.Configuration.MemorySize' | cut -d '"' -f 2)
		echo -n $MemorySize >> lambda.csv
		echo -n ";" >> lambda.csv
		VpcId=$(aws lambda get-function --function-name $recurso | jq '.Configuration.VpcConfig.VpcId' | cut -d '"' -f 2)
		echo -n $VpcId >> lambda.csv
		echo -n ";" >> lambda.csv
		Architectures=$(aws lambda get-function --function-name $recurso | jq '.Configuration.Architectures[]' | cut -d '"' -f 2)
		echo -n $Architectures >> lambda.csv
		echo -n ";" >> lambda.csv
		EphemeralStorage=$(aws lambda get-function --function-name $recurso | jq '.Configuration.EphemeralStorage.Size' | cut -d '"' -f 2)
		echo -n $EphemeralStorage >> lambda.csv
		echo '' >> lambda.csv
	elif [ "$servico" == "ssm" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
	elif [ "$servico" == "s3" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6)
		regiao=$(aws s3api get-bucket-location --bucket $recurso | jq '.LocationConstraint' | cut -d '"' -f 2)
		echo -n $regiao >> s3.csv
		echo -n ";" >> s3.csv
		echo -n $recurso >> s3.csv
		echo -n ";" >> s3.csv
		Objects=$(aws s3 ls $recurso --recursive --human-readable --summarize | tail -2 | head -1 | cut -d ':' -f 2)
		echo -n $Objects >> s3.csv
		echo -n ";" >> s3.csv
		Size=$(aws s3 ls $recurso --recursive --human-readable --summarize | tail -1 | cut -d ':' -f 2)
		echo -n $Size >> s3.csv
		echo '' >> s3.csv
	elif [ "$servico" == "secretsmanager" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
	elif [ "$servico" == "acm" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		regiao=$(echo $geral | cut -d ':' -f 4)
		echo -n $regiao >> acm.csv
		echo -n ";" >> acm.csv
		DomainName=$(aws acm describe-certificate --certificate-arn $geral | jq '.Certificate.DomainName' | cut -d '"' -f 2)
		echo -n $DomainName >> acm.csv
		echo -n ";" >> acm.csv
		Status=$(aws acm describe-certificate --certificate-arn $geral | jq '.Certificate.Status' | cut -d '"' -f 2)
		echo -n $Status >> acm.csv
		echo -n ";" >> acm.csv
		NotAfter=$(aws acm describe-certificate --certificate-arn $geral | jq '.Certificate.NotAfter' | cut -d '"' -f 2 | cut -d "T" -f 1)
		echo -n $NotAfter >> acm.csv
		echo -n ";" >> acm.csv
		Type=$(aws acm describe-certificate --certificate-arn $geral | jq '.Certificate.Type' | cut -d '"' -f 2)
		echo -n $Type >> acm.csv
		echo '' >> acm.csv
	elif [ "$servico" == "ecr" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
		regiao=$(echo $geral | cut -d ':' -f 4)
		echo -n $regiao >> ecr.csv
		echo -n ";" >> ecr.csv
		echo -n $recurso >> ecr.csv
		echo -n ";" >> ecr.csv
		registryId=$(aws ecr describe-repositories --repository-name $recurso | jq '.repositories[].registryId' | cut -d '"' -f 2)
		echo -n $registryId >> ecr.csv
		echo -n ";" >> ecr.csv
		imageTagMutability=$(aws ecr describe-repositories --repository-name $recurso | jq '.repositories[].imageTagMutability' | cut -d '"' -f 2)
		echo -n $imageTagMutability >> ecr.csv
		echo -n ";" >> ecr.csv
		echo '' >> ecr.csv
	elif [ "$servico" == "config" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
	elif [ "$servico" == "dms" ]; then		
		recurso=$(echo $geral | cut -d ':' -f 6 | cut -d '/' -f 2)
	else
		echo $geral
	fi
done