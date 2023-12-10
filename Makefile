all: target

target: build-directory compilateur.out

# ------

build-directory:
	mkdir -p build

clean-build-directory:
	rm -rf build

# ------

# rajouter un index.c pour le compilateur
# compilateur.out: compilateur.o
# 	gcc -o compilateur.out compilateur.o

# compilateur.o: analyseur-lexicale.o analyseur-syntaxique.o
# 	gcc -c -o compilateur.o analyseur-lexicale.o analyseur-syntaxique.o

compilateur.out: compilateur
	gcc -o compilateur.out analyseur-lexicale.o analyseur-syntaxique.o

compilateur: analyseur-lexicale.o analyseur-syntaxique.o

clean-compilateur:
	rm -rf compilateur.out

# ------

analyseur-lexicale.out: analyseur-lexicale.o
	gcc -o analyseur-lexicale.out analyseur-lexicale.o -lfl

analyseur-lexicale.o: analyseur-lexicale.c
	gcc -c -o analyseur-lexicale.o analyseur-lexicale.c -lfl

analyseur-lexicale.c: spec.l
	flex -do analyseur-lexicale.c spec.l

clean-analyseur-lexicale:
	rm -rf analyseur-lexicale.c
	rm -rf analyseur-lexicale.o
	rm -rf analyseur-lexicale.out

# ------

analyseur-syntaxique.out: analyseur-syntaxique.o
	gcc -o analyseur-syntaxique.out analyseur-syntaxique.o -lfl

analyseur-syntaxique.o: analyseur-syntaxique.c
	gcc -c -o analyseur-syntaxique.o analyseur-syntaxique.c

analyseur-syntaxique.c: spec.y
	yacc -ly -o analyseur-syntaxique.c spec.y
# yacc -v -d -ly -o analyseur-syntaxique.c spec.y

clean-analyseur-syntaxique:
	rm -rf analyseur-syntaxique.c
	rm -rf analyseur-syntaxique.o
	rm -rf analyseur-syntaxique.out
	rm -rf analyseur-syntaxique.h
	rm -rf analyseur-syntaxique.output

# ------

clean: clean-analyseur-lexicale clean-analyseur-syntaxique clean-compilateur clean-build-directory