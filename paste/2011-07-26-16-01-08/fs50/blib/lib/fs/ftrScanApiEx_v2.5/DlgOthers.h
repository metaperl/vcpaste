#if !defined(AFX_DLGOTHERS_H__201E74BC_7AFE_44D5_B756_6374CEF54EC3__INCLUDED_)
#define AFX_DLGOTHERS_H__201E74BC_7AFE_44D5_B756_6374CEF54EC3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DlgOthers.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDlgOthers dialog

class CDlgOthers : public CDialog
{
// Construction
public:
	CDlgOthers(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDlgOthers)
	enum { IDD = IDD_DIALOG_OTHERS };
	CButton	m_btnSetLed;
	CButton	m_btnReadSecret;
	CButton	m_btnWriteSecret;
	CButton	m_btnSetAuthCode;
	CButton	m_btnWrite7;
	CEdit	m_ctrlVersionInfo;
	CEdit	m_ctrlRead7Bytes;
	CEdit	m_ctrlDeviceModel;
	CEdit	m_ctrlReadSecret;
	CEdit	m_ctrlGetRed;
	CEdit	m_ctrlGetGreen;
	CStatic	m_lblMsg;
	CString	m_strWriteSecret;
	CString	m_strAuthCode;
	CString	m_strWrite7Bytes;
	BYTE	m_nSetGreen;
	BYTE	m_nSetRed;
	//}}AFX_DATA

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDlgOthers)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDlgOthers)
	afx_msg void OnButtonSetleds();
	virtual BOOL OnInitDialog();
	afx_msg void OnButtonRefresh();
	afx_msg void OnButtonWrite7bytes();
	afx_msg void OnChangeEdit7bytesWrite();
	afx_msg void OnButtonRead7bytes();
	afx_msg void OnButtonAlert();
	afx_msg void OnButtonSetauthcode();
	afx_msg void OnButtonReadSecret();
	afx_msg void OnButtonWriteSecret();
	afx_msg void OnChangeEditAuthorizationCode();
	afx_msg void OnChangeEditSecretWrite();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

private: 
	void GetDeviceInfo();	
	CString GetErrorMessage( CString strTitle );
	CBitmapButton m_bbAlert;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGOTHERS_H__201E74BC_7AFE_44D5_B756_6374CEF54EC3__INCLUDED_)
