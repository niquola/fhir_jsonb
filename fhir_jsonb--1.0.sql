-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION fhir_jsonb" to load this file. \quit

CREATE FUNCTION patient_random_is_active()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['true','false'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_status()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['planned','in progress','onleave','finished','cancelled'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_class()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['emergency','inpatient'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_part_type()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['ADM','ATND','CALLBCK','CON','DIS','ESC','REF'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_phys()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['Charles R. Drew','Helen Flanders Dunbar','Galen','Ian Olver','Garcia de Orta','Christiaan Eijkman','Pierre Fauchard','Rene Geronimo Favaloro','Alexander Fleming','Girolamo Fracastoro','Sigmund Freud','Daniel Carleton Gajdusek','Henry Gray','George E. Goodfellow','William Harvey','Ernst Haeckel','Henry Heimlich','Orvan Hess','John Hunter','Hippocrates','Elliott P. Joslin','Edward Jenner'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION encounter_random_reason()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['f asdfsd fasdfsad fdasfklsdjaflksda fjsdafjasdklf jsdklfj','fdaff asdf asdfasdf sdaf asdfsd fasdfsad fdasfk','lsdjaflksda fjsdafjasdklf jsdklfj'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION observation_random_name()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['"name": {"coding": [{"system": "http://loinc.org", "code": "8310-5", "display": "Body temperature"}], "text": "Body temperature"},', '"name": {"coding": [{"system": "http://loinc.org", "code": "55284-4", "display": "Blood pressure systolic & diastolic"}]},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},', '"name": {"coding": [{"system": "http://loinc.org", "code": "noise", "display": "noise"}], "text": "Noise "},'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;


CREATE FUNCTION observation_random_status()
  RETURNS varchar AS
$func$
DECLARE
  a varchar[] := array['amended','cancelled','entered in error','final','preliminary','registered'];
BEGIN
  RETURN random_array_element(a);
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION random_array_element(a varchar[])
  RETURNS varchar AS
$func$
DECLARE
  a ALIAS FOR $1;
  l int := array_length(a, 1);
BEGIN
  -- <http://stackoverflow.com/questions/14299043/postgresql-pl-pgsql-random-value-from-array-of-values#14328164>.
  RETURN a[floor((random() * l + 1))::int];
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION random_start_time()
  RETURNS varchar AS
$func$
BEGIN
  RETURN random_time();
END
$func$ LANGUAGE plpgsql VOLATILE;

-- TODO: End time be greater than start time.
CREATE FUNCTION random_end_time()
  RETURNS varchar AS
$func$
BEGIN
  RETURN random_time();
END
$func$ LANGUAGE plpgsql VOLATILE;

CREATE FUNCTION random_time()
  RETURNS varchar AS
$func$
BEGIN
  -- <http://stackoverflow.com/questions/2139396/postgresql-change-date-by-the-random-number-of-days#2139582>.
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

DO $$
DECLARE template varchar;
BEGIN
  SELECT '{"resourceType": "Patient", "text": {"status": "generated", "div": "<div>\n      <p>\n        <b>Generated Narrative</b>\n      </p>\n      <p>\n        <b>identifier</b>: 738472983 (usual), ?? (usual)\n      </p>\n      <p>\n        <b>name</b>: Pieter van de Heuvel \n      </p>\n      <p>\n        <b>telecom</b>: ph: 0648352638(mobile), p.heuvel@gmail.com(home)\n      </p>\n      <p>\n        <b>gender</b>: \n        <span title=\"Codes: {http://hl7.org/fhir/v3/AdministrativeGender M}\">Male</span>\n      </p>\n      <p>\n        <b>birthDate</b>: 17-Nov 1944\n      </p>\n      <p>\n        <b>deceased[x]</b>: false\n      </p>\n      <p>\n        <b>address</b>: Van Egmondkade 23 Amsterdam 1024 RJ NLD (home)\n      </p>\n      <p>\n        <b>maritalStatus</b>: \n        <span title=\"Codes: {http://hl7.org/fhir/v3/MaritalStatus M}\">Getrouwd</span>\n      </p>\n      <p>\n        <b>multipleBirth[x]</b>: true\n      </p>\n      <h3>Contacts</h3>\n      <table class=\"grid\">\n        <tr>\n          <td>\n            <b>Relationship</b>\n          </td>\n          <td>\n            <b>Name</b>\n          </td>\n          <td>\n            <b>Telecom</b>\n          </td>\n          <td>\n            <b>Address</b>\n          </td>\n          <td>\n            <b>Gender</b>\n          </td>\n          <td>\n            <b>Organization</b>\n          </td>\n        </tr>\n        <tr>\n          <td>\n            <span title=\"Codes: {http://hl7.org/fhir/patient-contact-relationship partner}\">Partner</span>\n          </td>\n          <td>Sarah Abels </td>\n          <td>ph: 0690383372(mobile)</td>\n          <td> </td>\n          <td> </td>\n          <td> </td>\n        </tr>\n      </table>\n      <p>\n        <b>communication</b>: \n        <span title=\"Codes: {urn:ietf:bcp:47 nl}\">Nederlands</span>\n      </p>\n      <p>\n        <b>managingOrganization</b>: Burgers University Medical Centre\n      </p>\n      <p>\n        <b>active</b>: true\n      </p>\n    </div>"}, "identifier": [{"use": "temp", "value": "{{.i}}"}, {"use": "usual", "system": "urn:oid:2.16.840.1.113883.2.4.6.3"}], "name": [{"use": "usual", "family": ["van de Heuvel {{.i}}"], "given": ["Pieter {{.i}}"], "suffix": ["MSc"]}], "telecom": [{"system": "phone", "value": "0648352638", "use": "mobile"}, {"system": "email", "value": "p.heuvel@gmail.com", "use": "home"}], "gender": {"coding": [{"system": "http://hl7.org/fhir/v3/AdministrativeGender", "code": "M", "display": "Male"}]}, "birthDate": "{{.birth_date}}", "deceasedBoolean": false, "address": [{"use": "home", "line": ["Van Egmondkade 23"], "city": "Amsterdam", "zip": "1024 RJ", "country": "NLD"}], "maritalStatus": {"coding": [{"system": "http://hl7.org/fhir/v3/MaritalStatus", "code": "M", "display": "Married"}], "text": "Getrouwd"}, "multipleBirthBoolean": true, "contact": [{"relationship": [{"coding": [{"system": "http://hl7.org/fhir/patient-contact-relationship", "code": "partner"}]}], "name": {"use": "usual", "family": ["Abels"], "given": ["Sarah"]}, "telecom": [{"system": "phone", "value": "0690383372", "use": "mobile"}]}], "communication": [{"coding": [{"system": "urn:ietf:bcp:47", "code": "nl", "display": "Dutch"}], "text": "Nederlands"}], "managingOrganization": {"reference": "Organization/f001", "display": "Burgers University Medical Centre"}, "active": {{.is_active}}}'
  INTO template;

  INSERT INTO patients (doc)
  SELECT
    CAST (
      regexp_replace(
        regexp_replace(
          regexp_replace(template, '{{\.i}}', n::varchar),
          '{{\.birth_date}}',
          random_time()
        ),
        '{{\.is_active}}',
        patient_random_is_active()
      )
      AS jsonb
    )
  FROM generate_series(1, 100) n;
END $$;

DO $$
DECLARE template varchar;
BEGIN
  SELECT '{"resourceType": "Encounter", "text": {"status": "generated", "div": "text"}, "identifier": [{"use": "temp", "value": "{{.patient_id}}"}], "status": "{{.status}}", "class": "{{.class}}", "type": [{"coding": [{"system": "http://snomed.info/sct", "code": "183807002", "display": "Inpatient stay for nine days"}]}], "subject": {"reference": "Patient/{{.patient_id}}", "display": "Roel"}, "participant": [{"individual": {"type": [{"coding": [{"system": "encounter-participant-type", "code": "{{.part_type}}"}]}], "reference": "{{.phys}}"}}], "reason": {"text": "{{.reason}}"}, "priority": {"coding": [{"system": "http://snomed.info/sct", "code": "394849002", "display": "High priority"}]}, "hospitalization": {"admitSource": {"coding": [{"system": "http://snomed.info/sct", "code": "309902002", "display": "Clinical Oncology Department"}]}, "period": {"start": "{{.start_time}}", "end": "{{.end_time}}"}, "diet": {"coding": [{"system": "http://snomed.info/sct", "code": "276026009", "display": "Fluid balance regulation"}]}, "reAdmission": false}, "serviceProvider": {"reference": "Organization/f201"}}'
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
                    regexp_replace(
                      template,
                      '{{\.patient_id}}',
                      CAST ((n / 10 + 1) AS varchar)
                    ),
                    '{{\.status}}',
                    encounter_random_status()
                  ),
                  '{{\.class}}',
                  encounter_random_class()
                ),
                '{{\.part_type}}',
                encounter_random_part_type()
              ),
              '{{\.phys}}',
              encounter_random_phys()
            ),
            '{{\.reason}}',
            encounter_random_reason()
          ),
          '{{\.start_time}}',
          random_start_time()
        ),
        '{{\.end_time}}',
        random_end_time()
      )
      AS jsonb
    )
  FROM generate_series(1, 1000) n;
END $$;

DO $$
DECLARE template varchar;
BEGIN
  SELECT '{"resourceType": "Observation", "text": {"status": "generated", "div": ""}, {{.name}} "valueQuantity": {"value": 39, "units": "degrees C", "system": "http://snomed.info/sct", "code": "258710007"}, "interpretation": {"coding": [{"system": "http://hl7.org/fhir/v2/0078", "code": "H"}]}, "appliesPeriod": {"start": "{{.start_time}}", "end": "{{.end_time}}"}, "issued": "2013-04-04T13:27:00+01:00", "status": "{{.status}}", "reliability": "questionable", "bodySite": {"coding": [{"system": "http://snomed.info/sct", "code": "38266002", "display": "Entire body as a whole"}]}, "method": {"coding": [{"system": "http://snomed.info/sct", "code": "89003005", "display": "Oral temperature taking"}]}, "subject": {"reference": "Patient/{{.patient_id}}", "display": "Patient {{.patient_id}}"}, "performer": [{"reference": "Practitioner/f201"}], "referenceRange": [{"low": {"value": 37.5, "units": "degrees C"}}]}'
  INTO template;

  INSERT INTO observations (doc)
  SELECT
    CAST (
      regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                template,
                '{{\.patient_id}}',
                CAST ((n / 10 + 1) AS varchar)
              ),
              '{{\.status}}',
              observation_random_status()
            ),
            '{{\.start_time}}',
            random_start_time()
          ),
          '{{\.end_time}}',
          random_end_time()
        ),
        '{{\.name}}',
        observation_random_name()
      )
      AS jsonb
    )
  FROM generate_series(1, 10000) n;
END $$;
