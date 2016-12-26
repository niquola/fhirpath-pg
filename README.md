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
