\set pt $JSON${"resourceType":"Patient", "name": [{"use": "official", "ext": {"bext" : ["fext"]}, "family": ["ivanov", "vodkin"]}, {"use": "common", "family": ["petrov"]}]}$JSON$

SELECT fhirpath_as_string(:pt, '.name', 'HumanName');
SELECT fhirpath_as_string(:pt, '.name.family', 'HumanName');
SELECT fhirpath_as_string(:pt, '.name.where(use=official).family', 'HumanName');
SELECT fhirpath_as_string(:pt, '.name.where(use=common).family', 'HumanName');
