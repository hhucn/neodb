#!/usr/bin/env bash
: '
    This script changes the default password of the default user. Then the database is loaded and initialized.
'

set -e

function wait_for_port() {
    : '
        This function waits 60 seconds to determine whether a port on a host has been opened and activated on a host.
        The function receives as parameters the host and the port to be checked.
    '
    echo "$(date "+%Y-%m-%d %T") INFO": "Start waiting to open port $2 at $1..."
    end="$((SECONDS+60))"
    while true; do
        nc -w 2 $1 $2 && break
        [[ "${SECONDS}" -ge "${end}" ]] && exit 1
        sleep 1
    done
    echo "$(date "+%Y-%m-%d %T") INFO": "Port $2 is up and running after ${SECONDS} seconds at $1..."
}


function seed_database {
	: '
		This function concatenates all file which are required while seeding the Neo4J database.
		This is also done, because otherwise ENV-Vars can not be passed to cypher-queries.

		After everything is concatenated the whole database is seeded.
	'
	if [[ -f /var/lib/neo4j/entrypoint/.tmp ]] ; then
      rm /var/lib/neo4j/entrypoint/.tmp
	fi
	bash /var/lib/neo4j/entrypoint/entrypoint_parameters.sh > /var/lib/neo4j/entrypoint/.tmp
	echo  $(</var/lib/neo4j/entrypoint/neo4j-entrypoint.cql) >> /var/lib/neo4j/entrypoint/.tmp
	if [ -z "$NEO4J_USERNAME" ] && [ -z "$NEO4J_PASSWORD" ] ;
	  then bin/cypher-shell --fail-fast --debug --format verbose < /var/lib/neo4j/entrypoint/.tmp;
	  else bin/cypher-shell --fail-fast --debug --format verbose -u ${NEO4J_USERNAME} -p ${NEO4J_PASSWORD}  < /var/lib/neo4j/entrypoint/.tmp;
	fi
	rm /var/lib/neo4j/entrypoint/.tmp

}

function wait_for_neo {
    : '
        This function waits for the Neo4J server to start on port 7687 and the Neo4J browser to start on port 7474.
        Then the default password of the user "neo4j" will be changed.
        This password is then the new and valid password. The password is changed via the HTTP REST API provided by Neo4J.
        Then the database is initialized.
    '

    wait_for_port localhost 7687
    wait_for_port localhost 7474
    wait_for_port ${DB_HOST} ${DB_PORT}
    if [ -z "$NEO4J_USERNAME" ] && [ -z "$NEO4J_PASSWORD" ] ;
    then echo "$(date "+%Y-%m-%d %T") INFO": "No authentication is required!";
    else
      echo "$(date "+%Y-%m-%d %T") INFO": "Change the default authentication of ${NEO4J_USERNAME}..."
      : '
          Attention. Since this script only overwrites the password of the default user when loading the Neo4j container,
          the name of the default user for the default password is used as the second argument.
          Therefore, the default user name should still be used.
      '
      bash /var/lib/neo4j/entrypoint/hide_default_password.sh ${NEO4J_USERNAME} ${NEO4J_USERNAME} ${NEO4J_PASSWORD} 2>/dev/null;
    fi
    echo "$(date "+%Y-%m-%d %T") INFO": "Inject data to database..."
    : '
        This section loads the basic discussion graphs.
    '
		seed_database
    echo "$(date "+%Y-%m-%d %T") INFO": "-> Everything is up and running ..."

}

# Start to wait
wait_for_neo &

# Start the entrypoint for neo4j
/sbin/tini -g -s -- /docker-entrypoint.sh neo4j
