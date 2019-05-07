FROM neo4j:3.5.0

MAINTAINER marc.feger@uni-duesseldorf.de

RUN apk add --no-cache curl jq

COPY . .

ENTRYPOINT ["bash", "/var/lib/neo4j/entrypoint/entrypoint.sh"]