CREATE EXTENSION fhir_jsonb;
CREATE EXTENSION jsquery;
set escape_string_warning=off;

select count(*)
from patients;

select count(*)
from encounters;

select count(*)
from observations;

SELECT DISTINCT ON (doc #>> '{status}')
doc #>> '{status}'
FROM observations
ORDER BY doc #>> '{status}';
