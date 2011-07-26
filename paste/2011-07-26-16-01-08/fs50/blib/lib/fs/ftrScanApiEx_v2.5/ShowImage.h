// ShowImage.h: interface for the CShowImage class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SHOWIMAGE_H__4C61E772_CFFC_41DD_B050_9DCA21A4121D__INCLUDED_)
#define AFX_SHOWIMAGE_H__4C61E772_CFFC_41DD_B050_9DCA21A4121D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CShowImage  
{
public:
	CShowImage();
	virtual ~CShowImage();

	BOOL InitDib();
	BOOL PrepareView( int w, int h );
	void DIBShow(HDC hdcImage, BYTE *pImage, BYTE nStretch);
	void WriteBMPFile(char *szPath, BYTE *pImage);

private:
	BITMAPINFO     *m_pDIBHeader;
	BITMAPFILEHEADER  m_bmfHeader;
	BYTE *m_Bits;
	HBITMAP m_Bitmap;

	int m_nWidth;
	int m_nHeight;
	int m_nOldWidth;
	int m_nOldHeight;
};

#endif // !defined(AFX_SHOWIMAGE_H__4C61E772_CFFC_41DD_B050_9DCA21A4121D__INCLUDED_)
