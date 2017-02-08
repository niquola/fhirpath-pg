SELECT fhirpath_as_number('{"a":{"b": {"c": {"code":"foo"}}}}', '.a.b.c', 'Age', 'min') + 0.1;
SELECT fhirpath_as_number('{ "number":{"value": 42}, "date": {"value": "1980"}, "string": {"value": "Test"}, "token": {}, "reference": {}, "composite": {}, "quantity": {}, "uri": {}, "_empty_obj": {}, "_empty_arr": [], "_empty_str": "" }', '.number.value', 'integer', 'min');
SELECT fhirpath_as_number('{ "number":{"value": [1, 42, 5]}, "date": {"value": "1980"}, "string": {"value": "Test"}, "token": {}, "reference": {}, "composite": {}, "quantity": {}, "uri": {}, "_empty_obj": {}, "_empty_arr": [], "_empty_str": "" }', '.number.value', 'integer', 'min');
SELECT fhirpath_as_number('{"a":{"b": {"array": [40, 42, 39]}}}', '.a.b.array', 'integer', 'max') + 0.1;
