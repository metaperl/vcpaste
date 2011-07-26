TARGET=gtk_ex

FTRSCANL_DLIB=./libScanAPI.so

CC=gcc

# GTK 2.0+
LDLIBS=`pkg-config gtk+-2.0 --libs gthread-2.0` -lstdc++
CFLAGS=-Wall -D_UNIX -I./ `pkg-config gtk+-2.0 gthread-2.0 --cflags`       

all: $(TARGET)

$(TARGET): $(TARGET).o
	$(CC) $(LDLIBS) $(TARGET).o -o $(TARGET) -I./ $(FTRSCANL_DLIB)

$(TARGET).o: $(TARGET).c
	$(CC) $(CFLAGS) -c $(TARGET).c

clean:
	rm -f $(TARGET)
	rm -f $(TARGET).o
