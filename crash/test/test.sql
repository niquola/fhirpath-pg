select '''{
  "integer":{
    "value": 40,
    "array": [41, 42, 43],
    "where": [
      {
        "code": "value", "value": 44
      }, {
        "code": "array", "array": [45, 46, 47]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 48},
          {"code": "array", "array": [49, 50, 60]}
        ]
      }
    ]
  },
  "unsignedInt":{
    "value": 50,
    "array": [51, 52, 53],
    "where": [
      {
        "code": "value", "value": 55
      }, {
        "code": "array", "array": [55, 56, 57]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 58},
          {"code": "array", "array": [59, 60, 61]}
        ]
      }
    ]
  },
  "positiveInt":{
    "value": 60,
    "array": [61, 62, 63],
    "where": [
      {
        "code": "value", "value": 66
      }, {
        "code": "array", "array": [65, 66, 67]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 68},
          {"code": "array", "array": [69, 70, 71]}
        ]
      }
    ]
  }
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.integer.value', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.array', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where(code=value).value', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where(code=array).array', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where(code=where).where.where(code=value).value', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where(code=where).where.where(code=array).array', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.value', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.array', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where(code=value).value', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where(code=array).array', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where(code=where).where.where(code=value).value', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where(code=where).where.where(code=array).array', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.value', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.array', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where(code=value).value', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where(code=array).array', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where(code=where).where.where(code=value).value', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where(code=where).where.where(code=array).array', 'positiveInt' , 'max');
