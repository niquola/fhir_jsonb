CREATE EXTENSION fhir_jsonb;
CREATE EXTENSION jsquery;
SET escape_string_warning=off;

SELECT count(*)
FROM patients;

SELECT DISTINCT ON (doc #>> '{active}')
doc #>> '{active}'
FROM patients
ORDER BY doc #>> '{active}';

SELECT count(*)
FROM encounters;

SELECT DISTINCT ON (doc #>> '{status}')
doc #>> '{status}'
FROM encounters
ORDER BY doc #>> '{status}';

SELECT DISTINCT ON (doc #>> '{class}')
doc #>> '{class}'
FROM encounters
ORDER BY doc #>> '{class}';

SELECT DISTINCT ON (doc #>> '{participant,0,individual,type}')
doc #>> '{participant,0,individual,type,0,coding,0,code}'
FROM encounters
ORDER BY doc #>> '{participant,0,individual,type}';

SELECT DISTINCT ON (doc #>> '{participant,0,individual,reference}')
doc #>> '{participant,0,individual,reference}'
FROM encounters
ORDER BY doc #>> '{participant,0,individual,reference}';

SELECT DISTINCT ON (doc #>> '{reason}')
doc #>> '{reason,text}'
FROM encounters
ORDER BY doc #>> '{reason}';

SELECT count(*)
FROM observations;

SELECT DISTINCT ON (doc #>> '{name}')
doc #>> '{name,coding,0,display}'
FROM observations
ORDER BY doc #>> '{name}';

SELECT DISTINCT ON (doc #>> '{status}')
doc #>> '{status}'
FROM observations
ORDER BY doc #>> '{status}';
