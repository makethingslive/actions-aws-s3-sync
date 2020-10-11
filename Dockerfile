FROM python:3.9-alpine

LABEL mantainer="makethingslive@gmail.com"

RUN apk add --upgrade --verbose --no-cache \
    groff \
    less \
    jq

RUN pip install --no-cache-dir awscli

WORKDIR /workdir

COPY entrypoint.sh /workdir/entrypoint.sh

ENTRYPOINT [ "sh", "/workdir/entrypoint.sh" ]
