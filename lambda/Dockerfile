ARG FUNCTION_DIR="/var/task"
ARG DUCKDB_EXTENSION_DIR="/tmp/.duckdb/extensions/$RELEASE_VERSION_NUMBER/$PLATFORM_NAME"

FROM python:3.11.7-bookworm as base_image

ARG FUNCTION_DIR
ARG DUCKDB_EXTENSION_DIR
RUN mkdir -p ${FUNCTION_DIR}

ARG RELEASE_VERSION_NUMBER
ARG PLATFORM_NAME

RUN curl -s --create-dir --output-dir ${DUCKDB_EXTENSION_DIR} -O "http://extensions.duckdb.org/v$RELEASE_VERSION_NUMBER/$PLATFORM_NAME/httpfs.duckdb_extension.gz"
RUN gzip -d ${DUCKDB_EXTENSION_DIR}/httpfs.duckdb_extension.gz

RUN curl -s --create-dir --output-dir ${DUCKDB_EXTENSION_DIR} -O "http://extensions.duckdb.org/v$RELEASE_VERSION_NUMBER/$PLATFORM_NAME/aws.duckdb_extension.gz"
RUN gzip -d ${DUCKDB_EXTENSION_DIR}/aws.duckdb_extension.gz

COPY flock ${FUNCTION_DIR}/flock
COPY requirements.txt ${FUNCTION_DIR}

RUN pip install --target ${FUNCTION_DIR} -r ${FUNCTION_DIR}/requirements.txt
RUN pip install --target ${FUNCTION_DIR} ${FUNCTION_DIR}/flock/

RUN pip install \
    --target ${FUNCTION_DIR} \
        awslambdaric

COPY mallard.py ${FUNCTION_DIR}

FROM python:3.11.7-slim-bookworm

ARG FUNCTION_DIR
ARG DUCKDB_EXTENSION_DIR

WORKDIR ${FUNCTION_DIR}
ENV HOME=/tmp

COPY --from=base_image ${FUNCTION_DIR} ${FUNCTION_DIR}
COPY --from=base_image ${DUCKDB_EXTENSION_DIR} ${DUCKDB_EXTENSION_DIR}

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

CMD [ "mallard.handler" ]
