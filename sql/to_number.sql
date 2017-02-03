SELECT fhirpath_as_number('{"a":{"b": {"c": 5.3}}}', '.a.b.c', 'decimal') + 0.1; 
SELECT fhirpath_as_number('{"a":{"b": {"c": 5}}}', '.a.b.c', 'integer') + 1;
SELECT fhirpath_as_number('{"a":{"b": {"c": 5}}}', '.a.b.c', 'positiveInt') + 1;
SELECT fhirpath_as_number('{"a":{"b": {"c": 5}}}', '.a.b.c', 'unsignedInt') + 1;
SELECT fhirpath_as_number('{"a":{"b": {"c": "ups"}}}', '.a.b.c', 'decimal');

SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Age') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Count') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Money') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Distance') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'SimpleQuantity') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Duration') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Quantity') + 0.05;

SELECT fhirpath_as_number('{"a":{"b": {"value": "ups"}}}', '.a.b', 'Quantity') + 0.05;

SELECT fhirpath_as_number('{"a":{"b": {"value": [5.1, 6.1]}}}', '.a.b', 'Quantity') + 0.05;
