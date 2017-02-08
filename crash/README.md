# Search crash test

## Run

``` bash
./crash.sh > crash.sql
psql -f crash.sql
```


## Search Parameter Types

| Data Type        | number   | date     | string   | token    | reference | quantity | uri      | composite |
| -                |          |          |          |          |           |          |          |           |
| __Primitive__    | -------- | -------- | -------- | -------- | --------  | -------- | -------- | --------  |
| boolean          |          |          |          | Y        |           |          |          |           |
| code             |          |          |          | Y        |           |          |          |           |
| time             |          | Y        |          |          |           |          |          |           |
| date             |          | Y        |          |          |           |          |          |           |
| dateTime         |          | Y        |          |          |           |          |          |           |
| instant          |          | Y        |          |          |           |          |          |           |
| decimal          | Y        |          |          |          |           |          |          |           |
| integer          | Y        |          |          |          |           |          |          |           |
| _unsignedInt_    | Y        |          |          |          |           |          |          |           |
| _positiveInt_    | Y        |          |          |          |           |          |          |           |
| string           |          |          | Y        | Y        |           |          |          |           |
| _code_           |          |          | Y        |          |           |          |          |           |
| _id_             |          |          | Y        |          |           |          |          |           |
| _markdown_       |          |          | Y        |          |           |          |          |           |
| uri              |          |          |          |          | Y         |          | Y        |           |
| _oid_            |          |          |          |          |           |          | Y        |           |
| __Complex__      | -------- | -------- | -------- | -------- | --------  | -------- | -------- | --------  |
| Ratio            |          |          |          |          |           |          |          |           |
| Period           |          | Y        |          |          |           |          |          |           |
| Range            |          |          |          |          |           |          |          |           |
| Attachment       |          |          |          |          |           |          |          |           |
| Identifier       |          |          |          | Y        |           |          |          |           |
| Timing           |          | Y        |          |          |           |          |          |           |
| HumanName        |          |          | Y        |          |           |          |          |           |
| Coding           |          |          |          | Y        |           |          |          |           |
| Annotation       |          |          |          |          |           |          |          |           |
| Signature        |          |          |          |          |           |          |          |           |
| Address          |          |          | Y        |          |           |          |          |           |
| CodeableConcept  |          |          |          | Y        |           |          |          |           |
| Quantity         | Y        |          |          |          |           | Y        |          |           |
| _Age_            | Y        |          |          |          |           |          |          |           |
| _Distance_       | Y        |          |          |          |           |          |          |           |
| _SimpleQuantity_ | Y        |          |          |          |           |          |          |           |
| _Duration_       | Y        |          |          |          |           |          |          |           |
| _Count_          | Y        |          |          |          |           |          |          |           |
| _Money_          | Y        |          |          |          |           |          |          |           |
| SampledData      |          |          |          |          |           |          |          |           |
| ContactPoint     |          |          |          | Y        |           |          |          |           |
| Reference        |          |          |          |          | Y         |          |          |           |





## Types


## Paths



## Error types

 * Wrong path
    * Element on the end of path __does not exists__
    * Element on the end of path exists __but wrong type__
 * Wrong search
