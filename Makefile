OSFLAGS 				:=
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	OSFLAGS += -D_XOPEN_SOURCE -Wno-deprecated-declarations
endif

all:
	make clean
	make hilolay

clean:
	mkdir -p bin/
	rm -rf bin

hilolay:
	mkdir -p bin/
	gcc -c -Wall -Werror -fpic $(OSFLAGS) -o bin/hilolay.o src/hilolay.c 
	gcc -shared -fpic -o bin/hilolay.so bin/hilolay.o -lc

install:
	echo "install: Not implemented yet"
