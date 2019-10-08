UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	CFLAGS := -D_XOPEN_SOURCE -Wno-deprecated-declarations
endif

ifeq ($(UNAME_S),Darwin)
  USR_PATH := /usr/local
else
  USR_PATH := /usr
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
	mkdir -p $(USR_PATH)/include/hilolay/
	cp $(NAME)_internal.h $(USR_PATH)/include/hilolay/internal.h
	cp $(NAME).h $(USR_PATH)/include/hilolay/hilolay.h
	cp $(NAME)_alumnos.h $(USR_PATH)/include/hilolay/alumnos.h
	chmod 0755 $(USR_PATH)/include/hilolay/*
	cp $(BUILD)/lib$(NAME).so $(USR_PATH)/lib/lib$(NAME).so
