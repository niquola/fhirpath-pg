fp: fhirpath.l fhirpath.y fhirpath.h
	bison -d fhirpath.y
	flex -ofhirpath.lex.c fhirpath.l
	cc -o fhirpath fhirpath.tab.c fhirpath.lex.c main.c
clean:
	rm -f fhirpath.lex.c fhirpath.tab.c fhirpath.tab.h fhirpath
