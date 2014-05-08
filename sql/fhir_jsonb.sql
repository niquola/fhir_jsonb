CREATE EXTENSION fhir_jsonb;
CREATE EXTENSION jsquery;
set escape_string_warning=off;

select count(*)
from patients;

select count(*)
from encounters;

select count(*)
from observations;
