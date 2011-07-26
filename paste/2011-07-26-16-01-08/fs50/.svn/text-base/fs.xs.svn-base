#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "const-c.inc"

#ifdef WIN32
  #define WINDOWS
#else
  #define LINUX
#endif

#include "ftrScanAPI.h"
#ifdef WINDOWS
  #include <windows.h>
#else
  #include <stdlib.h>
  #include <string.h>
  #include <stdio.h>
  #include <ctype.h>
  #include <assert.h>
  #include <malloc.h>
  #define WIN32_LEAN_AND_MEAN
  #include <wine/windows/windows.h>
#endif

int imagebuffersize = 1048576;

unsigned char globalimage[1048576];
unsigned char globaltempimage[1048576];

FTRHANDLE hDevice;
FTRSCAN_IMAGE_SIZE ImageSize;

void rotate_and_invert (unsigned char * original, unsigned char * new,int width, int height)
{
	int x,y;
	int bx, by;

	for (by=0; by<height; by+=8)
	for (bx=0; bx<width; bx+=8)
	for (y=0; y<8; y++)
	for (x=0; x<8; x++)
	*(new + (width * (by + y)) + (bx + x)) = ~*(original + ((height * width) - (width * (by + y) - bx - x)));
}

int convert_to_bitmap(unsigned char * image, unsigned char * bitmapimage, BITMAPINFO * Info,unsigned char * tempimage)
{
	BITMAPFILEHEADER header;
	int i;
	unsigned int basesize;
	
	header.bfOffBits = 1078;
	header.bfReserved1 = 0;
	header.bfReserved2 = 0;
	header.bfSize = 1078 + ImageSize.nImageSize;
	header.bfType = (unsigned short)(('M'<<8) | 'B');
	
	for(i=0;i<256;i++)
	{
		Info->bmiColors[i].rgbBlue = i;
		Info->bmiColors[i].rgbRed = i;
		Info->bmiColors[i].rgbGreen = i;
		Info->bmiColors[i].rgbReserved = 0;
	}
	Info->bmiHeader.biBitCount = 8;
	Info->bmiHeader.biClrImportant = 0;
	Info->bmiHeader.biClrUsed = 0;
	Info->bmiHeader.biCompression = 0;
	Info->bmiHeader.biHeight = ImageSize.nHeight;
	Info->bmiHeader.biPlanes = 1;
	Info->bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	Info->bmiHeader.biSizeImage = ImageSize.nImageSize;
	Info->bmiHeader.biWidth = ImageSize.nWidth;
	Info->bmiHeader.biXPelsPerMeter = 0;
	Info->bmiHeader.biYPelsPerMeter = 0;
	
	rotate_and_invert(image,tempimage,ImageSize.nWidth,ImageSize.nHeight);
	
	memcpy((unsigned char *) bitmapimage,(unsigned char *) &header,14);
	memcpy((unsigned char *) bitmapimage + sizeof(header),(unsigned char *) Info,1064);
	memcpy((unsigned char *) bitmapimage + 1078,(unsigned char *) tempimage,ImageSize.nImageSize);
	
	return(14 + 1064 + ImageSize.nImageSize);
}


MODULE = fs		PACKAGE = fs		

INCLUDE: const-xs.inc

## int ftrScanOpenDevice
int
ftrScanOpenDevice()
	PREINIT:
		int ret;
	CODE:
		hDevice = ftrScanOpenDevice();
		if(hDevice == NULL) { ret = 1; }
		else { ret = 0; }
		if(ret == 0) { ftrScanGetImageSize(hDevice,&ImageSize); }
		RETVAL = ret;
	OUTPUT:
		RETVAL

## int ftrScanCloseDevice
int
ftrScanCloseDevice()
	CODE:
		ftrScanCloseDevice(hDevice);
	OUTPUT:
		RETVAL

## int ftrScanSetDiodesStatus
int
ftrScanSetDiodesStatus(int green, int red)
	PREINIT:
		int ret;
	CODE:
		ret = ftrScanSetDiodesStatus(hDevice,green,red);
		RETVAL = ret;
	OUTPUT:
		RETVAL

## SV * ftrScanGetSerialNumber
SV *
ftrScanGetSerialNumber()
	PREINIT:
		int ret;
		char * serialnum;
	CODE:
		Newxz(serialnum,9,void);
		if(serialnum == NULL) { XSRETURN_UNDEF; }
		ret = ftrScanGetSerialNumber(hDevice,serialnum);
		if(ret != 1) { XSRETURN_UNDEF; }
 		RETVAL = newSVpv(serialnum,0);
 		Safefree(serialnum);
 	OUTPUT:
 		RETVAL

## int ftrScanIsFingerPresent
int
ftrScanIsFingerPresent()
	PREINIT:
		int ret;
	CODE:
		ret = ftrScanIsFingerPresent(hDevice,NULL);
		RETVAL = ret;
	OUTPUT:
		RETVAL

## long ftrScanSetOptions
long
ftrScanSetOptions(long option)
	PREINIT:
		int ret;
	CODE:
		ret = ftrScanSetOptions(hDevice,option,option);
		if(ret == 0) { RETVAL = GetLastError(); }
		else { RETVAL = ret; }
	OUTPUT:
		RETVAL

## long ftrScanGetOptions
long
ftrScanGetOptions()
	PREINIT:
		int ret;
		long options;
	CODE:
		ret = ftrScanGetOptions(hDevice,&options);
		if(ret == 0) { RETVAL = GetLastError(); }
		else { RETVAL = options; }
	OUTPUT:
		RETVAL

## int ftrScanGetFrame()
int
ftrScanGetFrame()
	PREINIT:
		int ret;
	CODE:
		
		ret = ftrScanGetFrame(hDevice,globaltempimage,NULL);
		if(ret != 1) { XSRETURN_UNDEF; }
		memcpy((unsigned char *) &globalimage,(unsigned char *) &globaltempimage,imagebuffersize);
		RETVAL = ret;
 	OUTPUT:
 		RETVAL
 
SV *
ftrScanGetBitmap()
	PREINIT:
		unsigned char * bitmapimage;
		unsigned char * tempimage;
		BITMAPINFO * Info;
		int size;
	CODE:
		Newxz(bitmapimage,1048576,unsigned char);
		Newxz(tempimage,1048576,unsigned char);
		Newxz(Info,1064,BITMAPINFO);
		
		size = convert_to_bitmap(globalimage,bitmapimage,Info,tempimage);
 		RETVAL = newSVpv(bitmapimage,size);
		Safefree(bitmapimage);
		Safefree(tempimage);
		Safefree(Info);
 	OUTPUT:
 		RETVAL

## void ftrScanGetImageSize
void
ftrScanGetImageSize()
	PPCODE:
		EXTEND(SP, 3);
 		PUSHs(sv_2mortal(newSViv(ImageSize.nWidth)));
 		PUSHs(sv_2mortal(newSViv(ImageSize.nHeight)));
 		PUSHs(sv_2mortal(newSViv(ImageSize.nImageSize)));

## int ftrScanStatusDevice()
int
ftrScanStatusDevice()
	PREINIT:
		int ret;
		FTRSCAN_INTERFACES_LIST InterfaceList;
		int mydevice;
	CODE:
		ret = ftrScanGetInterfaces(&InterfaceList);
		mydevice = ftrGetBaseInterfaceNumber();
		RETVAL = !(InterfaceList.InterfaceStatus[mydevice]);
	OUTPUT:
		RETVAL
