select '''{
  "integer":{
    "value": 40,
    "array": [39, 40, 38],
    "where": [{ "code": "value", "value": 40 },
              { "code": "array", "array": [39, 40, 38] },
              { "code": "where",
                "where": [ {"code": "value", "value": 40},
                           {"code": "array", "array": [39, 40, 38]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.integer.value', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.array', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=value).value', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=array).array', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=where).where.where(code=value).value', 'integer' , 'max');
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=where).where.where(code=array).array', 'integer' , 'max');
select '''{
  "unsignedInt":{
    "value": 40,
    "array": [39, 40, 38],
    "where": [{ "code": "value", "value": 40 },
              { "code": "array", "array": [39, 40, 38] },
              { "code": "where",
                "where": [ {"code": "value", "value": 40},
                           {"code": "array", "array": [39, 40, 38]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.unsignedInt.value', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.array', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=value).value', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=array).array', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=where).where.where(code=value).value', 'unsignedInt' , 'max');
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=where).where.where(code=array).array', 'unsignedInt' , 'max');
select '''{
  "positiveInt":{
    "value": 40,
    "array": [39, 40, 38],
    "where": [{ "code": "value", "value": 40 },
              { "code": "array", "array": [39, 40, 38] },
              { "code": "where",
                "where": [ {"code": "value", "value": 40},
                           {"code": "array", "array": [39, 40, 38]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.positiveInt.value', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.array', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=value).value', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=array).array', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=where).where.where(code=value).value', 'positiveInt' , 'max');
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=where).where.where(code=array).array', 'positiveInt' , 'max');
select '''{
  "Quantity":{
    "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},
    "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ],
    "where": [{ "code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} },
              { "code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ] },
              { "code": "where",
                "where": [ {"code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
}},
                           {"code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.Quantity.value', 'Quantity' , 'max');
SELECT fhirpath_as_number(:resource, '.Quantity.array', 'Quantity' , 'max');
SELECT fhirpath_as_number(:resource, '.Quantity.where.where(code=value).value', 'Quantity' , 'max');
SELECT fhirpath_as_number(:resource, '.Quantity.where.where(code=array).array', 'Quantity' , 'max');
SELECT fhirpath_as_number(:resource, '.Quantity.where.where(code=where).where.where(code=value).value', 'Quantity' , 'max');
SELECT fhirpath_as_number(:resource, '.Quantity.where.where(code=where).where.where(code=array).array', 'Quantity' , 'max');
select '''{
  "Age":{
    "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},
    "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ],
    "where": [{ "code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} },
              { "code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ] },
              { "code": "where",
                "where": [ {"code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
}},
                           {"code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.Age.value', 'Age' , 'max');
SELECT fhirpath_as_number(:resource, '.Age.array', 'Age' , 'max');
SELECT fhirpath_as_number(:resource, '.Age.where.where(code=value).value', 'Age' , 'max');
SELECT fhirpath_as_number(:resource, '.Age.where.where(code=array).array', 'Age' , 'max');
SELECT fhirpath_as_number(:resource, '.Age.where.where(code=where).where.where(code=value).value', 'Age' , 'max');
SELECT fhirpath_as_number(:resource, '.Age.where.where(code=where).where.where(code=array).array', 'Age' , 'max');
select '''{
  "Distance":{
    "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},
    "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ],
    "where": [{ "code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} },
              { "code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ] },
              { "code": "where",
                "where": [ {"code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
}},
                           {"code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.Distance.value', 'Distance' , 'max');
SELECT fhirpath_as_number(:resource, '.Distance.array', 'Distance' , 'max');
SELECT fhirpath_as_number(:resource, '.Distance.where.where(code=value).value', 'Distance' , 'max');
SELECT fhirpath_as_number(:resource, '.Distance.where.where(code=array).array', 'Distance' , 'max');
SELECT fhirpath_as_number(:resource, '.Distance.where.where(code=where).where.where(code=value).value', 'Distance' , 'max');
SELECT fhirpath_as_number(:resource, '.Distance.where.where(code=where).where.where(code=array).array', 'Distance' , 'max');
select '''{
  "SimpleQuantity":{
    "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},
    "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ],
    "where": [{ "code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} },
              { "code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ] },
              { "code": "where",
                "where": [ {"code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
}},
                           {"code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.value', 'SimpleQuantity' , 'max');
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.array', 'SimpleQuantity' , 'max');
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.where.where(code=value).value', 'SimpleQuantity' , 'max');
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.where.where(code=array).array', 'SimpleQuantity' , 'max');
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.where.where(code=where).where.where(code=value).value', 'SimpleQuantity' , 'max');
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.where.where(code=where).where.where(code=array).array', 'SimpleQuantity' , 'max');
select '''{
  "Duration":{
    "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},
    "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ],
    "where": [{ "code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} },
              { "code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ] },
              { "code": "where",
                "where": [ {"code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
}},
                           {"code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.Duration.value', 'Duration' , 'max');
SELECT fhirpath_as_number(:resource, '.Duration.array', 'Duration' , 'max');
SELECT fhirpath_as_number(:resource, '.Duration.where.where(code=value).value', 'Duration' , 'max');
SELECT fhirpath_as_number(:resource, '.Duration.where.where(code=array).array', 'Duration' , 'max');
SELECT fhirpath_as_number(:resource, '.Duration.where.where(code=where).where.where(code=value).value', 'Duration' , 'max');
SELECT fhirpath_as_number(:resource, '.Duration.where.where(code=where).where.where(code=array).array', 'Duration' , 'max');
select '''{
  "Count":{
    "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},
    "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ],
    "where": [{ "code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} },
              { "code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ] },
              { "code": "where",
                "where": [ {"code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
}},
                           {"code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.Count.value', 'Count' , 'max');
SELECT fhirpath_as_number(:resource, '.Count.array', 'Count' , 'max');
SELECT fhirpath_as_number(:resource, '.Count.where.where(code=value).value', 'Count' , 'max');
SELECT fhirpath_as_number(:resource, '.Count.where.where(code=array).array', 'Count' , 'max');
SELECT fhirpath_as_number(:resource, '.Count.where.where(code=where).where.where(code=value).value', 'Count' , 'max');
SELECT fhirpath_as_number(:resource, '.Count.where.where(code=where).where.where(code=array).array', 'Count' , 'max');
select '''{
  "Money":{
    "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},
    "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ],
    "where": [{ "code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} },
              { "code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ] },
              { "code": "where",
                "where": [ {"code": "value", "value": {
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
}},
                           {"code": "array", "array": [
{
	"value": 30,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 40,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
},{
	"value": 20,
	"comparator": ">", "unit": "sm", "system": "C", "code": "sm"
} ]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_number(:resource, '.Money.value', 'Money' , 'max');
SELECT fhirpath_as_number(:resource, '.Money.array', 'Money' , 'max');
SELECT fhirpath_as_number(:resource, '.Money.where.where(code=value).value', 'Money' , 'max');
SELECT fhirpath_as_number(:resource, '.Money.where.where(code=array).array', 'Money' , 'max');
SELECT fhirpath_as_number(:resource, '.Money.where.where(code=where).where.where(code=value).value', 'Money' , 'max');
SELECT fhirpath_as_number(:resource, '.Money.where.where(code=where).where.where(code=array).array', 'Money' , 'max');
select '''{
  "date":{
    "value": "1991-12",
    "array": ["1985-05", "1991-12", "1989-05"],
    "where": [{ "code": "value", "value": "1991-12" },
              { "code": "array", "array": ["1985-05", "1991-12", "1989-05"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "1991-12"},
                           {"code": "array", "array": ["1985-05", "1991-12", "1989-05"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_date(:resource, '.date.value', 'date' , 'max');
SELECT fhirpath_as_date(:resource, '.date.array', 'date' , 'max');
SELECT fhirpath_as_date(:resource, '.date.where.where(code=value).value', 'date' , 'max');
SELECT fhirpath_as_date(:resource, '.date.where.where(code=array).array', 'date' , 'max');
SELECT fhirpath_as_date(:resource, '.date.where.where(code=where).where.where(code=value).value', 'date' , 'max');
SELECT fhirpath_as_date(:resource, '.date.where.where(code=where).where.where(code=array).array', 'date' , 'max');
select '''{
  "dateTime":{
    "value": "1991-12-31",
    "array": ["1981-11-12", "1991-12-31", "1990-12-31"],
    "where": [{ "code": "value", "value": "1991-12-31" },
              { "code": "array", "array": ["1981-11-12", "1991-12-31", "1990-12-31"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "1991-12-31"},
                           {"code": "array", "array": ["1981-11-12", "1991-12-31", "1990-12-31"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_date(:resource, '.dateTime.value', 'dateTime' , 'max');
SELECT fhirpath_as_date(:resource, '.dateTime.array', 'dateTime' , 'max');
SELECT fhirpath_as_date(:resource, '.dateTime.where.where(code=value).value', 'dateTime' , 'max');
SELECT fhirpath_as_date(:resource, '.dateTime.where.where(code=array).array', 'dateTime' , 'max');
SELECT fhirpath_as_date(:resource, '.dateTime.where.where(code=where).where.where(code=value).value', 'dateTime' , 'max');
SELECT fhirpath_as_date(:resource, '.dateTime.where.where(code=where).where.where(code=array).array', 'dateTime' , 'max');
select '''{
  "instant":{
    "value": "2002-05-20T09:00:00",
    "array": ["2002-02-10T09:00:00", "2002-05-20T09:00:00", "2002-01-30T09:00:00"],
    "where": [{ "code": "value", "value": "2002-05-20T09:00:00" },
              { "code": "array", "array": ["2002-02-10T09:00:00", "2002-05-20T09:00:00", "2002-01-30T09:00:00"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "2002-05-20T09:00:00"},
                           {"code": "array", "array": ["2002-02-10T09:00:00", "2002-05-20T09:00:00", "2002-01-30T09:00:00"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_date(:resource, '.instant.value', 'instant' , 'max');
SELECT fhirpath_as_date(:resource, '.instant.array', 'instant' , 'max');
SELECT fhirpath_as_date(:resource, '.instant.where.where(code=value).value', 'instant' , 'max');
SELECT fhirpath_as_date(:resource, '.instant.where.where(code=array).array', 'instant' , 'max');
SELECT fhirpath_as_date(:resource, '.instant.where.where(code=where).where.where(code=value).value', 'instant' , 'max');
SELECT fhirpath_as_date(:resource, '.instant.where.where(code=where).where.where(code=array).array', 'instant' , 'max');
select '''{
  "time":{
    "value": "11:00:00",
    "array": ["09:00:00", "11:00:00", "08:00:00"],
    "where": [{ "code": "value", "value": "11:00:00" },
              { "code": "array", "array": ["09:00:00", "11:00:00", "08:00:00"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "11:00:00"},
                           {"code": "array", "array": ["09:00:00", "11:00:00", "08:00:00"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_date(:resource, '.time.value', 'time' , 'max');
SELECT fhirpath_as_date(:resource, '.time.array', 'time' , 'max');
SELECT fhirpath_as_date(:resource, '.time.where.where(code=value).value', 'time' , 'max');
SELECT fhirpath_as_date(:resource, '.time.where.where(code=array).array', 'time' , 'max');
SELECT fhirpath_as_date(:resource, '.time.where.where(code=where).where.where(code=value).value', 'time' , 'max');
SELECT fhirpath_as_date(:resource, '.time.where.where(code=where).where.where(code=array).array', 'time' , 'max');
select '''{
  "Period":{
    "value": {"start": "1991-01-01", "end": "1991-12-31"},
    "array": [{"start": "1991-01-01", "end": "1991-12-31"},
							 {"start": "1990-01-01", "end": "1991-12-31"},
							 {"start": "1981-01-01"}],
    "where": [{ "code": "value", "value": {"start": "1991-01-01", "end": "1991-12-31"} },
              { "code": "array", "array": [{"start": "1991-01-01", "end": "1991-12-31"},
							 {"start": "1990-01-01", "end": "1991-12-31"},
							 {"start": "1981-01-01"}] },
              { "code": "where",
                "where": [ {"code": "value", "value": {"start": "1991-01-01", "end": "1991-12-31"}},
                           {"code": "array", "array": [{"start": "1991-01-01", "end": "1991-12-31"},
							 {"start": "1990-01-01", "end": "1991-12-31"},
							 {"start": "1981-01-01"}]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_date(:resource, '.Period.value', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.array', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=value).value', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=array).array', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=where).where.where(code=value).value', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=where).where.where(code=array).array', 'Period' , 'max');
select '''{
  "Timing":{
    "value": {"event": ["1991-01-01", "1992-01-01"]},
    "array": [{"event": ["1991-01-01"]},
							 {"event": ["2000-01-01", "1990-01-01"]},
							 {"event": ["1992-01-01"]}],
    "where": [{ "code": "value", "value": {"event": ["1991-01-01", "1992-01-01"]} },
              { "code": "array", "array": [{"event": ["1991-01-01"]},
							 {"event": ["2000-01-01", "1990-01-01"]},
							 {"event": ["1992-01-01"]}] },
              { "code": "where",
                "where": [ {"code": "value", "value": {"event": ["1991-01-01", "1992-01-01"]}},
                           {"code": "array", "array": [{"event": ["1991-01-01"]},
							 {"event": ["2000-01-01", "1990-01-01"]},
							 {"event": ["1992-01-01"]}]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_date(:resource, '.Timing.value', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.array', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=value).value', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=array).array', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=where).where.where(code=value).value', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=where).where.where(code=array).array', 'Timing' , 'max');
select '''{
  "string":{
    "value": "some STring",
    "array": ["some STring", "some another string", "too string ouuu ehh"],
    "where": [{ "code": "value", "value": "some STring" },
              { "code": "array", "array": ["some STring", "some another string", "too string ouuu ehh"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "some STring"},
                           {"code": "array", "array": ["some STring", "some another string", "too string ouuu ehh"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_string(:resource, '.string.value', 'string' );
SELECT fhirpath_as_string(:resource, '.string.array', 'string' );
SELECT fhirpath_as_string(:resource, '.string.where.where(code=value).value', 'string' );
SELECT fhirpath_as_string(:resource, '.string.where.where(code=array).array', 'string' );
SELECT fhirpath_as_string(:resource, '.string.where.where(code=where).where.where(code=value).value', 'string' );
SELECT fhirpath_as_string(:resource, '.string.where.where(code=where).where.where(code=array).array', 'string' );
select '''{
  "code":{
    "value": "male",
    "array": ["male", "female", "unknown"],
    "where": [{ "code": "value", "value": "male" },
              { "code": "array", "array": ["male", "female", "unknown"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "male"},
                           {"code": "array", "array": ["male", "female", "unknown"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_string(:resource, '.code.value', 'code' );
SELECT fhirpath_as_string(:resource, '.code.array', 'code' );
SELECT fhirpath_as_string(:resource, '.code.where.where(code=value).value', 'code' );
SELECT fhirpath_as_string(:resource, '.code.where.where(code=array).array', 'code' );
SELECT fhirpath_as_string(:resource, '.code.where.where(code=where).where.where(code=value).value', 'code' );
SELECT fhirpath_as_string(:resource, '.code.where.where(code=where).where.where(code=array).array', 'code' );
select '''{
  "id":{
    "value": "db042450-efa6-11e6-bc64-92361f002671",
    "array": ["e0349ebe-efa6-11e6-bc64-92361f002671",
					 "e034a24c-efa6-11e6-bc64-92361f002671",
				   "e034a364-efa6-11e6-bc64-92361f002671"],
    "where": [{ "code": "value", "value": "db042450-efa6-11e6-bc64-92361f002671" },
              { "code": "array", "array": ["e0349ebe-efa6-11e6-bc64-92361f002671",
					 "e034a24c-efa6-11e6-bc64-92361f002671",
				   "e034a364-efa6-11e6-bc64-92361f002671"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "db042450-efa6-11e6-bc64-92361f002671"},
                           {"code": "array", "array": ["e0349ebe-efa6-11e6-bc64-92361f002671",
					 "e034a24c-efa6-11e6-bc64-92361f002671",
				   "e034a364-efa6-11e6-bc64-92361f002671"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_string(:resource, '.id.value', 'id' );
SELECT fhirpath_as_string(:resource, '.id.array', 'id' );
SELECT fhirpath_as_string(:resource, '.id.where.where(code=value).value', 'id' );
SELECT fhirpath_as_string(:resource, '.id.where.where(code=array).array', 'id' );
SELECT fhirpath_as_string(:resource, '.id.where.where(code=where).where.where(code=value).value', 'id' );
SELECT fhirpath_as_string(:resource, '.id.where.where(code=where).where.where(code=array).array', 'id' );
select '''{
  "markdown":{
    "value": "\n ## Hello header\n \n __some bold__ or _italic_\n \n ",
    "array": ["\n # Hello header 1\n \n __some bold__ or _italic_\n \n ",
								 "\n \n ## Hello header 2\n \n __some bold__ or _italic_\n \n \n ",
								 "\n \n ### Hello header 3\n \n __some bold__ or _italic_\n \n "],
    "where": [{ "code": "value", "value": "\n ## Hello header\n \n __some bold__ or _italic_\n \n " },
              { "code": "array", "array": ["\n # Hello header 1\n \n __some bold__ or _italic_\n \n ",
								 "\n \n ## Hello header 2\n \n __some bold__ or _italic_\n \n \n ",
								 "\n \n ### Hello header 3\n \n __some bold__ or _italic_\n \n "] },
              { "code": "where",
                "where": [ {"code": "value", "value": "\n ## Hello header\n \n __some bold__ or _italic_\n \n "},
                           {"code": "array", "array": ["\n # Hello header 1\n \n __some bold__ or _italic_\n \n ",
								 "\n \n ## Hello header 2\n \n __some bold__ or _italic_\n \n \n ",
								 "\n \n ### Hello header 3\n \n __some bold__ or _italic_\n \n "]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_string(:resource, '.markdown.value', 'markdown' );
SELECT fhirpath_as_string(:resource, '.markdown.array', 'markdown' );
SELECT fhirpath_as_string(:resource, '.markdown.where.where(code=value).value', 'markdown' );
SELECT fhirpath_as_string(:resource, '.markdown.where.where(code=array).array', 'markdown' );
SELECT fhirpath_as_string(:resource, '.markdown.where.where(code=where).where.where(code=value).value', 'markdown' );
SELECT fhirpath_as_string(:resource, '.markdown.where.where(code=where).where.where(code=array).array', 'markdown' );
select '''{
  "HumanName":{
    "value": {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]},
    "array": [{"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}, {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}, {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}],
    "where": [{ "code": "value", "value": {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]} },
              { "code": "array", "array": [{"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}, {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}, {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}] },
              { "code": "where",
                "where": [ {"code": "value", "value": {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}},
                           {"code": "array", "array": [{"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}, {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}, {"use": "official",
									"text": "NameText",
									"period":  {"start": "1991-01-01", "end": "1991-12-31"},
									"family": ["family 1", "family 2"],
									"given": ["given 1", "given 2"],
									"prefix": ["prefix 1", "prefix 2"],
									"suffix": ["suffix 1", "suffix 2"]}]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_string(:resource, '.HumanName.value', 'HumanName' );
SELECT fhirpath_as_string(:resource, '.HumanName.array', 'HumanName' );
SELECT fhirpath_as_string(:resource, '.HumanName.where.where(code=value).value', 'HumanName' );
SELECT fhirpath_as_string(:resource, '.HumanName.where.where(code=array).array', 'HumanName' );
SELECT fhirpath_as_string(:resource, '.HumanName.where.where(code=where).where.where(code=value).value', 'HumanName' );
SELECT fhirpath_as_string(:resource, '.HumanName.where.where(code=where).where.where(code=array).array', 'HumanName' );
select '''{
  "Address":{
    "value": {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" },
    "array": [{"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }, {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }, {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }],
    "where": [{ "code": "value", "value": {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" } },
              { "code": "array", "array": [{"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }, {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }, {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }] },
              { "code": "where",
                "where": [ {"code": "value", "value": {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }},
                           {"code": "array", "array": [{"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }, {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }, {"use": "home", "type":"physical",
								"text": "Some address text", "line": ["line 1", "line 2"],
								"city": "SPB", "District": "DistrictFive",
								"state": "state", "postalCode": "Postal code",
								"period":  {"start": "1991-01-01", "end": "1991-12-31"},
								"country": "Russia" }]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_string(:resource, '.Address.value', 'Address' );
SELECT fhirpath_as_string(:resource, '.Address.array', 'Address' );
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=value).value', 'Address' );
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=array).array', 'Address' );
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=where).where.where(code=value).value', 'Address' );
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=where).where.where(code=array).array', 'Address' );
