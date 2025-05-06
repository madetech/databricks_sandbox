export SANDBOX_TAG="sandbox-zeerak"  # Change to your resource prefix

# Delete NAT Gateways
aws ec2 describe-nat-gateways --filter "Name=tag:SandboxId,Values=$SANDBOX_TAG" \
  --query "NatGateways[*].NatGatewayId" --output text | \
  xargs -n 1 -I {} aws ec2 delete-nat-gateway --nat-gateway-id {}

# Wait a bit for the NAT Gateway to be removed
sleep 60

# Delete Network Interfaces
aws ec2 describe-network-interfaces --filters "Name=tag:SandboxId,Values=$SANDBOX_TAG" \
  --query 'NetworkInterfaces[*].NetworkInterfaceId' --output text | \
  xargs -n 1 -I {} aws ec2 delete-network-interface --network-interface-id {}

# Delete Subnets
aws ec2 describe-subnets --filters "Name=tag:SandboxId,Values=$SANDBOX_TAG" \
  --query 'Subnets[*].SubnetId' --output text | \
  xargs -n 1 -I {} aws ec2 delete-subnet --subnet-id {}

# Delete Elastic IPs
aws ec2 describe-addresses --filters "Name=tag:SandboxId,Values=$SANDBOX_TAG" \
  --query 'Addresses[*].AllocationId' --output text | \
  xargs -n 1 -I {} aws ec2 release-address --allocation-id {}

# Delete Security Groups
aws ec2 describe-security-groups --filters "Name=tag:SandboxId,Values=$SANDBOX_TAG" \
  --query 'SecurityGroups[*].GroupId' --output text | \
  xargs -n 1 -I {} aws ec2 delete-security-group --group-id {}
