:param db_skeleton => "SELECT arguments.uid as argument, arguments.is_supportive as support, arguments.conclusion_uid as conclusion_statement, arguments.argument_uid as conclusion_argument, premises.statement_uid as premise, arguments.issue_uid as issue, statements.is_position FROM arguments JOIN premises ON arguments.premisegroup_uid = premises.premisegroup_uid LEFT JOIN statements ON statements.uid = arguments.conclusion_uid";
:param db_uri => "jdbc:postgresql://db/discussion?user=postgres&password=FooBar";

CREATE INDEX ON :Statement(id);
CREATE INDEX ON :Argument(id);
CREATE INDEX ON :Issue(id);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row
WITH DISTINCT row["issue"] AS issues, row
MERGE (:Issue{id:issues})
MERGE (:Argument{id: row["argument"], support: row["support"]})
MERGE (:Statement{id: row["premise"]})
WITH row
WHERE exists(row["is_position"]) and row["is_position"]
MERGE (:Statement:Position{id: row["conclusion_statement"]})
WITH row
WHERE exists(row["conclusion_statement"]) and (not exists(row["is_position"]) or not row["is_position"])
MERGE (:Statement{id: row["conclusion_statement"]});

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row
MATCH (sp:Statement:Position{id: row["conclusion_statement"]}), (i:Issue{id: row["issue"]})
WHERE exists(row["is_position"]) and row["is_position"]
MERGE (sp)-[:REGARDING]->(i);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row
MATCH (s:Statement{id: row.premise}), (a:Argument{id: row.argument})
MERGE (s)-[:PREMISE_OF]->(a);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row
MATCH (a:Argument{id: row.argument}), (c:Statement{id: row.conclusion_statement})
WHERE EXISTS(row.conclusion_statement)
MERGE (a)-[:CONCLUDES]->(c);

CALL apoc.load.jdbc($db_uri, $db_skeleton)
YIELD row
MATCH (a:Argument{id: row.argument}), (c:Argument{id: row.conclusion_argument})
WHERE NOT EXISTS(row.conclusion_statement)
MERGE (a)-[:CONCLUDES]->(c);