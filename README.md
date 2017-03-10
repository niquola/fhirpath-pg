# fhirpath

[![Build Status](https://travis-ci.org/niquola/fhirpath-pg.svg?branch=master)](https://travis-ci.org/niquola/fhirpath-pg)


Native implementation of Fhirpath/Fluentpath for postgresql.


## Development


```sh
git clone https://github.com/postgres/postgres
./configure --with-bonjour --prefix=/opt/local/pg
make
sudo make install

export PGDATA=/tmp/pg
export PGPORT=5777\n
export PG_BIN=/opt/local/pg/bin\n
bin/initdb -D $PGDATA -E utf8
vim /tmp/pg/postgresql.conf # check port configure log /tmp/pg.log
/opt/local/pg/bin/pg_ctl start -D $PGDATA

cd postgres && src/tools/make_etags
cd postgres/src/contrib
git clone https://github.com/niquola/fhirpath-pg
cd fhirpath-pg
..postgres/src/tools/make_etags .

make && sudo make install  && make installcheck

tail -f /tmp/pg.log
````


## How jsonb works.

See:
* jsonb.h

Jsonb is the on-disk representation, in contrast to the in-memory JsonbValue
representation.  Often, JsonbValues are just shims through which a Jsonb
buffer is accessed, but they can also be deep copied and passed around.

Jsonb is a tree structure. Each node in the tree consists of a JEntry
header and a variable-length content (possibly of zero size).  The JEntry
header indicates what kind of a node it is, e.g. a string or an array,
and provides the length of its variable-length portion.

```
enum jbvType
{
	/* Scalar types */
	jbvNull = 0x0,
	jbvString,
	jbvNumeric,
	jbvBool,
	/* Composite types */
	jbvArray = 0x10,
	jbvObject,
	/* Binary (i.e. struct Jsonb) jbvArray/jbvObject */
	jbvBinary
};
  
struct JsonbValue
{
	enum jbvType	type;			/* Influences sort order */

	union
	{
		Numeric numeric;
		bool		boolean;
		struct
		{
			int			len;
			char	   *val;	/* Not necessarily null-terminated */
		}			string;		/* String primitive type */

		struct
		{
			int			nElems;
			JsonbValue *elems;
			bool		rawScalar;		/* Top-level "raw scalar" array? */
		}			array;		/* Array container type */

		struct
		{
			int			nPairs; /* 1 pair, 2 elements */
			JsonbPair  *pairs;
		}			object;		/* Associative container type */

		struct
		{
			int			len;
			JsonbContainer *data;
		}			binary;		/* Array or object, in on-disk format */
	}			val;
};

  
```

The JEntry and the content of a node are not stored physically together.
Instead, the container array or object has an array that holds the JEntrys
of all the child nodes, followed by their variable-length portions.

The root node is an exception; it has no parent array or object that could
hold its JEntry. Hence, no JEntry header is stored for the root node.  It
is implicitly known that the root node must be an array or an object,
so we can get away without the type indicator as long as we can distinguish
the two.  For that purpose, both an array and an object begin with a uint32
header field, which contains an JB_FOBJECT or JB_FARRAY flag.  When a naked
scalar value needs to be stored as a Jsonb value, what we actually store is
an array with one element, with the flags in the array's header field set
to JB_FSCALAR | JB_FARRAY.

Overall, the Jsonb struct requires 4-bytes alignment. Within the struct,
the variable-length portion of some node types is aligned to a 4-byte
boundary, while others are not. When alignment is needed, the padding is
in the beginning of the node that requires it. For example, if a numeric
node is stored after a string node, so that the numeric node begins at
offset 3, the variable-length portion of the numeric node will begin with
one padding byte so that the actual numeric data is 4-byte aligned.

```
typedef uint32 JEntry;

#define JENTRY_OFFLENMASK		0x0FFFFFFF
#define JENTRY_TYPEMASK			0x70000000
#define JENTRY_HAS_OFF			0x80000000

/* values stored in the type bits */
#define JENTRY_ISSTRING			0x00000000
#define JENTRY_ISNUMERIC		0x10000000
#define JENTRY_ISBOOL_FALSE		0x20000000
#define JENTRY_ISBOOL_TRUE		0x30000000
#define JENTRY_ISNULL			0x40000000
#define JENTRY_ISCONTAINER		0x50000000		/* array or object */

/*
 * A jsonb array or object node, within a Jsonb Datum.
 *
 * An array has one child for each element, stored in array order.
 *
 * An object has two children for each key/value pair.  The keys all appear
 * first, in key sort order; then the values appear, in an order matching the
 * key order.  This arrangement keeps the keys compact in memory, making a
 * search for a particular key more cache-friendly.
 */
typedef struct JsonbContainer
{
	uint32		header;			/* number of elements or key/value pairs, and
								 * flags */
	JEntry		children[FLEXIBLE_ARRAY_MEMBER];

	/* the data for each child node follows. */
} JsonbContainer;

typedef struct
{
    int32		vl_len_;		/* varlena header (do not touch directly!) */
    JsonbContainer root;
} Jsonb;
/* convenience macros for accessing the root container in a Jsonb datum */
#define JB_ROOT_COUNT(jbp_)		( *(uint32*) VARDATA(jbp_) & JB_CMASK)
#define JB_ROOT_IS_SCALAR(jbp_) ( *(uint32*) VARDATA(jbp_) & JB_FSCALAR)
#define JB_ROOT_IS_OBJECT(jbp_) ( *(uint32*) VARDATA(jbp_) & JB_FOBJECT)
#define JB_ROOT_IS_ARRAY(jbp_)	( *(uint32*) VARDATA(jbp_) & JB_FARRAY)
  
```


## HL7v2 binary datatype

len
msh:.......
segments index
segments....

MSH|ADT,08|....
PID|xxx|....

* small & searchable bla, bla
* select insert


select 
  m->'pid.5'
where
  m->'pid.8' > '1980'::date



### UCUM impl

'number|units' -> 'units'
