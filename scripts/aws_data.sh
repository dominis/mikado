#!/bin/bash
set -e

source ./mikado.conf

# we need to query aws api for the available azs in the region and feed it to tf
az_count=$( \
    aws ec2 describe-availability-zones \
        --region ${TF_VAR_region} \
        --filter "Name=state,Values=available" | \
    jq .AvailabilityZones[].ZoneName | \
    wc -l
)

# Get the ami id for the latest amazon linux in your region
source_ami=$( \
    aws \
        ec2 describe-images \
        --region ${TF_VAR_region} \
        --filters "Name=name,Values=amzn-ami-hvm-2016.09.0.20161028-x86_64-gp2" \
        --query "Images[0].ImageId" | \
    sed 's/\"//g'
)

# get the id of the mikado vpc from your local state
vpc_id=$( \
    cat terraform.tfstate | \
    jq \
        '.modules[].resources[] |
        select(.type == "aws_vpc") |
        select(.primary.attributes["tags.Name"] == "mikado") |
        .primary.id' | \
    sed 's/\"//g'
)

# get one public subnet id from your local state
subnet_id=$( \
    cat terraform.tfstate | \
    jq \
        '.modules[].outputs |
        select(keys[] == "public_subnets") |
        .public_subnets.value[0]' | \
    head -1 | \
    sed 's/\"//g'
)

# get the efs filesystem id from the local state
efs_filesysyem_id=$( \
    cat terraform.tfstate | \
    jq \
        '.modules[].outputs |
        select(keys[] == "efs_filesysyem_id") |
        .efs_filesysyem_id.value' | \
    head -1 | \
    sed 's/\"//g'
)

# print out the result in makefile format
echo "export source_ami=${source_ami}"
echo "export vpc_id=${vpc_id}"
echo "export subnet_id=${subnet_id}"
echo "export efs_filesysyem_id=${efs_filesysyem_id}"
echo "export TF_VAR_az_count=${az_count}"
