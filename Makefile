UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	CFLAGS := -D_XOPEN_SOURCE -Wno-deprecated-declarations
endif

CC := gcc
MAJOR := 0
MINOR := 1
NAME := hilolay
VERSION := $(MAJOR).$(MINOR)
BUILD=bin

all: clean hilolay.so

clean:
	$(RM) *.o
	$(RM) simple
	$(RM) *.so
	$(RM) -r bin/
	mkdir -p bin

$(NAME).o:
	$(CC) -c -Wall $(CFLAGS) -fpic $(NAME).c -o $(BUILD)/$(NAME).o

$(NAME).so: $(NAME).o
	$(CC) -shared -o $(BUILD)/lib$(NAME).so $(BUILD)/$(NAME).o

### TESTS ###
example: $(NAME).so
	$(CC) -L./$(BUILD)/ -Wall $(CFLAGS) -o $(BUILD)/example example.c -l$(NAME)

test: clean example
	./$(BUILD)/example