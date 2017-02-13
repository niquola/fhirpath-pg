
SELECT fhirpath_as_number('{"a":{"b": {"c": 5.3}}}', '.a.b.c', 'decimal', 'min') + 0.1; 
SELECT fhirpath_as_number('{"a":{"b": {"c": 5}}}', '.a.b.c', 'integer', 'min') + 1;
SELECT fhirpath_as_number('{"a":{"b": {"c": 5}}}', '.a.b.c', 'positiveInt', 'min') + 1;
SELECT fhirpath_as_number('{"a":{"b": {"c": 5}}}', '.a.b.c', 'unsignedInt', 'min') + 1;
SELECT fhirpath_as_number('{"a":{"b": {"c": "ups"}}}', '.a.b.c', 'decimal', 'min');
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Age', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Count', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Money', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Distance', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'SimpleQuantity', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Duration', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": 5.1}}}', '.a.b', 'Quantity', 'min') + 0.05;
SELECT fhirpath_as_number('{"Quantity":{"b": {"value": 5.1}}}', '.Quantity.b', 'Quantity', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": "ups"}}}', '.a.b', 'Quantity', 'min') + 0.05;

SELECT fhirpath_as_number('{"a":{"b": {"value": [5.1, 6.1]}}}', '.a.b.value', 'decimal', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": {"value": [5.1, 6.1]}}}', '.a.b.value', 'decimal', 'max') + 0.05;

SELECT fhirpath_as_number('{"a":{"b": [{"value": 5.1},{"value": 6.1}]}}', '.a.b', 'Quantity', 'min') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": [{"value": 5.1},{"value": 6.1}]}}', '.a.b', 'Quantity', 'max') + 0.05;
SELECT fhirpath_as_number('{"a":{"b": [{"value": 7.1},{"value": 6.1}]}}', '.a.b', 'Quantity', 'max') + 0.05;

SELECT fhirpath_as_number('{"a":[7.1, 6.1, 100, 1.1]}', '.a', 'decimal', 'max') + 0.05;
SELECT fhirpath_as_number('{"a":[7.1, 6.1, 100, 1.1]}', '.a', 'decimal', 'min') + 0.05;

