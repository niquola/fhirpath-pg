SELECT fhirpath_as_reference('{"a":{"b": {"reference": "Patient/1"}}}', '.a.b', 'Reference');
SELECT fhirpath_as_reference('{"a":{"b": {"reference": "http://dom.io/ups/Patient/1"}}}', '.a.b', 'Reference');
SELECT fhirpath_as_reference('{"a":{"b": {"reference": "Patient/nicola"}}}', '.a.b', 'Reference');
SELECT fhirpath_as_reference('{"a":{"b": "Patient/1"}}', '.a.b', 'uri');
SELECT fhirpath_as_reference('{"a":{"b": "http://dom.io/ups/Patient/1"}}', '.a.b', 'uri');
SELECT fhirpath_as_reference('{"a":{"b": "Patient/nicola"}}', '.a.b', 'uri');
SELECT fhirpath_as_reference('{"a":{"b": ["Patient/1", "Patient/2"]}}', '.a.b', 'uri');
