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
DO language plpgsql $$ BEGIN RAISE info 'string .string.value string'; END $$;
SELECT fhirpath_as_string(:resource, '.string.value', 'string' );
DO language plpgsql $$ BEGIN RAISE info 'string .string.array string'; END $$;
SELECT fhirpath_as_string(:resource, '.string.array', 'string' );
DO language plpgsql $$ BEGIN RAISE info 'string .string.where.where(code=value).value string'; END $$;
SELECT fhirpath_as_string(:resource, '.string.where.where(code=value).value', 'string' );
DO language plpgsql $$ BEGIN RAISE info 'string .string.where.where(code=array).array string'; END $$;
SELECT fhirpath_as_string(:resource, '.string.where.where(code=array).array', 'string' );
DO language plpgsql $$ BEGIN RAISE info 'string .string.where.where(code=where).where.where(code=value).value string'; END $$;
SELECT fhirpath_as_string(:resource, '.string.where.where(code=where).where.where(code=value).value', 'string' );
DO language plpgsql $$ BEGIN RAISE info 'string .string.where.where(code=where).where.where(code=array).array string'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'string .code.value code'; END $$;
SELECT fhirpath_as_string(:resource, '.code.value', 'code' );
DO language plpgsql $$ BEGIN RAISE info 'string .code.array code'; END $$;
SELECT fhirpath_as_string(:resource, '.code.array', 'code' );
DO language plpgsql $$ BEGIN RAISE info 'string .code.where.where(code=value).value code'; END $$;
SELECT fhirpath_as_string(:resource, '.code.where.where(code=value).value', 'code' );
DO language plpgsql $$ BEGIN RAISE info 'string .code.where.where(code=array).array code'; END $$;
SELECT fhirpath_as_string(:resource, '.code.where.where(code=array).array', 'code' );
DO language plpgsql $$ BEGIN RAISE info 'string .code.where.where(code=where).where.where(code=value).value code'; END $$;
SELECT fhirpath_as_string(:resource, '.code.where.where(code=where).where.where(code=value).value', 'code' );
DO language plpgsql $$ BEGIN RAISE info 'string .code.where.where(code=where).where.where(code=array).array code'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'string .id.value id'; END $$;
SELECT fhirpath_as_string(:resource, '.id.value', 'id' );
DO language plpgsql $$ BEGIN RAISE info 'string .id.array id'; END $$;
SELECT fhirpath_as_string(:resource, '.id.array', 'id' );
DO language plpgsql $$ BEGIN RAISE info 'string .id.where.where(code=value).value id'; END $$;
SELECT fhirpath_as_string(:resource, '.id.where.where(code=value).value', 'id' );
DO language plpgsql $$ BEGIN RAISE info 'string .id.where.where(code=array).array id'; END $$;
SELECT fhirpath_as_string(:resource, '.id.where.where(code=array).array', 'id' );
DO language plpgsql $$ BEGIN RAISE info 'string .id.where.where(code=where).where.where(code=value).value id'; END $$;
SELECT fhirpath_as_string(:resource, '.id.where.where(code=where).where.where(code=value).value', 'id' );
DO language plpgsql $$ BEGIN RAISE info 'string .id.where.where(code=where).where.where(code=array).array id'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'string .markdown.value markdown'; END $$;
SELECT fhirpath_as_string(:resource, '.markdown.value', 'markdown' );
DO language plpgsql $$ BEGIN RAISE info 'string .markdown.array markdown'; END $$;
SELECT fhirpath_as_string(:resource, '.markdown.array', 'markdown' );
DO language plpgsql $$ BEGIN RAISE info 'string .markdown.where.where(code=value).value markdown'; END $$;
SELECT fhirpath_as_string(:resource, '.markdown.where.where(code=value).value', 'markdown' );
DO language plpgsql $$ BEGIN RAISE info 'string .markdown.where.where(code=array).array markdown'; END $$;
SELECT fhirpath_as_string(:resource, '.markdown.where.where(code=array).array', 'markdown' );
DO language plpgsql $$ BEGIN RAISE info 'string .markdown.where.where(code=where).where.where(code=value).value markdown'; END $$;
SELECT fhirpath_as_string(:resource, '.markdown.where.where(code=where).where.where(code=value).value', 'markdown' );
DO language plpgsql $$ BEGIN RAISE info 'string .markdown.where.where(code=where).where.where(code=array).array markdown'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'string .HumanName.value HumanName'; END $$;
SELECT fhirpath_as_string(:resource, '.HumanName.value', 'HumanName' );
DO language plpgsql $$ BEGIN RAISE info 'string .HumanName.array HumanName'; END $$;
SELECT fhirpath_as_string(:resource, '.HumanName.array', 'HumanName' );
DO language plpgsql $$ BEGIN RAISE info 'string .HumanName.where.where(code=value).value HumanName'; END $$;
SELECT fhirpath_as_string(:resource, '.HumanName.where.where(code=value).value', 'HumanName' );
DO language plpgsql $$ BEGIN RAISE info 'string .HumanName.where.where(code=array).array HumanName'; END $$;
SELECT fhirpath_as_string(:resource, '.HumanName.where.where(code=array).array', 'HumanName' );
DO language plpgsql $$ BEGIN RAISE info 'string .HumanName.where.where(code=where).where.where(code=value).value HumanName'; END $$;
SELECT fhirpath_as_string(:resource, '.HumanName.where.where(code=where).where.where(code=value).value', 'HumanName' );
DO language plpgsql $$ BEGIN RAISE info 'string .HumanName.where.where(code=where).where.where(code=array).array HumanName'; END $$;
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
DO language plpgsql $$ BEGIN RAISE info 'string .Address.value Address'; END $$;
SELECT fhirpath_as_string(:resource, '.Address.value', 'Address' );
DO language plpgsql $$ BEGIN RAISE info 'string .Address.array Address'; END $$;
SELECT fhirpath_as_string(:resource, '.Address.array', 'Address' );
DO language plpgsql $$ BEGIN RAISE info 'string .Address.where.where(code=value).value Address'; END $$;
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=value).value', 'Address' );
DO language plpgsql $$ BEGIN RAISE info 'string .Address.where.where(code=array).array Address'; END $$;
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=array).array', 'Address' );
DO language plpgsql $$ BEGIN RAISE info 'string .Address.where.where(code=where).where.where(code=value).value Address'; END $$;
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=where).where.where(code=value).value', 'Address' );
DO language plpgsql $$ BEGIN RAISE info 'string .Address.where.where(code=where).where.where(code=array).array Address'; END $$;
SELECT fhirpath_as_string(:resource, '.Address.where.where(code=where).where.where(code=array).array', 'Address' );
