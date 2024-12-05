include .env

IMAGE_TAG=${IMAGE}:`git rev-parse --short HEAD`

.PHONY: requirements install-lib docker-build docker-test docker-run docker-install-lib httpfs-extension \
	aws-extension aws-ecr-publish aws-cli-validator

aws-cli-validator:
	@which aws > /dev/null || echo "AWS CLI NOT FOUND"

requirements:
	@pip freeze --exclude-editable > requirements.txt

install-lib:
	@pip install -e ../flock/

docker-install-lib:
	@rsync -ar --exclude='__pycache__' --exclude='*.egg-info' --exclude='.DS_Store' ../flock .
	@pip install -e flock/

docker-build: requirements docker-install-lib
	@docker build --platform linux/amd64 --build-arg RELEASE_VERSION_NUMBER=${RELEASE_VERSION_NUMBER} --build-arg PLATFORM_NAME=${PLATFORM_NAME} . -t ${IMAGE_TAG}
	@rm -r flock/

docker-run:
	@docker run --rm -p 9000:8080 \
		--platform linux/amd64 \
		-v ~/.aws-lambda-rie:/aws-lambda \
		--entrypoint /aws-lambda/aws-lambda-rie \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e AWS_SESSION_TOKEN \
		-e AWS_REGION \
		${IMAGE}:`git rev-parse --short HEAD` \
		/usr/local/bin/python -m awslambdaric ${LAMBDA_HANDLER_NAME}

docker-test:
	@curl -H "Content-Type: application/json" "http://localhost:9000/2015-03-31/functions/function/invocations" -d @tests/sql_query.json

aws-ecr-publish: aws-cli-validator docker-build
	@aws ecr get-login-password --region ${AWS_REGION} --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com && \
		docker tag ${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_NAME}:latest && \
		docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_NAME}:latest

httpfs-extension:
	@curl -s --create-dirs --output-dir extensions/ -O http://extensions.duckdb.org/v${release_version_number}/${platform_name}/httpfs.duckdb_extension.gz
	@gunzip extensions/httpfs.duckdb_extension.gz

aws-extension:
	@curl -s --create-dirs --output-dir extensions/ -O http://extensions.duckdb.org/v${release_version_number}/${platform_name}/aws.duckdb_extension.gz
	@gunzip extensions/aws.duckdb_extension.gz

update-lamdba: aws-ecr-publish
	@cd ../terraform/environment/dev/serverless-duckdb/lambda/ && \
		terragrunt apply