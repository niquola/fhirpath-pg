SELECT fhirpath_as_reference('{"a":{"b": {"reference": "Patient/1"}}}', '.a.b', 'Reference');
SELECT fhirpath_as_reference('{"a":{"b": {"reference": "http://dom.io/ups/Patient/1"}}}', '.a.b', 'Reference');
