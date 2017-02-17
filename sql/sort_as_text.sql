\set pt $JSON${"resourceType":"Patient", "name": [{"use": "official", "ext": {"bext" : ["fext"]}, "family": ["ivanov", "vodkin"], "given": ["petrov"]}, {"use": "common", "family": ["petrov"]}]}$JSON$

SELECT fhirpath_sort_as_text(:pt, '.name', 'HumanName');
SELECT fhirpath_sort_as_text('{"name": [{"use": "SKIP", "period": "SKIP", "family": ["f1", "f2"]}]}', '.name', 'HumanName');
SELECT fhirpath_sort_as_text('{"name": [{"use": "SKIP", "period": "SKIP", "line": ["f1", "f2"]}]}', '.name', 'Address');
SELECT fhirpath_sort_as_text(:pt, '.name.family', 'string');
SELECT fhirpath_sort_as_text(:pt, '.name.where(use=official).family', 'HumanName');
SELECT fhirpath_sort_as_text(:pt, '.name.where(use=common).family', 'HumanName');
SELECT fhirpath_sort_as_text('{"name": [{"use": "SKIP", "period": {"start":  "SKIP", "end": "SKIP"}, "line": ["f1", "f2"]}]}', '.name', 'Address');
SELECT fhirpath_sort_as_text('{"a": 222}', '.a', 'Numeric');
SELECT fhirpath_sort_as_text('{"name": [{"use": "SKIP", "period": "SKIP", "given": ["Tanebaum"], "family": ["Rudolf"]}]}', '.name', 'HumanName');
SELECT fhirpath_sort_as_text('{"coding": {"code": "C1", "system": "SYS"}}', '.coding', 'Coding');
