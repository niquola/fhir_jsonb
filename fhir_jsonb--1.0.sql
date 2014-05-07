-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION fhir_jsonb" to load this file. \quit

CREATE FUNCTION encounter_random_status()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['planned','in progress','onleave','finished','cancelled'];
BEGIN
  RETURN a[floor((random()*5))::int];
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_class()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['emergency','inpatient'];
BEGIN
  RETURN a[floor((random()*2))::int];
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_part_type()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['ADM','ATND','CALLBCK','CON','DIS','ESC','REF'];
BEGIN
  RETURN a[floor((random()*7))::int];
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_phys()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['Charles R. Drew','Helen Flanders Dunbar','Galen','Ian Olver','Garcia de Orta','Christiaan Eijkman','Pierre Fauchard','Rene Geronimo Favaloro','Alexander Fleming','Girolamo Fracastoro','Sigmund Freud','Daniel Carleton Gajdusek','Henry Gray','George E. Goodfellow','William Harvey','Ernst Haeckel','Henry Heimlich','Orvan Hess','John Hunter','Hippocrates','Elliott P. Joslin','Edward Jenner'];
BEGIN
  RETURN a[floor((random()*22))::int];
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_reason()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['f asdfsd fasdfsad fdasfklsdjaflksda fjsdafjasdklf jsdklfj','fdaff asdf asdfasdf sdaf asdfsd fasdfsad fdasfk','lsdjaflksda fjsdafjasdklf jsdklfj'];
BEGIN
  RETURN a[floor((random()*3))::int];
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_start_time()
  RETURNS varchar AS
$func$
BEGIN
  RETURN CAST(now() - '1 year'::interval * random() AS date);
END
$func$ LANGUAGE plpgsql VOLATILE;

-- TODO: End time be greater than start time.
CREATE FUNCTION encounter_random_end_time()
  RETURNS varchar AS
$func$
BEGIN
  RETURN CAST(now() - '1 year'::interval * random() AS date);
END
$func$ LANGUAGE plpgsql VOLATILE;

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
  SELECT
    CAST (
      regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                regexp_replace(
                  regexp_replace(
                    regexp_replace(template, '{{\.i}}', n::varchar),
                    '{{\.status}}',
                    encounter_random_status()
                  ),
                  '{{.class}}',
                  encounter_random_class()
                ),
                '{{.part_type}}',
                encounter_random_part_type()
              ),
              '{{.phys}}',
              encounter_random_phys()
            ),
            '{{.reason}}',
            encounter_random_reason()
          ),
          '{{\.start_time}}',
          encounter_random_start_time()
        ),
        '{{\.end_time}}',
        encounter_random_end_time()
      )
      AS jsonb
    )
  FROM generate_series(1, 1000) n;
END $$;

insert into observations (doc)
select '{}'::jsonb
from generate_series(1, 10000) n;
