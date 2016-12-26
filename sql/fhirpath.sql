--db:test -e
--{{{
DROP EXTENSION IF EXISTS fhirpath;
CREATE EXTENSION fhirpath;

-- SELECT 'Patient.name.given'::fhirpath as fhirpath;
SELECT '.name.given'::fhirpath as fhirpath;
SELECT 'Patient.name.given'::fhirpath as fhirpath;

SELECT fhirpath_extract('{"resourceType":"Patient", "field": 1}', 'Patient.field');

SELECT fhirpath_extract('{"resourceType":"Encounter", "field": 1}', 'Patient.field');

SELECT fhirpath_extract('{"a":"1", "b":{"c":"2", "d": [1,2,{"x":100}], "e":{"f": 4}}}', '.b.e.f');

SELECT fhirpath_extract('{"b":{"c":"2"}}', '.b.c');

SELECT fhirpath_extract('{"b":[{"c":1},{"c":2},{"x":"ups"}]}', '.b.c');


-- SELECT fhirpath_extract('{}', '.name.given');
-- SELECT fhirpath_extract('{}', 'Patient.name.given');
-- SELECT fhirpath_extract('{}', 'Patient.name.where(use="official").family');
-- SELECT fhirpath_extract('{}', 'Patient.name.given OR Patient.name.family');

--}}}
