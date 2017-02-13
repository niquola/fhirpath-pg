select '''{
  "uri":{
    "value": "http://some.url",
    "array": ["http://datypic.com", "mailto:info@datypic.com","../%C3%A9dition.html","http://datypic.com/prod.html#shirt","urn:example:org","../édition.html"],
    "where": [{ "code": "value", "value": "http://some.url" },
              { "code": "array", "array": ["http://datypic.com", "mailto:info@datypic.com","../%C3%A9dition.html","http://datypic.com/prod.html#shirt","urn:example:org","../édition.html"] },
              { "code": "where",
                "where": [ {"code": "value", "value": "http://some.url"},
                           {"code": "array", "array": ["http://datypic.com", "mailto:info@datypic.com","../%C3%A9dition.html","http://datypic.com/prod.html#shirt","urn:example:org","../édition.html"]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_reference(:resource, '.uri.value', 'uri' );
SELECT fhirpath_as_reference(:resource, '.uri.array', 'uri' );
SELECT fhirpath_as_reference(:resource, '.uri.where.where(code=value).value', 'uri' );
SELECT fhirpath_as_reference(:resource, '.uri.where.where(code=array).array', 'uri' );
SELECT fhirpath_as_reference(:resource, '.uri.where.where(code=where).where.where(code=value).value', 'uri' );
SELECT fhirpath_as_reference(:resource, '.uri.where.where(code=where).where.where(code=array).array', 'uri' );
select '''{
  "Reference":{
    "value": {"reference": "http://some.url", "display":"display"},
    "array": [
{"reference": "http://datypic.com", "display":"display"}, {"reference": "mailto:info@datypic.com", "display":"display"},
{"reference": "../%C3%A9dition.html", "display": "display"},
{"reference": "http://datypic.com/prod.html#shirt", "display": "display"},
{"reference": "urn:example:org", "display": "display"}],
    "where": [{ "code": "value", "value": {"reference": "http://some.url", "display":"display"} },
              { "code": "array", "array": [
{"reference": "http://datypic.com", "display":"display"}, {"reference": "mailto:info@datypic.com", "display":"display"},
{"reference": "../%C3%A9dition.html", "display": "display"},
{"reference": "http://datypic.com/prod.html#shirt", "display": "display"},
{"reference": "urn:example:org", "display": "display"}] },
              { "code": "where",
                "where": [ {"code": "value", "value": {"reference": "http://some.url", "display":"display"}},
                           {"code": "array", "array": [
{"reference": "http://datypic.com", "display":"display"}, {"reference": "mailto:info@datypic.com", "display":"display"},
{"reference": "../%C3%A9dition.html", "display": "display"},
{"reference": "http://datypic.com/prod.html#shirt", "display": "display"},
{"reference": "urn:example:org", "display": "display"}]} ] } ] },
  "noise": "Some value"
}''' resource \gset
SELECT fhirpath_as_reference(:resource, '.Reference.value', 'Reference' );
SELECT fhirpath_as_reference(:resource, '.Reference.array', 'Reference' );
SELECT fhirpath_as_reference(:resource, '.Reference.where.where(code=value).value', 'Reference' );
SELECT fhirpath_as_reference(:resource, '.Reference.where.where(code=array).array', 'Reference' );
SELECT fhirpath_as_reference(:resource, '.Reference.where.where(code=where).where.where(code=value).value', 'Reference' );
SELECT fhirpath_as_reference(:resource, '.Reference.where.where(code=where).where.where(code=array).array', 'Reference' );
