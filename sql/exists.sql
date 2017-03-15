SELECT  '.a.b.exists()'::fhirpath;

SELECT fhirpath_exists('{"a":{"b": {"c": 5.3}}}', '.a.b.exists()', 'decimal'); 
SELECT fhirpath_exists('{"a":{"b": [{"c": 5.3}, {"d": 1}]}}', '.a.b.exists()', 'decimal'); 
SELECT fhirpath_exists('{"a":{"b": [{"c": 5.3}, {"d": 1}]}}', '.a.b.c.exists()', 'decimal'); 
SELECT fhirpath_exists('{"a":{"b": [{"c": 5.3}, {"d": 1}]}}', '.a.b.d.exists()', 'decimal'); 
SELECT fhirpath_exists('{"a":{"b": [{"c": 5.3}, {"d": 1}]}}', '.a.b.f.exists()', 'decimal'); 

SELECT fhirpath_exists('{"a":{"b": {"c": 5.3}}}', '.a.b.c.exists()', 'decimal'); 

SELECT fhirpath_exists('{"a":{"b": {"c": 5.3}}}', '.a.b.e.exists()', 'decimal'); 
SELECT fhirpath_exists('{"a":{"b": {"c": 5.3}}}', '.a.f.e.exists()', 'decimal'); 

SELECT fhirpath_exists('{"a":{"b": {"c": 5.3}}}', '.a.b.c.d.exists()', 'decimal'); 
SELECT fhirpath_exists('{"a":{"b": {"cDate": 5.3}}}', '.a.b.c.exists()', 'Polymorphic'); 

SELECT fhirpath_exists('{"aDate":{"b": {"c": 5.3}}}', '.a.b.c.exists()', 'Polymorphic'); 
SELECT fhirpath_exists('{"a":{"bDate": {"c": 5.3}}}', '.a.b.c.exists()', 'Polymorphic'); 
