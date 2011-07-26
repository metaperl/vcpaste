// ftrScanApiExDoc.h : interface of the CFtrScanApiExDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_FTRSCANAPIEXDOC_H__79F103EC_0789_41E8_9D6E_BCDC7D1D1E97__INCLUDED_)
#define AFX_FTRSCANAPIEXDOC_H__79F103EC_0789_41E8_9D6E_BCDC7D1D1E97__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "ftrScanAPI.h"
#include "ShowImage.h"

class CFtrScanApiExDoc : public CDocument
{
protected: // create from serialization only
	CFtrScanApiExDoc();
	DECLARE_DYNCREATE(CFtrScanApiExDoc)

// Attributes
public:
	FTRSCAN_IMAGE_SIZE m_ImageSize;

	PBYTE m_pBuffer;

	BOOL m_bError;
	BOOL m_bScanning;

	BOOL m_bLFD;
	BOOL mbIsLFDSupported;
	BOOL m_bInvert;

	BYTE m_nScanType;	//0: ftrScanGetFrame
						//1-7: ftrScanGetImage2, nDose=1 to 7
	bool m_bEraseBkgnd;

	CView *m_pView;

	void StopCaptureOnError();
	void StartGetImage2() ;
	CShowImage m_imgShow;
	FTRHANDLE OpenDevice();
	BOOL DoScan(FTRHANDLE hDevice);
	CString m_strMsg; 
	void ShowMessage(CString strMsg);
	void FPSetOptions(FTRHANDLE hDevice);
	BYTE m_nStretch;
	BYTE m_nStretchToggleState;

	void CheckLFD(FTRHANDLE hDevice);

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFtrScanApiExDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	virtual void OnCloseDocument();
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CFtrScanApiExDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CFtrScanApiExDoc)
	afx_msg void OnCaptureToScreen();
	afx_msg void OnFileSaveBitmap();
	afx_msg void OnUpdateFileSaveBitmap(CCmdUI* pCmdUI);
	afx_msg void OnUpdateFileInvertcolors(CCmdUI* pCmdUI);
	afx_msg void OnFileInvertcolors();
	afx_msg void OnLfd();
	afx_msg void OnUpdateCaptureToScreen(CCmdUI* pCmdUI);
	afx_msg void OnUpdateLfd(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetimage2Ndose1();
	afx_msg void OnUpdateCapturefingerStartgetimage2Ndose1(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetimage2Ndose2();
	afx_msg void OnUpdateCapturefingerStartgetimage2Ndose2(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetimage2Ndose3();
	afx_msg void OnUpdateCapturefingerStartgetimage2Ndose3(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetimage2Ndose4();
	afx_msg void OnUpdateCapturefingerStartgetimage2Ndose4(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetimage2Ndose5();
	afx_msg void OnUpdateCapturefingerStartgetimage2Ndose5(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetimage2Ndose6();
	afx_msg void OnUpdateCapturefingerStartgetimage2Ndose6(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetimage2Ndose7();
	afx_msg void OnUpdateCapturefingerStartgetimage2Ndose7(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerInvertcolor();
	afx_msg void OnUpdateCapturefingerInvertcolor(CCmdUI* pCmdUI);
	afx_msg void OnStretch100();
	afx_msg void OnStretch50();
	afx_msg void OnStretch25();
	afx_msg void OnUpdateStretch100(CCmdUI* pCmdUI);
	afx_msg void OnUpdateStretch50(CCmdUI* pCmdUI);
	afx_msg void OnUpdateStretch25(CCmdUI* pCmdUI);
	afx_msg void OnCapturefingerStartgetframe();
	afx_msg void OnUpdateCapturefingerStartgetframe(CCmdUI* pCmdUI);
	afx_msg void OnOthersFunctions();
	afx_msg void OnUpdateOthersFunctions(CCmdUI* pCmdUI);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FTRSCANAPIEXDOC_H__79F103EC_0789_41E8_9D6E_BCDC7D1D1E97__INCLUDED_)
