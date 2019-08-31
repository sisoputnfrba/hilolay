all:
	make clean
	make hilolay

clean:
	mkdir -p bin/
	rm -rf bin

hilolay:
	mkdir -p bin/
	gcc -c -Wall -Werror -fpic -o bin/hilolay.o src/hilolay.c 
	gcc -shared -fpic -o bin/hilolay.so bin/hilolay.o -lc	

install:
	echo "install: Not implemented yet"
