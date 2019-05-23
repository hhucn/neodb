#!/usr/bin/env bash
echo ":param db_uri => 'jdbc:postgresql://${DB_HOST}/${DB_NAME}?user=${DB_USER}&password=${DB_PW}';"
echo ":param db_skeleton => 'SELECT arguments.uid as argument, arguments.is_supportive as support, arguments.conclusion_uid as conclusion_statement, arguments.argument_uid as conclusion_argument, premises.statement_uid as premise, arguments.issue_uid as issue, statements.is_position FROM arguments JOIN premises ON arguments.premisegroup_uid = premises.premisegroup_uid LEFT JOIN statements ON statements.uid = arguments.conclusion_uid';"
echo ":param textversion_table => 'textversions';"
echo ":param issues_table => 'issues';"
