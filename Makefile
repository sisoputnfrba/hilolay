#CFLAGS := -fPIC -O3 -g -Wall -Werror
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	CFLAGS := -D_XOPEN_SOURCE -Wno-deprecated-declarations
endif
ifeq ($(UNAME_S),Darwin)
	SONAME := -install_name
else
	SONAME := -soname
endif

CC := gcc
MAJOR := 0
MINOR := 1
NAME := hilolay
VERSION := $(MAJOR).$(MINOR)
SRC=src
DEST=bin
TEST=test

#lib: lib$(NAME).so.$(VERSION)

#test: $(NAME)_test
#	LD_LIBRARY_PATH=./bin/ ./$(NAME)_test

#simple: $(NAME).so
#	$(CC) -Wall -Werror -L./bin/ -l$(NAME) -o $(DEST)/$@ $(TEST)/simple.c

#$(NAME).so: $(NAME).so.$(VERSION)
	#ldconfig -v -n ./bin/
#	ln -s $(DEST)/$(NAME).so.$(MAJOR) $(DEST)/lib$(NAME).so

#$(NAME).so.$(VERSION): $(DEST)/$(NAME).o
#	$(CC) -shared -Wl,$(SONAME),$(DEST)/$(NAME).so.$(MAJOR) $^ -o $(DEST)/$@

#$(DEST)/$(NAME).o:
#	$(CC) -c $(CFLAGS) -o $(DEST)/$(NAME).o $(SRC)/$(NAME).c -include $(SRC)/$(NAME).h
	
all: clean hilolay test

test: hilolay
	gcc -Wall -Werror -Wextra -L. test/simple.c -lhilolay -o len
	
hilolay:
	gcc -fPIC -Wall -Werror -Wextra $(CFLAGS) src/hilolay.c -shared -o libhilolay.so
	
clean:
	mkdir -p $(DEST)
	$(RM) -r $(DEST)
	mkdir -p $(DEST)


	