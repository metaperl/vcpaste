// ShowImage.cpp: implementation of the CShowImage class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ftrScanApiEx.h"
#include "ShowImage.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CShowImage::CShowImage()
{
	m_pDIBHeader = NULL;
	m_nWidth = 0;
	m_nHeight = 0;
	m_nOldWidth = 0;
	m_nOldHeight = 0;
	m_Bitmap = NULL;
}

CShowImage::~CShowImage()
{
	if( m_pDIBHeader != NULL )
	{
		free( (void *)m_pDIBHeader );
		m_pDIBHeader = NULL;
	}
	if ( m_Bitmap != NULL )
	{
		DeleteObject ( m_Bitmap );
		m_Bitmap = NULL;
	}
} 

BOOL CShowImage::InitDib()
{
	// allocate memory for a DIB header
	if( (m_pDIBHeader = (BITMAPINFO *)malloc( sizeof( BITMAPINFO ) +
											sizeof( RGBQUAD ) * 255 )) == NULL )
		return FALSE;
	ZeroMemory( (PVOID)m_pDIBHeader, sizeof( BITMAPINFO ) + sizeof( RGBQUAD ) * 255 );
	// fill the DIB header
	m_pDIBHeader->bmiHeader.biSize          = sizeof( BITMAPINFOHEADER );
	m_pDIBHeader->bmiHeader.biPlanes        = 1;
	m_pDIBHeader->bmiHeader.biBitCount      = 8;
	m_pDIBHeader->bmiHeader.biCompression   = BI_RGB;
	m_pDIBHeader->bmiHeader.biXPelsPerMeter = 0x4CE6;	//500DPI
    m_pDIBHeader->bmiHeader.biYPelsPerMeter = 0x4CE6;	//500DPI
	// initialize logical and DIB palettes to grayscale
	for(int iCyc = 0; iCyc < 256; iCyc++ )
	{
		m_pDIBHeader->bmiColors[iCyc].rgbBlue = m_pDIBHeader->bmiColors[iCyc].rgbGreen =
		m_pDIBHeader->bmiColors[iCyc].rgbRed  = (BYTE)iCyc;
	}
	// set BITMAPFILEHEADER structure
	((char *)(&m_bmfHeader.bfType))[0] = 'B';
	((char *)(&m_bmfHeader.bfType))[1] = 'M';
	//
	return TRUE;
}

BOOL CShowImage::PrepareView( int w, int h )
{
	// support the 256-colors DIB only
	if( w <= 0 || h <= 0 )
		return FALSE;

	m_nWidth = w;
	m_nHeight = h;

	// if Image size is changed.
	if( (m_nWidth != m_nOldWidth) || (m_nHeight != m_nOldHeight) )
	{	
		// fill the DIB header
		m_pDIBHeader->bmiHeader.biWidth         = w;
		m_pDIBHeader->bmiHeader.biHeight        = -h;	//mirror the image

		m_bmfHeader.bfSize = sizeof( BITMAPFILEHEADER ) + sizeof( BITMAPINFO ) + sizeof( RGBQUAD ) * 255
		  + sizeof( char ) * w * h;

		m_bmfHeader.bfOffBits = (DWORD)sizeof(BITMAPFILEHEADER) + m_pDIBHeader->bmiHeader.biSize
												  + sizeof( RGBQUAD ) * 256;
		m_nOldWidth = m_nWidth;
		m_nOldHeight = m_nHeight;

		if ( m_Bitmap )
		{	
			DeleteObject ( m_Bitmap );
			m_Bitmap=NULL;
		}
		m_Bitmap = CreateDIBSection ( NULL, m_pDIBHeader, DIB_RGB_COLORS, (void **)&m_Bits, NULL, NULL ); 

		return TRUE;
	}
	// normal return
	return TRUE;
}

void CShowImage::DIBShow(HDC hdcImage, BYTE *pImage, BYTE nStretch)
{
	HBITMAP hOldbm;
	HDC     hMemDC;
	BITMAP  bm;
	POINT   ptSize, ptOrg;
	
	//Fill data to the bitmap
	for(int nCurPos=0; nCurPos<m_nWidth*m_nHeight; nCurPos++ )
	{
		m_Bits[nCurPos] = *pImage;
		pImage++;
	}
	hMemDC = CreateCompatibleDC( hdcImage );

	// Selecting the current bitmap.
	hOldbm = (HBITMAP)SelectObject( hMemDC, m_Bitmap );

	if (hOldbm) 
	{
		//   Setting the same map mode for the created device context.
		SetMapMode( hMemDC, GetMapMode( hdcImage ) );
		//   Calculating the image dimensions.
		GetObject( m_Bitmap, sizeof(BITMAP), (LPSTR)&bm );
		ptSize.x = bm.bmWidth;
		ptSize.y = bm.bmHeight;

		//   Conversion of coordinates for the output device.
		//DPtoLP( hMemDC, &ptSize, 1 );
		DPtoLP( hdcImage, &ptSize, 1 );
		ptOrg.x = 0;
		ptOrg.y = 0;
		DPtoLP( hMemDC, &ptOrg, 1 );

		//   Drawing the bitmap.
		SetStretchBltMode( hdcImage, COLORONCOLOR);
		//
		int nW, nH;
		switch( nStretch )
		{
		case 1: 
			nW = m_nWidth;
			nH = m_nHeight;
			break;
		case 2:
			nW = m_nWidth / 2;
			nH = m_nHeight / 2;
			break;
		case 3:
			nW = m_nWidth / 4;
			nH = m_nHeight / 4;
			break;
		default: 
			nW = m_nWidth / 2;
			nH = m_nHeight / 2;
			break;
		}
		//BitBlt( hdcImage,  0,  0,  m_nWidth,  m_nHeight,  hMemDC,  0,  0,   SRCCOPY );
		StretchBlt( hdcImage, 0, 0, nW, nH, hMemDC, 0, 0, m_nWidth, m_nHeight, SRCCOPY );

		//   Restoring the saved state.
		SelectObject( hMemDC, hOldbm );
	}
	//   Releasing resources.
	DeleteDC(hMemDC);
//	ReleaseDC(hWnd, hDC );	
}

void CShowImage::WriteBMPFile(char *szFile, BYTE *pImage)
{
	if( pImage == NULL )
	{
		MessageBox(NULL, _T("No Image!"), _T("Write bitmap file ERROR"), MB_OK|MB_ICONSTOP);
		return ;
	}

	FILE *fptr = NULL;
	fptr = fopen( szFile, _T("wb") );
	if( fptr == NULL )
	{
		MessageBox(NULL, _T("Failed to open the file!"), _T("Write bitmap file"), MB_OK|MB_ICONSTOP);
		return;
	}
	//Fill data to the bitmap
	for(int nCurPos=0; nCurPos<m_nWidth*m_nHeight; nCurPos++ )
	{
		m_Bits[nCurPos] = *pImage;
		pImage++;
	}
	fwrite( (void *)&m_bmfHeader, sizeof(BITMAPFILEHEADER), 1, fptr );
	fwrite( (void *)m_pDIBHeader, sizeof( BITMAPINFO ) + sizeof( RGBQUAD ) * 255, 1, fptr );
	fwrite( (void *)m_Bits, m_nWidth * m_nHeight , 1, fptr );
	fclose(fptr);
}
