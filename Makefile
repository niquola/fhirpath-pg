# contrib/fhirpath/Makefile

MODULE_big = fhirpath
OBJS = fhirpath.o fhirpath_gram.o fhirpath_support.o fhirpath_jsonb.o

EXTENSION = fhirpath
DATA = fhirpath--1.0.sql

REGRESS = fhirpath to_string to_token to_reference to_number to_date
# We need a UTF8 database
ENCODING = UTF8

EXTRA_CLEAN = fhirpath_gram.c fhirpath_gram.o fhirpath_scan.c fhirpath_gram.h

ifdef USE_PGXS
PG_CONFIG ?= pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/fhirpath
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif

fhirpath_gram.o: fhirpath_scan.c

fhirpath_gram.c: BISONFLAGS += -d

distprep: fhirpath_gram.c fhirpath_scan.c

maintainer-clean:
	rm -f fhirpath_gram.c fhirpath_scan.c fhirpath_gram.h
