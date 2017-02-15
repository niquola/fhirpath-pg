drop table if exists as_token_test;
create table as_token_test (resource jsonb);

insert into as_token_test (resource) values (
$$
{
  "resourceType": "Patient",
  "id": "example",
  "identifier": [
   {
    "use": "usual",
    "type": { "coding": [
      {"system": "sys1", "code": "code1"},
      {"system": "sys2", "code": "code2"}
    ]},
    "system": "isys",
    "value": "value1",
    "period": {"start": "2001-05-06"},
    "assigner": {"display": "Acme Healthcare"}
   },
   {
   "use": "official",
   "type": { "coding": [
     {"system": "itsys", "code": "itcode"}
   ]},
   "system": "isys2",
   "value": "ival2"
   }
  ],
  "organization": {
     "reference": "Organization/1"
  },
  "quantity": {
     "code": "code",
     "system": "system",
     "unit": "unit"
  },
  "telecom": [
      {
        "system": "phone",
        "value": "(03) 5555 6473",
        "use": "work"
      },
      {
        "system": "email",
        "value": "ivan@mail.ru",
        "use": "home"
      }
  ]

}
$$
);

SELECT fhirpath_as_token(resource, '.identifier', 'Identifier') from as_token_test;
SELECT fhirpath_as_token(resource, '.telecom', 'ContactPoint') from as_token_test;
SELECT fhirpath_as_token(resource, '.telecom.value', 'string') from as_token_test;
SELECT fhirpath_as_token(resource, '.telecom.use', 'code') from as_token_test;
SELECT fhirpath_as_token(resource, '.telecom.use', 'uri') from as_token_test;
SELECT fhirpath_as_token(resource, '.telecom.use', 'string') from as_token_test;
SELECT fhirpath_as_token(resource, '.identifier.type.coding', 'Coding') from as_token_test;
SELECT fhirpath_as_token(resource, '.organization', 'Reference') from as_token_test;
SELECT fhirpath_as_token(resource, '.quantity', 'Quantity') from as_token_test;
SELECT fhirpath_as_token(resource, '.identifier.type', 'CodeableConcept') from as_token_test;

SELECT fhirpath_as_token('{"a": true}', '.a', 'boolean') from as_token_test;
SELECT fhirpath_as_token('{"a": false}', '.a', 'boolean') from as_token_test;
SELECT fhirpath_as_token('{"a": "ups"}', '.a', 'boolean') from as_token_test;
SELECT fhirpath_as_token('{"a": 1234}', '.a', 'integer') from as_token_test;
SELECT fhirpath_as_token('{"a": 1234.1}', '.a', 'integer') from as_token_test;
SELECT fhirpath_as_token('{"a": {"value": 1234}}', '.a', 'Identifier') from as_token_test;

SELECT fhirpath_as_token(resource, $FP$.telecom.where(use='work')$FP$, 'ContactPoint') from as_token_test;
SELECT fhirpath_as_token(resource, $FP$.telecom.where(use=work)$FP$, 'ContactPoint') from as_token_test;
SELECT fhirpath_as_token(resource, $FP$.telecom.where(use="work")$FP$, 'ContactPoint') from as_token_test;

-- test lowering
SELECT fhirpath_as_token('{"a": "AAAA"}', '.a', 'string') from as_token_test;
SELECT fhirpath_as_token('{"coding": {"code": "CC", "system": "SYS"}}', '.coding', 'Coding') from as_token_test;

-- polymorphic
SELECT fhirpath_as_token('{"propCodeableConcept": {"coding": [{"code": "CC", "system": "SYS"}]}}', '.prop', 'Polymorphic') from as_token_test;
SELECT fhirpath_as_token('{"b": {"propCodeableConcept": {"coding": [{"code": "CC", "system": "SYS"}]}}}', '.a.prop', 'Polymorphic') from as_token_test;
SELECT fhirpath_as_token('{"a": {"propCodeableConcept": {"coding": [{"code": "CC", "system": "SYS"}]}}}', '.a.prop', 'Polymorphic') from as_token_test;
SELECT fhirpath_as_token('{"a": {"x": 1, "y": 2, "propCodeableConcept": {"coding": [{"code": "CC", "system": "SYS"}]}}}', '.a.prop', 'Polymorphic') from as_token_test;
SELECT fhirpath_as_token('{"a": {"x": 1, "y": 2, "propCodeableConcept": {"coding": [{"code": "C1", "system": "SYS2"},{"code": "C2", "system": "SYS2"}]}}}', '.a.prop', 'Polymorphic') from as_token_test;
