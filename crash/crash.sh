#!/bin/bash
set -e

RESOURCE='{
	"number":{"value": 42,
						"array": [40, 42, 43]},

	"date": {"value": "1980-02-05T08:30" ,
					 "array": ["1980-02-05T08:30", "1976-01", "1952-02-03"]},

	"string": {"value": "Test",
						 "array": ["Test", "Crush", "Fhirpath"]},

	"token": {"value": {"use": "usual",
											"type": { "coding": [
												{"system": "sys1", "code": "code1"},
												{"system": "sys2", "code": "code2"}
											]},
											"system": "isys",
											"value": "value1",
											"period": {"start": "2001-05-06"},
											"assigner": {"display": "Acme Healthcare"} },
					 "array": [ {"use": "usual",
										 	 "type": { "coding": [
													{"system": "sys1", "code": "code1"},
													{"system": "sys2", "code": "code2"} ]},
											 "system": "isys",
											 "value": "value1",
											 "period": {"start": "2001-05-06"},
											 "assigner": {"display": "Acme Healthcare"}
											}, {
											 "use": "official",
											 "type": { "coding": [ {
													"system": "itsys", "code": "itcode"}
									 			]},
											 "system": "isys2",
											 "value": "ival2" }]},

	"reference": {"value": {"reference": "http://dom.io/ups/Patient/1"},
								"array": [{"reference": "http://dom.io/ups/Patient/1"},
													{"reference": "http://dom.io/ups/Patient/1"}]},
	"composite": {},
	"quantity": {},
	"uri": {},
	"_empty_obj": {},
	"_empty_arr": [],
	"_empty_str": ""
}'

#SEARCH_TYPES=(date number reference string token uri quantity)
SEARCH_TYPES=(date number reference string token)
PRIMITIVE_DATA_TYPES=(integer decimal unsignedInt positiveInt instant time date dateTime boolean string code id markdown uri oid base64Binary)
COMPLEX_DATA_TYPES=(Ratio SampledData Period Quantity Age Distance SimpleQuantity Duration Count Money Attachment Range Coding CodeableConcept HumanName Address ContactPoint Identifier Timing Signature Annotation)
DATA_TYPES=("${PRIMITIVE_DATA_TYPES[@]}" "${COMPLEX_DATA_TYPES[@]}")



PATHS=(._empty_obj ._empty_str ._empty_arr .undefined)
for p in "${SEARCH_TYPES[@]}"
do
	PATHS+=(".$p.value")
	PATHS+=(".$p.array")
done


function mk_query() {
	local SEARCH_TYPE=$1
	local PTH=$2
  local	DATA_TYPE=$3
	local MODIFICATION=""

	if [ -n "$4" ]
	then
		MODIFICATION=", '$4'"
	fi

  echo "SELECT fhirpath_as_$SEARCH_TYPE('$RESOURCE', '$PTH', '$DATA_TYPE' $MODIFICATION);"
}

function error_generator () {
	local PATH_PREFIX=$1
	echo $PATH_PREFIX
}

for st in "${SEARCH_TYPES[@]}"
do
	for dt in "${DATA_TYPES[@]}"
	do
		for p in "${PATHS[@]}"
		do
			if [ "$st" == number ] || [ "$st" == date ]
			then
				SQL=$(mk_query $st $p $dt "min")
			else
				SQL=$(mk_query $st $p $dt)
			fi
			echo $SQL
		done
	done
done
