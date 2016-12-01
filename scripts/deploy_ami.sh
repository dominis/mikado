#!/bin/bash
set -e

source ./mikado.conf

if [ -z "$TF_VAR_region" ]; then
    echo "Please run make deploy-ami instead."
    exit 1
fi

latest_ami_id=$( \
    aws \
        ec2 describe-images \
        --region ${TF_VAR_region} \
        --owners self \
        --filters \
            "Name=state,Values=available" \
            "Name=tag-key,Values=Domain" \
            "Name=tag-value,Values=${domain}" \
        --query \
            "Images[0].ImageId" | \
    sed 's/\"//g'
)

tast_asg_ami_id=$( \
    cat terraform.tfstate | \
    jq \
        '.modules[].resources[] |
        select(.type == "aws_launch_configuration") |
        .primary.attributes.image_id
    '
)

if [ "$latest_ami_id" != "$test_asg_ami_id" ] && [ ! -z "$test_asg_ami_id" ]; then
    echo "Please deploy your AMI first to your test instance"
    exit 1
fi

utc_date=$(date --utc +%Y-%m-%d_-_%H-%M)

res=$(aws \
    ec2 create-tags \
    --region ${TF_VAR_region} \
    --resources ${latest_ami_id} \
    --tags \
        Key=Production,Value=True \
        Key=deployed_at,Value=${utc_date}
)
