SELECT fhirpath_as_date('{"a":{"b": {"c": "1980"}}}', '.a.b.c', 'date'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02"}}}', '.a.b.c', 'date'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05"}}}', '.a.b.c', 'date'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08"}}}', '.a.b.c', 'date'); 
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08:30"}}}', '.a.b.c', 'date'); 
