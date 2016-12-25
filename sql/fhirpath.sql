--db:test -e
--{{{
DROP EXTENSION IF EXISTS fhirpath;
CREATE EXTENSION fhirpath;

SELECT fhirpath_extract('{"a":"1", "b":{"c":"2", "d": [1,2,{"x":100}], "e":{"f": 4}}}', 'b.e.f');
SELECT fhirpath_extract('{"b":{"c":"2"}}', 'b.c');
SELECT fhirpath_extract('{"b":[{"c":1},{"c":2},{"x":"ups"}]}', 'b.c');

--}}}
