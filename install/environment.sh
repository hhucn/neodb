#!/bin/bash
ENV_FILE=".env"
function getVariables() {
  read -p "Database Host[db]" DB_HOST
  DB_HOST=${DB_HOST:-db}
  read -p "Database Name[discussion]: " DB_NAME
  DB_NAME=${DB_NAME:-discussion}
  read -p "Database Port[5432]: " DB_PORT
  DB_PORT=${DB_PORT:-5432}
  read -p "Database User[guest]: " DB_USER
  DB_USER=${DB_USER:-guest}
  read -p "Database Password[guest]: " DB_PW
  DB_PW=${DB_PW:-guest}

  echo "$DB_HOST $DB_NAME $DB_PORT $DB_USER $DB_PW"
  writeEnvFile "$DB_HOST" "$DB_NAME" "$DB_PORT" "$DB_USER" "$DB_PW"
}

function writeEnvFile() {
  {
    echo "# Neo4J core variables"
    echo "NEO4J_AUTH=none"
    echo "DB_HOST=$1"
    echo "DB_NAME=$2"
    echo "DB_PORT=$3"
    echo "DB_USER=$4"
    echo "DB_PW=$4"
  } >>$ENV_FILE
}
