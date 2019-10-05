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
	$(CC) -c -Wall $(CFLAGS) -fpic $(NAME)_internal.c -o $(BUILD)/$(NAME).o

$(NAME).so: $(NAME).o
	$(CC) -shared -o $(BUILD)/lib$(NAME).so $(BUILD)/$(NAME).o

install:
	mkdir -p /usr/local/include/hilolay/
	cp $(NAME)_internal.h /usr/local/include/hilolay/internal.h
	cp $(NAME).h /usr/local/include/hilolay/hilolay.h
	cp $(NAME)_alumnos.h /usr/local/include/hilolay/alumnos.h
	chmod 0755 /usr/local/include/hilolay/*
	cp $(BUILD)/lib$(NAME).so /usr/local/lib/lib$(NAME).so