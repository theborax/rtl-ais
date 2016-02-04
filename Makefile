CFLAGS?=-O2 -g -Wall -W 
CFLAGS+= -I./aisdecoder -I ./aisdecoder/lib
LDFLAGS+=-lpthread -lm

UNAME := $(shell uname)
ifeq ($(UNAME),Linux)
#Conditional for Linux
CFLAGS+= $(shell pkg-config --cflags librtlsdr json-c)
LDFLAGS+=$(shell pkg-config --libs librtlsdr json-c) -lcurl

else
#
#ADD THE CORRECT PATH FOR LIBUSB AND RTLSDR
#TODO:
#    CMAKE will be much better or create a conditional pkg-config


# RTLSDR
RTLSDR_INCLUDE=/tmp/rtl-sdr/include
RTLSDR_LIB=/tmp/rtl-sdr/build/src

# LIBUSB
LIBUSB_INCLUDE=/tmp/libusb/include/libusb-1.0
LIBUSB_LIB=/tmp/libusb/lib


ifeq ($(UNAME),Darwin)
#Conditional for OSX
CFLAGS+= -I/usr/local/include/ -I$(LIBUSB_INCLUDE) -I$(RTLSDR_INCLUDE)
LDFLAGS+= -L/usr/local/lib -L$(LIBUSB_LIB) -L$(RTLSDR_LIB) -lrtlsdr -lusb-1.0 
else
#Conditional for Windows
CFLAGS+=-I $(LIBUSB_INCLUDE) -I $(RTLSDR_INCLUDE)
LDFLAGS+=-L$(LIBUSB_INCLUDE) -L$(RTLSDR_LIB) -L/usr/lib -lusb-1.0 -lrtlsdr -lWs2_32
endif


endif

CC?=gcc
SOURCES= \
	rtl_ais.c convenience.c rest.c \
	./aisdecoder/aisdecoder.c \
	./aisdecoder/sounddecoder.c \
	./aisdecoder/lib/receiver.c \
	./aisdecoder/lib/protodec.c \
	./aisdecoder/lib/hmalloc.c \
	./aisdecoder/lib/filter.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=rtl_ais

all: $(SOURCES) $(EXECUTABLE)
    
$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)

.c.o:
	$(CC) -c $< -o $@ $(CFLAGS)

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)
