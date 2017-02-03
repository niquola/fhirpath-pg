SELECT fhirpath_as_number('{"a":{"b": {"c": {"code":"foo"}}}}', '.a.b.c', 'Age', 'min') + 0.1;
