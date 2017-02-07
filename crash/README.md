# Search crash test

## Run

``` bash
./crash.sh > crash.sql
psql -f crash.sql
```


## Search Parameter Types


URI - not supported  (partially as String)

P - Possible search (logically faithful)
S - Supported search (awaliable for search)


| Data Type        | + Number | + Date | + String | + Token | + Reference | - Composite | - Quantity | - URI (same as sting) |
| --               | --       | -      | -        | -       | -           | -           | -          | -     |
| __Primitive__    | -        | --     | --       | --      | --          | --          | --         | --    |
| boolean          |          |        |          |         |             |             |            |       |
| instant          |          | PS     |          |         |             |             |            |       |
| time             |          | PS     |          |         |             |             |            |       |
| date             |          | PS     |          |         |             |             |            |       |
| dateTime         |          | PS     |          |         |             |             |            |       |
| decimal          | PS       |        |          |         |             |             |            |       |
| integer          | PS       |        |          |         |             |             |            |       |
| unsignedInt      | PS       |        |          |         |             |             |            |       |
| positiveInt      | PS       |        |          |         |             |             |            |       |
| string           |          |        | PS       |         |             |             |            |       |
| _code_           |          |        | PS       |         |             |             |            |       |
| _id_             |          |        | PS       |         |             |             |            |       |
| markdown         |          |        | PS       |         |             |             |            |       |
| uri              |          |        |          |         |             |             |            | PS    |
| _oid_            |          |        |          |         |             |             |            | PS    |
| base64Binary     |          |        |          |         |             |             |            | -     |
| __Complex__      | --       | --     | --       | --      | --          | --          | --         | --    |
| Period           | -        |        |          |         |             |             |            |       |
| SampledData      |          |        |          |         |             |             |            |       |
| Ratio            | P        |        |          |         |             |             |            |       |
| Quantity         | P        |        |          |         |             |             |            |       |
| _Age_            | P        |        |          |         |             |             |            |       |
| _Distance_       | P        |        |          |         |             |             |            |       |
| _SimpleQuantity_ | P        |        |          |         |             |             |            |       |
| _Duration_       | P        |        |          |         |             |             |            |       |
| _Count_          | P        |        |          |         |             |             |            |       |
| _Money_          | P        |        |          |         |             |             |            |       |
| Range            | P        |        |          |         |             |             |            |       |
| Attachment       |          |        |          |         |             |             |            |       |
| Coding           |          |        |          |         |             |             |            |       |
| CodeableConcept  |          |        |          |         |             |             |            |       |
| HumanName        |          | PS     |          |         |             |             |            |       |
| Address          |          |        |          |         |             |             |            |       |
| ContactPoint     |          |        |          |         |             |             |            |       |
| Identifier       |          |        |          |         |             |             |            |       |
| Timing           |          |        |          |         |             |             |            |       |
| Signature        |          | P      |          |         |             |             |            |       |
| Annotation       |          | P      | P        |         |             |             |            |       |




## Types


## Paths



## Error types

 * Wrong path
    * Element on the end of path __does not exists__
    * Element on the end of path exists __but wrong type__
 * Wrong search
