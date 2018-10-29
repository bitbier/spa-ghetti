#!/usr/bin/env bash

pushd .

cd terraform/module
BUCKET_NAME=$(terraform output bucket_name)
CLOUDFRONT_ID=$(terraform output cloudfront_id)
CLOUDFRONT_DOMAIN=$(terraform output cloudfront_domain)

popd

aws s3 sync ./app s3://${BUCKET_NAME} --delete

aws cloudfront create-invalidation \
    --paths "/*" \
    --distribution-id $CLOUDFRONT_ID

echo "=> Deployed to ${CLOUDFRONT_DOMAIN}"
