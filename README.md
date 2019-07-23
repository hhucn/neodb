# NeoDB

Neo4J is a graph database (GDB) with its own query language [Cypher](https://neo4j.com/developer/cypher-query-language/).
With Neo4J it is possible to display and record data quickly and efficiently in the form of a graph.

## Environment variables for development
In order for NeoDB to work properly and interact with D-BAS, some environment variables must be set in advance.
These environment variables must be specified in the `.env`. In total, the following variables must be included.

| Variable        | Use                                         | Value      |
| --------------- |:-------------------------------------------:|:----------:|
| NEO4J_USER      | Name of the Neo4J user                      | neo4j      |
| NEO4J_PW        | Password for the Neo4J user                 | choose one |
| DB_PW           | D-BAS DB Password                           | See D-BAS  |
| DB_HOST         | The name of the D-BAS DB service            | See D-BAS  |
| DB_NAME         | Name of D-BAS DB                            | See D-BAS  |
| DB_PORT         | Port of D-BAS DB                            | See D-BAS  |
| DB_USER         | User of D-BAS DB                            | See D-BAS  |

## Environment variables for production
The file with the environment variables for production should be named: `.production.env`.
It is important for `NEO4J_AUTH` that `NEO4J_USERNAME` and `NEO4J_PASSWORD` are separated with a `/`.

| Variable        | Use                                         | Value                        |
| --------------- |:-------------------------------------------:|:----------------------------:|
| NEO4J_USERNAME  | Name of the Neo4J user                      | neo4j                        |
| NEO4J_PASSWORD  | Password for the Neo4J user                 | choose one                   |
| NEO4J_AUTH      | Authentication for the User                 | NEO4J_USERNAME/NEO4J_PASSWORD|
| DB_PW           | D-BAS DB Password of the live version       | See D-BAS live version       |
| DB_HOST         | The name of the D-BAS DB service            | See D-BAS live version       |
| DB_NAME         | Name of D-BAS DB                            | See D-BAS live version       |
| DB_PORT         | Port of D-BAS DB                            | See D-BAS live version       |
| DB_USER         | User of D-BAS DB                            | See D-BAS live version       |

## Configuration
The initial configuration can be found in the conf folder inside neo4j.conf.

The configuration is not bound as a volume, because old configuration values are transferred each time the system is started. This can cause some problems, see also: <https://community.neo4j.com/t/cannot-edit-neo4j-conf/643/3>
So the image has to be rebuilt every time the configurations are changed.

All basic configurations are stored in neo4j.conf. Additionally some additional configurations are added. These include:

| Configuration                              | Use                                                                 | Value                                                       |
|--------------------------------------------|:-------------------------------------------------------------------:|:-----------------------------------------------------------:|
| browser.post_connect_cmd                   | Command to start a specific browser-guide while entering the browser| :play https://s3.cs.uni-duesseldorf.de/neo4j/hello_dbas.html|
| browser.remote_content_hostname_whitelist  | Allow :play to fetch data from every kind of URI                    | *                                                           |
| dbms.security.procedures.unrestricted      | Enable external procedures                                          | algo.\*, apoc.\*                                            |

## Run NeoDB
Run the following command:

	$ docker-compose up

To build, run the following command:

	$ docker-compose up --build

## Current status
Currently NeoDB contains only the discussion graphs consisting of the main components: `Issue`, `Argument`, `Statement` and `Position`.
These are connected by the edges `CONCLUDES`, `PREMISE_OF` and `REGARDING` and indicate exactly the discussion graphs.

## Usage
NeoDB can be accessed from any client. 
The common client for a Python application is the [Neo4j Python Driver](https://neo4j.com/developer/python/).

## Maintainer
* [Marc Feger](https://gitlab.cs.uni-duesseldorf.de/profile?nav_source=navbar)