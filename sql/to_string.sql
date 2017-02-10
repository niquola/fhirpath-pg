\set pt $JSON${"resourceType":"Patient", "name": [{"use": "official", "ext": {"bext" : ["fext"]}, "family": ["ivanov", "vodkin"]}, {"use": "common", "family": ["petrov"]}]}$JSON$

SELECT fhirpath_as_string(:pt, '.name', 'HumanName');
SELECT fhirpath_as_string('{"name": [{"use": "SKIP", "period": "SKIP", "family": ["f1", "f2"]}]}', '.name', 'HumanName');
SELECT fhirpath_as_string('{"name": [{"use": "SKIP", "period": "SKIP", "street": ["f1", "f2"]}]}', '.name', 'Address');
SELECT fhirpath_as_string(:pt, '.name.family', 'string');
SELECT fhirpath_as_string(:pt, '.name.where(use=official).family', 'HumanName');
SELECT fhirpath_as_string(:pt, '.name.where(use=common).family', 'HumanName');

SELECT fhirpath_as_string('{"name": [{"use": "SKIP", "period": {"start":  "SKIP", "end": "SKIP"}, "street": ["f1", "f2"]}]}', '.name', 'Address');
