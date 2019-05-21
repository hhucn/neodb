:param db_uri => "jdbc:postgresql://db/discussion?user=postgres&password=FooBar";
:param db_skeleton => "SELECT arguments.uid as argument, arguments.is_supportive as support, arguments.conclusion_uid as conclusion_statement, arguments.argument_uid as conclusion_argument, premises.statement_uid as premise, arguments.issue_uid as issue, statements.is_position FROM arguments JOIN premises ON arguments.premisegroup_uid = premises.premisegroup_uid LEFT JOIN statements ON statements.uid = arguments.conclusion_uid";
:param textversion_table => "textversions";
:param issues_table => "issues";

CREATE INDEX ON :Statement(id);

CREATE INDEX ON :Argument(id);

CREATE INDEX ON :Issue(id);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row

WITH DISTINCT row['issue'] AS issues, row
MERGE (:Issue {id: issues})
MERGE (:Argument {id: row['argument'], support: row['support']})
MERGE (:Statement {id: row['premise']})
WITH row
  WHERE exists(row['is_position']) AND row['is_position']
MERGE (:Statement:Position {id: row['conclusion_statement']})
WITH row
  WHERE exists(row['conclusion_statement']) AND (NOT exists(row['is_position']) OR NOT row['is_position'])
MERGE (:Statement {id: row['conclusion_statement']});

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row

MATCH (sp:Statement:Position {id: row['conclusion_statement']}), (i:Issue {id: row['issue']})
  WHERE exists(row['is_position']) AND row['is_position']
MERGE (sp)-[:REGARDING]->(i);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row

MATCH (s:Statement {id: row.premise}), (a:Argument {id: row.argument})
MERGE (s)-[:PREMISE_OF]->(a);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row

MATCH (a:Argument {id: row.argument}), (c:Statement {id: row.conclusion_statement})
  WHERE exists(row.conclusion_statement)
MERGE (a)-[:CONCLUDES]->(c);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row

MATCH (a:Argument {id: row.argument}), (c:Argument {id: row.conclusion_argument})
  WHERE NOT exists(row.conclusion_statement)
MERGE (a)-[:CONCLUDES]->(c);

CALL apoc.load.jdbc($db_uri, $textversion_table)
YIELD row

MATCH (s:Statement {id: row['statement_uid']})
SET s.textversion = row['content'];

MATCH (a:Argument {support: true}), (b:Argument {support: false})
SET a:Support
SET b:Attack
REMOVE a.support, b.support;

CALL apoc.load.jdbc($db_uri, $issues_table)
YIELD row

MATCH (i:Issue {id: row['uid']})
SET i.title = row['title'];