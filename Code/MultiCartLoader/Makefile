NAME := multicartldr
VERSION := 0.9

TITLE := MULTICARTLDR
ROMVERSION := 0x10

FILLER = 0x00

ifneq ($(wildcard rgbds/.*),)
RGBDS_DIR = rgbds/
else
RGBDS_DIR =
endif

RGBASM_FLAGS =
RGBLINK_FLAGS = -n $(ROM_NAME).sym -m $(ROM_NAME).map -p $(FILLER)
RGBFIX_FLAGS = -jcv -t $(TITLE) -n $(ROMVERSION) -p $(FILLER) -k 00 -l 0x33 -m 0x1B -r 0x04

CFLAGS = -O3 -std=c11 -Wall -Wextra -pedantic

.SUFFIXES:
.PHONY: all clean ldr
.SECONDEXPANSION:
.PRECIOUS: %.o

CC     = gcc
RM     = rm -f

ldr_obj := main.o 

all: ldr

ldr: FILLER = 0x00
ldr: ROM_NAME = $(NAME)-$(VERSION)
ldr: $(NAME)-$(VERSION).gb

clean:
	$(RM) $(ldr_obj) $(wildcard $(NAME)-*.gb) $(wildcard $(NAME)-*.map) $(wildcard $(NAME)-*.sym)

%.o: %.asm
	$(RGBDS_DIR)rgbasm $(RGBASM_FLAGS) -o $@ $<

.gb:
%.gb: $(ldr_obj)
	$(RGBDS_DIR)rgblink $(RGBLINK_FLAGS) -o $@ $^
	$(RGBDS_DIR)rgbfix $(RGBFIX_FLAGS) $@
