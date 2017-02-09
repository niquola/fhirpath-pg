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
DO language plpgsql $$ BEGIN RAISE info 'number .integer.value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.array integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.array', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=value).value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=value).value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=array).array integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=array).array', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=where).where.where(code=value).value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=where).where.where(code=value).value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=where).where.where(code=array).array integer'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=value).value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=value).value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=array).array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=array).array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=where).where.where(code=value).value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=where).where.where(code=value).value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=where).where.where(code=array).array unsignedInt'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.array', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=value).value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=value).value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=array).array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=array).array', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=where).where.where(code=value).value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=where).where.where(code=value).value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=where).where.where(code=array).array positiveInt'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .Quantity.value Quantity'; END $$;
SELECT fhirpath_as_number(:resource, '.Quantity.value', 'Quantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Quantity.array Quantity'; END $$;
SELECT fhirpath_as_number(:resource, '.Quantity.array', 'Quantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Quantity.where.where(code=value).value Quantity'; END $$;
SELECT fhirpath_as_number(:resource, '.Quantity.where.where(code=value).value', 'Quantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Quantity.where.where(code=array).array Quantity'; END $$;
SELECT fhirpath_as_number(:resource, '.Quantity.where.where(code=array).array', 'Quantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Quantity.where.where(code=where).where.where(code=value).value Quantity'; END $$;
SELECT fhirpath_as_number(:resource, '.Quantity.where.where(code=where).where.where(code=value).value', 'Quantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Quantity.where.where(code=where).where.where(code=array).array Quantity'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .Age.value Age'; END $$;
SELECT fhirpath_as_number(:resource, '.Age.value', 'Age' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Age.array Age'; END $$;
SELECT fhirpath_as_number(:resource, '.Age.array', 'Age' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Age.where.where(code=value).value Age'; END $$;
SELECT fhirpath_as_number(:resource, '.Age.where.where(code=value).value', 'Age' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Age.where.where(code=array).array Age'; END $$;
SELECT fhirpath_as_number(:resource, '.Age.where.where(code=array).array', 'Age' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Age.where.where(code=where).where.where(code=value).value Age'; END $$;
SELECT fhirpath_as_number(:resource, '.Age.where.where(code=where).where.where(code=value).value', 'Age' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Age.where.where(code=where).where.where(code=array).array Age'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .Distance.value Distance'; END $$;
SELECT fhirpath_as_number(:resource, '.Distance.value', 'Distance' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Distance.array Distance'; END $$;
SELECT fhirpath_as_number(:resource, '.Distance.array', 'Distance' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Distance.where.where(code=value).value Distance'; END $$;
SELECT fhirpath_as_number(:resource, '.Distance.where.where(code=value).value', 'Distance' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Distance.where.where(code=array).array Distance'; END $$;
SELECT fhirpath_as_number(:resource, '.Distance.where.where(code=array).array', 'Distance' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Distance.where.where(code=where).where.where(code=value).value Distance'; END $$;
SELECT fhirpath_as_number(:resource, '.Distance.where.where(code=where).where.where(code=value).value', 'Distance' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Distance.where.where(code=where).where.where(code=array).array Distance'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .SimpleQuantity.value SimpleQuantity'; END $$;
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.value', 'SimpleQuantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .SimpleQuantity.array SimpleQuantity'; END $$;
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.array', 'SimpleQuantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .SimpleQuantity.where.where(code=value).value SimpleQuantity'; END $$;
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.where.where(code=value).value', 'SimpleQuantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .SimpleQuantity.where.where(code=array).array SimpleQuantity'; END $$;
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.where.where(code=array).array', 'SimpleQuantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .SimpleQuantity.where.where(code=where).where.where(code=value).value SimpleQuantity'; END $$;
SELECT fhirpath_as_number(:resource, '.SimpleQuantity.where.where(code=where).where.where(code=value).value', 'SimpleQuantity' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .SimpleQuantity.where.where(code=where).where.where(code=array).array SimpleQuantity'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .Duration.value Duration'; END $$;
SELECT fhirpath_as_number(:resource, '.Duration.value', 'Duration' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Duration.array Duration'; END $$;
SELECT fhirpath_as_number(:resource, '.Duration.array', 'Duration' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Duration.where.where(code=value).value Duration'; END $$;
SELECT fhirpath_as_number(:resource, '.Duration.where.where(code=value).value', 'Duration' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Duration.where.where(code=array).array Duration'; END $$;
SELECT fhirpath_as_number(:resource, '.Duration.where.where(code=array).array', 'Duration' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Duration.where.where(code=where).where.where(code=value).value Duration'; END $$;
SELECT fhirpath_as_number(:resource, '.Duration.where.where(code=where).where.where(code=value).value', 'Duration' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Duration.where.where(code=where).where.where(code=array).array Duration'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .Count.value Count'; END $$;
SELECT fhirpath_as_number(:resource, '.Count.value', 'Count' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Count.array Count'; END $$;
SELECT fhirpath_as_number(:resource, '.Count.array', 'Count' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Count.where.where(code=value).value Count'; END $$;
SELECT fhirpath_as_number(:resource, '.Count.where.where(code=value).value', 'Count' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Count.where.where(code=array).array Count'; END $$;
SELECT fhirpath_as_number(:resource, '.Count.where.where(code=array).array', 'Count' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Count.where.where(code=where).where.where(code=value).value Count'; END $$;
SELECT fhirpath_as_number(:resource, '.Count.where.where(code=where).where.where(code=value).value', 'Count' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Count.where.where(code=where).where.where(code=array).array Count'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'number .Money.value Money'; END $$;
SELECT fhirpath_as_number(:resource, '.Money.value', 'Money' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Money.array Money'; END $$;
SELECT fhirpath_as_number(:resource, '.Money.array', 'Money' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Money.where.where(code=value).value Money'; END $$;
SELECT fhirpath_as_number(:resource, '.Money.where.where(code=value).value', 'Money' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Money.where.where(code=array).array Money'; END $$;
SELECT fhirpath_as_number(:resource, '.Money.where.where(code=array).array', 'Money' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Money.where.where(code=where).where.where(code=value).value Money'; END $$;
SELECT fhirpath_as_number(:resource, '.Money.where.where(code=where).where.where(code=value).value', 'Money' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .Money.where.where(code=where).where.where(code=array).array Money'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'date .date.value date'; END $$;
SELECT fhirpath_as_date(:resource, '.date.value', 'date' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .date.array date'; END $$;
SELECT fhirpath_as_date(:resource, '.date.array', 'date' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .date.where.where(code=value).value date'; END $$;
SELECT fhirpath_as_date(:resource, '.date.where.where(code=value).value', 'date' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .date.where.where(code=array).array date'; END $$;
SELECT fhirpath_as_date(:resource, '.date.where.where(code=array).array', 'date' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .date.where.where(code=where).where.where(code=value).value date'; END $$;
SELECT fhirpath_as_date(:resource, '.date.where.where(code=where).where.where(code=value).value', 'date' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .date.where.where(code=where).where.where(code=array).array date'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'date .dateTime.value dateTime'; END $$;
SELECT fhirpath_as_date(:resource, '.dateTime.value', 'dateTime' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .dateTime.array dateTime'; END $$;
SELECT fhirpath_as_date(:resource, '.dateTime.array', 'dateTime' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .dateTime.where.where(code=value).value dateTime'; END $$;
SELECT fhirpath_as_date(:resource, '.dateTime.where.where(code=value).value', 'dateTime' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .dateTime.where.where(code=array).array dateTime'; END $$;
SELECT fhirpath_as_date(:resource, '.dateTime.where.where(code=array).array', 'dateTime' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .dateTime.where.where(code=where).where.where(code=value).value dateTime'; END $$;
SELECT fhirpath_as_date(:resource, '.dateTime.where.where(code=where).where.where(code=value).value', 'dateTime' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .dateTime.where.where(code=where).where.where(code=array).array dateTime'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'date .instant.value instant'; END $$;
SELECT fhirpath_as_date(:resource, '.instant.value', 'instant' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .instant.array instant'; END $$;
SELECT fhirpath_as_date(:resource, '.instant.array', 'instant' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .instant.where.where(code=value).value instant'; END $$;
SELECT fhirpath_as_date(:resource, '.instant.where.where(code=value).value', 'instant' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .instant.where.where(code=array).array instant'; END $$;
SELECT fhirpath_as_date(:resource, '.instant.where.where(code=array).array', 'instant' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .instant.where.where(code=where).where.where(code=value).value instant'; END $$;
SELECT fhirpath_as_date(:resource, '.instant.where.where(code=where).where.where(code=value).value', 'instant' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .instant.where.where(code=where).where.where(code=array).array instant'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'date .time.value time'; END $$;
SELECT fhirpath_as_date(:resource, '.time.value', 'time' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .time.array time'; END $$;
SELECT fhirpath_as_date(:resource, '.time.array', 'time' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .time.where.where(code=value).value time'; END $$;
SELECT fhirpath_as_date(:resource, '.time.where.where(code=value).value', 'time' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .time.where.where(code=array).array time'; END $$;
SELECT fhirpath_as_date(:resource, '.time.where.where(code=array).array', 'time' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .time.where.where(code=where).where.where(code=value).value time'; END $$;
SELECT fhirpath_as_date(:resource, '.time.where.where(code=where).where.where(code=value).value', 'time' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .time.where.where(code=where).where.where(code=array).array time'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'date .Period.value Period'; END $$;
SELECT fhirpath_as_date(:resource, '.Period.value', 'Period' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Period.array Period'; END $$;
SELECT fhirpath_as_date(:resource, '.Period.array', 'Period' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Period.where.where(code=value).value Period'; END $$;
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=value).value', 'Period' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Period.where.where(code=array).array Period'; END $$;
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=array).array', 'Period' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Period.where.where(code=where).where.where(code=value).value Period'; END $$;
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=where).where.where(code=value).value', 'Period' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Period.where.where(code=where).where.where(code=array).array Period'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'date .Timing.value Timing'; END $$;
SELECT fhirpath_as_date(:resource, '.Timing.value', 'Timing' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Timing.array Timing'; END $$;
SELECT fhirpath_as_date(:resource, '.Timing.array', 'Timing' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Timing.where.where(code=value).value Timing'; END $$;
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=value).value', 'Timing' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Timing.where.where(code=array).array Timing'; END $$;
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=array).array', 'Timing' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Timing.where.where(code=where).where.where(code=value).value Timing'; END $$;
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=where).where.where(code=value).value', 'Timing' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'date .Timing.where.where(code=where).where.where(code=array).array Timing'; END $$;
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=where).where.where(code=array).array', 'Timing' , 'max');
