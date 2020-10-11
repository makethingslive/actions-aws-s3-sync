FROM python:3.9-alpine

LABEL mantainer="makethingslive@gmail.com"
ENV AWSCLI_VERSION='1.18.157'

RUN apk add --upgrade --verbose --no-cache \
    groff \
    less \
    jq

RUN pip install --no-cache-dir awscli==${AWSCLI_VERSION}

WORKDIR /workdir

COPY entrypoint.sh /workdir/entrypoint.sh

ENTRYPOINT [ "sh", "/workdir/entrypoint.sh" ]
