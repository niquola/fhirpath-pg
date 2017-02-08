select '''{
  "integer":{
    "value": 40,
    "arrayt": [41, 42, 43],
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

SELECT fhirpath_as_number(:resource, '.integer.arrayt', 'integer' , 'max');
