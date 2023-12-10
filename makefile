# Makefile for Hash Generator

CC = gcc
CFLAGS = -Wall -Wextra

all: hash

hash_generator: hash.c
	$(CC) $(CFLAGS) -o hash hash.c
clean:	rm -f hash
