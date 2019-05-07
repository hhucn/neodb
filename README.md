# NeoDB

Neo4J is a graph database (GDB) with its own query language [Cypher](https://neo4j.com/developer/cypher-query-language/).
With Neo4J it is possible to display and record data quickly and efficiently in the form of a graph.

## Environment variables
In order for NeoDB to work properly and interact with D-BAS, some environment variables must be set in advance.
These environment variables must be specified in the `.env`. In total, the following variables must be included.

| Variable        | Use                                         | Value      |
| --------------- |:-------------------------------------------:|:----------:|
| NEO4J_PORT      | Port used by Cypher-Shell                   | 7687       |
| NEO4J_PROTOCOL  | The protocol used by Neo4J                  | bolt       |
| NEO4J_HOST      | The name of the service                     | neo        |
| NEO4J_USER      | Name of the Neo4J user                      | neo4j      |
| NEO4J_PW        | Password for the Neo4J user                 | choose one |
| DB_PW           | D-BAS DB Password                           | See D-BAS  |
| DB_HOST         | The name of the service D-BAS DB service    | See D-BAS  |
| DB_NAME         | Name of D-BAS DB                            | See D-BAS  |
| DB_PORT         | Port of D-BAS DB                            | See D-BAS  |
| DB_USER         | User of D-BAS DB                            | See D-BAS  |

## Attention!
Currently the password of `DB_PW` must not contain special characters like `?!%`.
Change the password `DB_PW` for both D-BAS and NeoDB.

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