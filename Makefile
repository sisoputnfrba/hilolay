UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	CFLAGS := -D_XOPEN_SOURCE -Wno-deprecated-declarations
endif

CC := gcc
MAJOR := 0
MINOR := 1
NAME := hilolay
VERSION := $(MAJOR).$(MINOR)
SRC=src
DEST=bin
TEST=test
###########

all: clean hilolay.so

clean:
	$(RM) *.o
	$(RM) simple
	$(RM) *.so
	$(RM) -r bin/
	mkdir -p bin

hilolay.o:
	gcc -c -Wall $(CFLAGS) -fpic hilolay.c -o bin/hilolay.o

hilolay.so: hilolay.o
	gcc -shared -o bin/libhilolay.so bin/hilolay.o

test: clean simple

simple: hilolay.so
	gcc -L./bin/ -Wall $(CFLAGS) -o bin/simple simple-example.c -lhilolay
	./bin/simple