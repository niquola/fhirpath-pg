SELECT fhirpath_as_date('{"a":{"b": {"c": "1980"}}}', '.a.b.c', 'date', 'min'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02"}}}', '.a.b.c', 'date', 'min'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05"}}}', '.a.b.c', 'date', 'min'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08"}}}', '.a.b.c', 'date', 'min'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08:30"}}}', '.a.b.c', 'date', 'min'); 

SELECT fhirpath_as_date('{"a":["1980-02-05T08:30", "1976-01", "1952-02-03"]}', '.a', 'date', 'min'); 

SELECT fhirpath_as_date('{"a":{"b": {"c": "1980"}}}', '.a.b.c', 'date', 'max'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02"}}}', '.a.b.c', 'date', 'max'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05"}}}', '.a.b.c', 'date', 'max'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08"}}}', '.a.b.c', 'date', 'max'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08:30"}}}', '.a.b.c', 'date', 'max'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08:30+05"}}}', '.a.b.c', 'date', 'max'); 

SELECT fhirpath_as_date('{"a":["1980-02-05T08:30", "1976-01", "1952-02-03"]}', '.a', 'date', 'max'); 
