FROM neo4j:3.5.0

ENV POSTGRES_VERSION 42.2.5
ENV APOC_VERSION 3.5.0.1
ENV ALGO_VERSION 3.5.4.0

MAINTAINER marc.feger@uni-duesseldorf.de

RUN apk add --no-cache curl jq

RUN wget https://jdbc.postgresql.org/download/postgresql-${POSTGRES_VERSION}.jar -P /var/lib/neo4j/plugins && \
		wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/${APOC_VERSION}/apoc-${APOC_VERSION}-all.jar -P /var/lib/neo4j/plugins && \
		wget https://github.com/neo4j-contrib/neo4j-graph-algorithms/releases/download/${ALGO_VERSION}/graph-algorithms-algo-${ALGO_VERSION}.jar -P /var/lib/neo4j/plugins && \
		chmod +x /var/lib/neo4j/plugins/*.jar

COPY /neo4j /var/lib/neo4j

ENTRYPOINT ["bash", "/var/lib/neo4j/entrypoint/entrypoint.sh"]