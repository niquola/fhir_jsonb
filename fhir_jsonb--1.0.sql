-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION fhir_jsonb" to load this file. \quit

DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS encounters;
DROP TABLE IF EXISTS observations;

CREATE TABLE patients (
  id SERIAL primary key,
  doc jsonb
);

CREATE TABLE encounters (
  id SERIAL primary key,
  doc jsonb
);

CREATE TABLE observations (
  id SERIAL primary key,
  doc jsonb
);

insert into patients (doc)
select '{}'::jsonb
from generate_series(1, 100) n;

DO $$
DECLARE template varchar;
BEGIN
    SELECT '{"resourceType": "Encounter", "text": {"status": "generated", "div": "text"}, "identifier": [{"use": "temp", "value": "{{.i}}"}], "status": "{{.status}}", "class": "{{.class}}", "type": [{"coding": [{"system": "http://snomed.info/sct", "code": "183807002", "display": "Inpatient stay for nine days"}]}], "subject": {"reference": "Patient{{.i}}", "display": "Roel"}, "participant": [{"individual": {"type": [{"coding": [{"system": "encounter-participant-type", "code": "{{.part_type}}"}]}], "reference": "{{.phys}}"}}], "reason": {"text": "{{.reason}}"}, "priority": {"coding": [{"system": "http://snomed.info/sct", "code": "394849002", "display": "High priority"}]}, "hospitalization": {"admitSource": {"coding": [{"system": "http://snomed.info/sct", "code": "309902002", "display": "Clinical Oncology Department"}]}, "period": {"start": "{{.start_time}}", "end": "{{.end_time}}"}, "diet": {"coding": [{"system": "http://snomed.info/sct", "code": "276026009", "display": "Fluid balance regulation"}]}, "reAdmission": false}, "serviceProvider": {"reference": "Organization/f201"}}'
    INTO template;

    INSERT INTO encounters (doc)
    SELECT CAST (regexp_replace(template, '{{\.i}}', n::varchar) AS jsonb)
    FROM generate_series(1, 1000) n;
END $$;




insert into observations (doc)
select '{}'::jsonb
from generate_series(1, 10000) n;
