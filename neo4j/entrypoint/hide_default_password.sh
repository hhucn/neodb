#!/usr/bin/env bash

: '
    USER:
        This variable contains the name of the user whose initial password is to be changed.
        Attention: At the beginning the user and the password are set to "neo4j" by default.
        If the default user is still used, a new password should be created for this user.
'
USER=$1
if [[ -z ${USER} ]];
then
    echo "$(date "+%Y-%m-%d %T") ERROR": "-> The variable USER is not set!" 1>&2
    exit 1
fi

: '
    OLD_PASSWORD:
        This variable contains initial password which is to be changed.
        Attention: At the beginning the user and the password are set to "neo4j" by default.
        If the default user is still used, a new password should be created for this user.
'

OLD_PASSWORD=$2
if [[ -z ${OLD_PASSWORD} ]];
then
    echo "$(date "+%Y-%m-%d %T") ERROR": "-> The variable OLD_PASSWORD is not set!" 1>&2
    exit 1
fi

: '
    NEW_PASSWORD:
        This variable contains the new password.
'
NEW_PASSWORD=$3
if [[ -z ${NEW_PASSWORD} ]];
then
    echo "$(date "+%Y-%m-%d %T") ERROR": "-> The variable NEW_PASSWORD is not set!" 1>&2
    exit 1
fi

: '
    This variable contains the response of the Neo4J server to a specific user.
'
USER_STATUS=$(curl -u ${USER}:${OLD_PASSWORD} http://localhost:7474/user/${USER} 2>/dev/null)

: '
    This variable stores the status of whether the password needs to be changed.
    Since only the default password has to be changed at the beginning, the field "password_change_required"
    is set and true or false. If a non-existent user or password is requested,
    the field "password_change_required" is null.
    Then jq does not enter the variable PASSWORD_CHANGE_IS_REQUIRED.
    The value of PASSWORD_CHANGE_IS_REQUIRED is then empty.
'
PASSWORD_CHANGE_IS_REQUIRED=$(echo ${USER_STATUS} | jq -r '.password_change_required // empty')

if [[ ${PASSWORD_CHANGE_IS_REQUIRED} = true ]];
then
    echo "$(date "+%Y-%m-%d %T") INFO": "-> Call HTTP REST API with ${USER}:${OLD_PASSWORD} ..."
    # The new password is set here
    curl -H "Content-Type: application/json" \
         -d '{"password":"'"${NEW_PASSWORD}"'"}' \
         -u ${USER}:${OLD_PASSWORD} \
          http://localhost:7474/user/${USER}/password
    echo "$(date "+%Y-%m-%d %T") INFO": "--> Done."
else
    echo "$(date "+%Y-%m-%d %T") INFO": "-> Password for ${USER} is already set ..."
fi