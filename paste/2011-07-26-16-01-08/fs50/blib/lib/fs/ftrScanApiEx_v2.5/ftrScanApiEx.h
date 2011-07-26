// ftrScanApiEx.h : main header file for the FTRSCANAPIEX application
//

#if !defined(AFX_FTRSCANAPIEX_H__CC25E53F_F297_495E_BE2E_A26BEFE9DB2E__INCLUDED_)
#define AFX_FTRSCANAPIEX_H__CC25E53F_F297_495E_BE2E_A26BEFE9DB2E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

extern void	ShMsgPump();

static const UINT msgImageChanged = ::RegisterWindowMessage("IMAGECHANGED");
static const UINT msgStatusTextChanged = ::RegisterWindowMessage("STATUSTEXTCHANGED");

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExApp:
// See ftrScanApiEx.cpp for the implementation of this class
//

class CFtrScanApiExApp : public CWinApp
{
public:
	CFtrScanApiExApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFtrScanApiExApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation
	//{{AFX_MSG(CFtrScanApiExApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FTRSCANAPIEX_H__CC25E53F_F297_495E_BE2E_A26BEFE9DB2E__INCLUDED_)
