all: target

target: analyseur

analyseur-lexicale.c: spec.l
	flex -o analyseur-lexicale.c spec.l

analyseur: analyseur-lexicale.c
	gcc -o analyseur analyseur-lexicale.c -lfl

clean:
	rm -rf analyseur-lexicale.c analyseur