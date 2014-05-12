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

SELECT
  doc#>'{participant,0}' as part,
  doc#>'{class}' as cls,
  doc#>'{status}' as status
FROM encounters
WHERE
doc @@
'("class" = "emergency" &
  "participant".#."individual" (
    "reference" = "Galen" &
    "type".#."coding".# (
      "code" in ("ADM", "ATND") &
      "system" = "encounter-participant-type")) &
  !("status" && ["planned", "finished", "cancelled"]))'
ORDER BY
  doc#>'{participant,0}',
  doc#>'{class}',
  doc#>'{status}'
LIMIT 100;

SELECT count(*) > 0
FROM encounters
WHERE
doc @@
'("class" = "emergency" &
  "participant".#."individual" (
    "reference" = "Galen" &
    "type".#."coding".# (
      "code" in ("ADM","ATND") &
      "system" = "encounter-participant-type")) &
  !("status" && ["planned", "finished", "cancelled"]))';

SELECT count(*)
FROM encounters
WHERE
doc @@
'("class" = "emergency" &
  "participant".#."individual" (
    "reference" = "Galen" &
    "type".#."coding".# (
      "code" in ("ADM", "ATND") &
      "system" = "encounter-participant-type")) &
  !("status" && ["planned", "finished", "cancelled"]))';

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

-- SELECT count(*) FROM observations
-- WHERE doc @@ '(
--   "name"."coding".# (
--     "system" = "http://loinc.org"
--      &
--     "code" = "8310-5"
--   )
-- )'
-- AND
-- (doc #>> '{appliesPeriod,start}')::timestamp > CURRENT_DATE - INTERVAL '3 month'
-- LIMIT 10;

SELECT count(*)
FROM conditions;

SELECT DISTINCT ON (doc #>> '{code}')
doc #>> '{code,coding,0,code}'
FROM conditions
ORDER BY doc #>> '{code}';

SELECT DISTINCT ON (doc #>> '{category}')
doc #>> '{category,coding,0,code}'
FROM conditions
ORDER BY doc #>> '{category}';

SELECT DISTINCT ON (doc #>> '{status}')
doc #>> '{status}'
FROM conditions
ORDER BY doc #>> '{status}';

-- SELECT
-- doc#>'{status}',
-- doc#>'{category,coding}',
-- doc#>'{code,coding}'
-- FROM conditions
-- LIMIT 10;

-- SELECT count(*)
-- FROM conditions
-- WHERE
-- doc @@
-- '("status" = "confirmed" &
--   "category"."coding".# (
--     "system" = "http://snomed.info/sct" &
--     "code" = "diagnosis") &
--   "code"."coding".#."system" = "http://snomed.info/sct")'
-- AND (doc #>> '{code,coding,0,code}' ) in  (SELECT code from stroke_diagnoses) ;

-- SELECT count(*)
-- FROM conditions
-- WHERE
-- doc @@
-- '("status" = "confirmed" &
--   "category"."coding".# (
--     "system" = "http://snomed.info/sct" &
--     "code" = "diagnosis") &
--   "code"."coding".# (
--     "system" = "http://snomed.info/sct" &
--     "code" in ("433.01", "433.10", "433.11", "433.21", "433.31", "433.81", "433.91", "434.00", "434.01", "434.11", "434.91", "436", "430", "431")
--   ))'
-- ;
