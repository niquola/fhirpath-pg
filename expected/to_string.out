\set pt $JSON${"resourceType":"Patient", "name": [{"use": "official", "ext": {"bext" : ["fext"]}, "family": ["ivanov", "vodkin"]}, {"use": "common", "family": ["petrov"]}]}$JSON$
SELECT fhirpath_as_string(:pt, '.name', 'HumanName');
             fhirpath_as_string              
---------------------------------------------
 $fext$official$ivanov$vodkin$common$petrov$
(1 row)

SELECT fhirpath_as_string(:pt, '.name.family', 'HumanName');
   fhirpath_as_string   
------------------------
 $ivanov$vodkin$petrov$
(1 row)

SELECT fhirpath_as_string(:pt, '.name.where(use=official).family', 'HumanName');
 fhirpath_as_string 
--------------------
 $ivanov$vodkin$
(1 row)

SELECT fhirpath_as_string(:pt, '.name.where(use=common).family', 'HumanName');
 fhirpath_as_string 
--------------------
 $petrov$
(1 row)

