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
