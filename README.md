# NeoDB

Neo4J is a graph database (GDB) with its own query language [Cypher](https://neo4j.com/developer/cypher-query-language/).
With Neo4J it is possible to display and record data quickly and efficiently in a graph structure.

## Prerequisites :whale:

You need [Docker](https://www.docker.com/) to be installed at your machine to run this project.

## First run :baby:

If you have never used this project before, you can run the following command to set everything up from scratch:

    $ make all

This will initially create a new `docker image` of the project. 
Then you will be asked to follow the instructions for setting up the `.env`.
Once everything is set up, the service will start on its own.

## Run :runner:

If everything is set up properly, you can (re-)start a container by using:

    $ make run

## Run with new Environment-Variables :wrench: :construction_worker:

To run a fresh container with new `environment-variables` please use the following:

    $ make install

## Run NeoDB for development

NeoDB has a `Makefile` for simplicity. The commands are as follows:

| *Command*         | *Use*                                       | *Dependencies*               |
| ------------------|:-------------------------------------------:|:----------------------------:|
| clean_variables   | Delete `.env`                               |                              |
| new_variables     | Create `.env` with all necessary variables  | clean_variables              |
| build_image       | Build the `docker-image`                    |                              |
| run               | Runs Neo4J in a `docker-container`          |                              |
| install           | Create new `.env` and run new container     | new_variables, run           |
| all               | Does every of those steps above             | all above                    |

To do any of those steps run:

    $ make <Command>
    
> **Notice**: No authentication is required for the development mode. However, the `NEO4J_AUTH` field in `.env` is set to `none`.

## Environment variables for development

In order for NeoDB to work properly and interact with D-BAS, some environment variables must be set in advance.
These environment variables must be specified in the `.env` and can be installed with the installation script described above. In total, the following variables must be included.

| *Variable*        | *Use*                                         | *Value*                        |
| ----------------- |:---------------------------------------------:|:------------------------------:|
| DB_PW             | D-BAS DB Password of the live version         | See D-BAS                      |
| DB_HOST           | The host of the D-BAS DB service              | See D-BAS                      |
| DB_NAME           | Name of D-BAS DB                              | See D-BAS                      |
| DB_PORT           | Port of D-BAS DB                              | See D-BAS                      |
| DB_USER           | User of D-BAS DB                              | See D-BAS                      |

## Using the real-time data from D-BAS

It is also possible to read the real-time data from D-BAS within the university network.

For this the data for the guest user must be requested.
Information about the guest user and the application for a guest password can be traced [here](https://dbas.cs.uni-duesseldorf.de/docs/dbas/database.html).

In addition, the database host `DB_HOST` must be changed to `dbas.cs.uni-duesseldorf.de` or `dbas.cs.hhu.de`. 

If all data concerning `DB_USER`, `DB_PW` and `DB_HOST` is available, it must be entered in `.env`.
To do this, run the following command and follow the instructions:

    $ make new_variables

After that Neo4J can be started via:

    $ make run

## Environment variables for production

The file with the environment variables for production should be named: `production.env`.
It is important for `NEO4J_AUTH` that `NEO4J_USERNAME` and `NEO4J_PASSWORD` are separated with a `/`.

| *Variable*        | *Use*                                         | *Value*                      |
| ----------------- |:---------------------------------------------:|:----------------------------:|
| NEO4J_USERNAME    | Name of the Neo4J user                        | neo4j                        |
| NEO4J_PASSWORD    | Password for the Neo4J user                   | choose one                   |
| NEO4J_AUTH        | Authentication for the User                   | NEO4J_USERNAME/NEO4J_PASSWORD|
| DB_PW             | D-BAS DB Password of the live version         | See D-BAS live version       |
| DB_HOST           | The name of the D-BAS DB service              | See D-BAS live version       |
| DB_NAME           | Name of D-BAS DB                              | See D-BAS live version       |
| DB_PORT           | Port of D-BAS DB                              | See D-BAS live version       |
| DB_USER           | User of D-BAS DB                              | See D-BAS live version       |

## Configuration

The initial configuration can be found in the conf folder inside `neo4j.conf`.

The configuration is not bound as a volume, because old configuration values are transferred each time the system is started. This can cause some problems, see also: <https://community.neo4j.com/t/cannot-edit-neo4j-conf/643/3>
So the image has to be rebuilt every time the configurations are changed.

All basic configurations are stored in neo4j.conf. Additionally some additional configurations are added. These include:

| *Configuration*                              | *Use*                                                                 | Value                                                     |
|----------------------------------------------|:-------------------------------------------------------------------:|:-----------------------------------------------------------:|
| browser.post_connect_cmd                     | Command to start a specific browser-guide while entering the browser| :play https://s3.cs.uni-duesseldorf.de/neo4j/hello_dbas.html|
| browser.remote_content_hostname_whitelist    | Allow :play to fetch data from every kind of URI                    | *                                                           |
| dbms.security.procedures.unrestricted        | Enable external procedures                                          | algo.\*, apoc.\*                                            |

## Run NeoDB with Docker :whale:

Run the following command:

	$ docker-compose up

To build, run the following command:

	$ docker-compose up --build

Docker is supposed to be used for `production`.

## Current status

Currently NeoDB contains only the discussion graphs consisting of the main components: `Issue`, `Argument`, `Statement` and `Position`.
These are connected by the edges `CONCLUDES`, `PREMISE_OF` and `REGARDING` and indicate exactly the discussion graphs.

## Usage

NeoDB can be accessed from any client. 
The common client for a Python application is the [Neo4j Python Driver](https://neo4j.com/developer/python/).

## Maintainer

* [Marc Feger](https://gitlab.cs.uni-duesseldorf.de/feger)