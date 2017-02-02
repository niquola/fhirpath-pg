-- --db:test -e
-- --{{{
DROP EXTENSION IF EXISTS fhirpath;
CREATE EXTENSION fhirpath;

SELECT 'Patient.name.given'::fhirpath as fhirpath;

SELECT '.name.given'::fhirpath as fhirpath;

SELECT 'Patient.name.given'::fhirpath as fhirpath;

SELECT 'Patient.name.where(use=official).given'::fhirpath as fhirpath;

SELECT '.name.where(use=official).given'::fhirpath as fhirpath;

SELECT fhirpath_extract('{"resourceType":"Patient", "field": 1}', 'Patient.field');

SELECT fhirpath_extract('{"resourceType":"Encounter", "field": 1}', 'Patient.field');

SELECT fhirpath_extract('{"a":"1", "b":{"c":"2", "d": [1,2,{"x":100}], "e":{"f": 4}}}', '.b.e.f');

SELECT fhirpath_extract('{"b":{"c":"2"}}', '.b.c');

SELECT fhirpath_extract('{}', '.unexisting');

SELECT fhirpath_extract('{"b":[{"c":1},{"c":2},{"x":"ups"}]}', '.b.c');

\set pt $JSON${"resourceType":"Patient", "name": [{"use": "official", "family": ["ivanov"]}, {"use": "common", "family": ["petrov"]}]}$JSON$

SELECT fhirpath_extract(:pt,'Patient.name.where(use=official).family');

SELECT fhirpath_extract(:pt,'Patient.name.where(use="common").family');

SELECT fhirpath_extract(:pt,'Patient.name.where(use="common")');

SELECT fhirpath_extract(:pt,'Patient.name.family');

SELECT '.name OR .alias'::fhirpath as fhirpath;

SELECT fhirpath_extract('{"b":1, "c":2}', '.b OR .c');

SELECT fhirpath_extract('{"b":1, "c":2}', '.a OR .c');

-- SELECT fhirpath_extract(:pt, '.name.family.vals()');

-- SELECT fhirpath_values(:pt);

-- -- create table if not exists Patient (resource jsonb);
-- -- delete from Patient;
-- -- insert into Patient (resource) values (:pt);
-- -- SELECT fhirpath_as_string(:pt, '.name', 'HumanName');
-- -- SELECT Patient.*
-- -- FROM Patient
-- -- WHERE fhirpath_as_string('HumanName', fhirpath(resource, 'Patient.name')) ilike '%ivan%' LIMIT 10 OFFSET 0;

-- --}}}
