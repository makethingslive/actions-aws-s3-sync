#!/bin/sh

aws --version

set -eo pipefail

# Validate
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "[ ERROR ] AWS_ACCESS_KEY_ID | not found"
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "[ ERROR ] AWS_SECRET_ACCESS_KEY | not found"
    exit 1
fi

if [ -z "$AWS_REGION" ]; then
    AWS_REGION="us-east-1"
    echo "[ WARNING ] AWS_REGION | not found. Setting to us-east-1"
fi

if [ -z "$AWS_OUTPUT" ]; then
    AWS_OUTPUT="text"
    echo "[ WARNING ] AWS_OUTPUT | not found. Setting to text"
fi

if [ -z "$AWS_S3_BUCKET" ]; then
    echo "[ ERROR ] AWS_S3_BUCKET | not found"
    exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
    LOCAL_PATH="."
    echo "[ WARNING ] SOURCE_DIR | not found. Setting to ./ "
fi

if [ $SOURCE_DIR ]; then
    LOCAL_PATH=${SOURCE_DIR}
fi

if [ -z "$DEST_DIR" ]; then
    AWS_S3_DEST_DIR=""
    echo "[ WARNING ] DEST_DIR | not found. Setting to / "
fi

if [ -n "$AWS_S3_ENDPOINT_URL" ]; then
    AWS_S3_ENDPOINT_ARG="--endpoint-url $AWS_S3_ENDPOINT_URL"
fi

# if [ -z "$AWS_S3_DELETE" ]; then
#     AWS_S3_DELETE="false"
# fi

# if [ $AWS_S3_DELETE = "true" ]; then
#     echo "[ WARNING ] Files that exist in the destination but not in the source will be deleted during sync."
#     AWS_S3_DELETE_ARG="--delete true"
# fi

# if [ -z "$AWS_S3_DRY_RUN" ]; then
#     AWS_S3_DRY_RUN="false"
# fi

# if [ $AWS_S3_DRY_RUN = "true" ]; then
#     echo "[ LOG ] Dry Run ..."
#     AWS_S3_DRY_RUN_ARG="--dryrun"
# fi

AWS_PROFILE="temp-profile"
AWS_S3_URI="s3://${AWS_S3_BUCKET}/${AWS_S3_DEST_DIR}"

#Configure
aws configure --profile $AWS_PROFILE <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
${AWS_OUTPUT}
EOF

#Sync
sh -c "aws s3 sync ${LOCAL_PATH} ${AWS_S3_URI} \
        --profile ${AWS_PROFILE} \
        --only-show-errors \
${AWS_S3_ENDPOINT_ARG} $*"


#Clean
aws configure --profile $AWS_PROFILE <<-EOF > /dev/null 2>&1
null
null
null
text
EOF
