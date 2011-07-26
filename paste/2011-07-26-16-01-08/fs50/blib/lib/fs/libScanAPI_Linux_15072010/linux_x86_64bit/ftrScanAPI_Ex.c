// ftrScanPPCExampleDoc.cpp : implementation of the CFtrScanPPCExampleDoc class
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ftrScanAPI.h>

typedef struct tagBITMAPINFOHEADER{
        unsigned int	biSize;
        int			biWidth;
        int			biHeight;
        unsigned short int  biPlanes;
        unsigned short int	biBitCount;
        unsigned int	biCompression;
        unsigned int	biSizeImage;
        int			biXPelsPerMeter;
        int			biYPelsPerMeter;
        unsigned int   biClrUsed;
        unsigned int	biClrImportant;
} BITMAPINFOHEADER, *PBITMAPINFOHEADER;

typedef struct tagRGBQUAD {
        unsigned char	rgbBlue;
        unsigned char	rgbGreen;
        unsigned char	rgbRed;
        unsigned char	rgbReserved;
} RGBQUAD;

typedef struct tagBITMAPINFO {
    BITMAPINFOHEADER    bmiHeader;
    RGBQUAD             bmiColors[1];
} BITMAPINFO, *PBITMAPINFO;

typedef struct tagBITMAPFILEHEADER {
        unsigned short int	bfType;
        unsigned int	bfSize;
        unsigned short int	bfReserved1;
        unsigned short int	bfReserved2;
        unsigned int	bfOffBits;
} BITMAPFILEHEADER, *PBITMAPFILEHEADER;

int write_bmp_file(unsigned char *pImage, int width, int height)
{
	BITMAPINFO *pDIBHeader;
	BITMAPFILEHEADER  bmfHeader;
	int iCyc;

	// allocate memory for a DIB header
	if( (pDIBHeader = (BITMAPINFO *)malloc( sizeof( BITMAPINFO ) + sizeof( RGBQUAD ) * 255 )) == NULL )
	{
		printf("Alloc memory failed! - Unable to write to file!!\n");
		return -1;
	}
	memset( (void *)pDIBHeader, 0, sizeof( BITMAPINFO ) + sizeof( RGBQUAD ) * 255 );
	// fill the DIB header
	pDIBHeader->bmiHeader.biSize          = sizeof( BITMAPINFOHEADER );
	pDIBHeader->bmiHeader.biWidth         = width;
	pDIBHeader->bmiHeader.biHeight        = height;
	pDIBHeader->bmiHeader.biPlanes        = 1;
	pDIBHeader->bmiHeader.biBitCount      = 8;		// 8bits gray scale bmp
	pDIBHeader->bmiHeader.biCompression   = 0;		// BI_RGB = 0;	
	// initialize logical and DIB grayscale
	for( iCyc = 0; iCyc < 256; iCyc++ )
	{
		pDIBHeader->bmiColors[iCyc].rgbBlue = pDIBHeader->bmiColors[iCyc].rgbGreen = pDIBHeader->bmiColors[iCyc].rgbRed = (unsigned char)iCyc;
	}
	// set BITMAPFILEHEADER structure
	//((char *)(&bmfHeader.bfType))[0] = 'B';
	//((char *)(&bmfHeader.bfType))[1] = 'M';
	bmfHeader.bfType = 0x42 + 0x4D * 0x100;
	bmfHeader.bfSize = 14 + sizeof( BITMAPINFO ) + sizeof( RGBQUAD ) * 255 + width * height;	//sizeof( BITMAPFILEHEADER ) = 14
	bmfHeader.bfOffBits = 14 + pDIBHeader->bmiHeader.biSize + sizeof( RGBQUAD ) * 256;
	//write to file
	FILE *fp;
	fp = fopen("frame_Ex.bmp", "wb");
	if( fp == NULL )
	{
		printf("Failed to write to file\n");
		free( pDIBHeader );
		return -1;
	}
	//fwrite( (void *)&bmfHeader, 1, sizeof(BITMAPFILEHEADER), fp );
	fwrite( (void *)&bmfHeader.bfType, sizeof(unsigned short int), 1, fp );
	fwrite( (void *)&bmfHeader.bfSize, sizeof(unsigned int), 1, fp );
	fwrite( (void *)&bmfHeader.bfReserved1, sizeof(unsigned short int), 1, fp );
	fwrite( (void *)&bmfHeader.bfReserved2, sizeof(unsigned short int), 1, fp );
	fwrite( (void *)&bmfHeader.bfOffBits, sizeof(unsigned int), 1, fp );
	//fwrite( (void *)pDIBHeader, 1, sizeof( BITMAPINFO ) + sizeof( RGBQUAD ) * 255, fp );
	fwrite( (void *)&pDIBHeader->bmiHeader.biSize, sizeof(unsigned int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biWidth, sizeof(int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biHeight, sizeof(int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biPlanes, sizeof(unsigned short int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biBitCount, sizeof(unsigned short int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biCompression, sizeof(unsigned int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biSizeImage, sizeof(unsigned int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biXPelsPerMeter, sizeof(int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biYPelsPerMeter, sizeof(int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biClrUsed, sizeof(unsigned int), 1, fp);
	fwrite( (void *)&pDIBHeader->bmiHeader.biClrImportant, sizeof(unsigned int), 1, fp);
	for( iCyc=0; iCyc<256; iCyc++ )
	{
		fwrite( (void *)&pDIBHeader->bmiColors[iCyc].rgbBlue, sizeof(unsigned char), 1, fp );
		fwrite( (void *)&pDIBHeader->bmiColors[iCyc].rgbGreen, sizeof(unsigned char), 1, fp );
		fwrite( (void *)&pDIBHeader->bmiColors[iCyc].rgbRed, sizeof(unsigned char), 1, fp );
		fwrite( (void *)&pDIBHeader->bmiColors[iCyc].rgbReserved, sizeof(unsigned char), 1, fp );
	}
	//
   // copy fingerprint image
	unsigned char *cptrData;
	unsigned char *cptrDIBData;
	unsigned char *pDIBData;

	pDIBData = (unsigned char *)malloc( height * width);
	memset( (void *)pDIBData, 0, height * width );

	cptrData = pImage + (height - 1) * width;
	cptrDIBData = pDIBData;
	for( iCyc = 0; iCyc < height; iCyc++ )
	{
		memcpy( cptrDIBData, cptrData, width );
		cptrData = cptrData - width;
		cptrDIBData = cptrDIBData + width;
	}
	fwrite( (void *)pDIBData, 1, width * height, fp );
	fclose(fp);
	printf("Fingerprint image is written to file: frame_Ex.bmp.\n");
	free( pDIBData );
	free( pDIBHeader );
	return 0;
}

int main(int argc, char *argv[])
{
	void *hDevice;
	FTRSCAN_IMAGE_SIZE ImageSize;
	unsigned char *pBuffer;
	int i;

	hDevice = ftrScanOpenDevice();
	if( hDevice == NULL )
	{
		printf("Failed to open device!\n");
		return -1;
	} 

	if( !ftrScanGetImageSize( hDevice, &ImageSize ) )
	{
		printf("Failed to get image size\n");
		ftrScanCloseDevice( hDevice );
		return -1;
	}
	else
	{
		printf("Image size is %d\n", ImageSize.nImageSize);
		pBuffer = (unsigned char *)malloc( ImageSize.nImageSize );
		printf("Please put your finger on the scanner:\n");
		while(1)
		{
			if( ftrScanIsFingerPresent( hDevice, NULL ) )
				break;
			for(i=0; i<50; i++);	//sleep(1)
		}
		printf("Capturing fingerprint ......");
		//nRet = ftrScanGetImage(hDevice, 3, pBuffer);
		if( ftrScanGetFrame(hDevice, pBuffer, NULL) )
		{
			printf("Done!\nWriting to file......\n");
			write_bmp_file( pBuffer, ImageSize.nWidth, ImageSize.nHeight );
		}
		else
			printf("Failed to get image?\n");
		free( pBuffer );
	}

	ftrScanCloseDevice( hDevice );
	return 0;
}
