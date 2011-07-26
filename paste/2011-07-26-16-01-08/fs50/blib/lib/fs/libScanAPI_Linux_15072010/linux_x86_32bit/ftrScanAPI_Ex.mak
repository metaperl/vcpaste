TARGET=ftrScanAPI_Ex

CC=gcc
CFLAGS=-Wall -O2 -I./       

#dynamic library
#LIBUSB_DLIB=/usr/local/lib/libusb.so -lstdc++
LIBUSB_DLIB=-lusb -lstdc++
FTRSCANAPI_DLIB=./libScanAPI.so

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $(TARGET) $(TARGET).c $(FTRSCANAPI_DLIB) $(LIBUSB_DLIB)

clean:
	rm -f $(TARGET)
