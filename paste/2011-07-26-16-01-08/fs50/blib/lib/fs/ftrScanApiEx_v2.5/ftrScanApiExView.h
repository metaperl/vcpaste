// ftrScanApiExView.h : interface of the CFtrScanApiExView class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_FTRSCANAPIEXVIEW_H__B833DB41_6394_457E_A8C5_5B9CF8FE586C__INCLUDED_)
#define AFX_FTRSCANAPIEXVIEW_H__B833DB41_6394_457E_A8C5_5B9CF8FE586C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class CFtrScanApiExView : public CView
{
protected: // create from serialization only
	CFtrScanApiExView();
	DECLARE_DYNCREATE(CFtrScanApiExView)

// Attributes
public:
	CFtrScanApiExDoc* GetDocument();

// Operations
public:
	void SetStatus(CString strText);

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFtrScanApiExView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	protected:
	virtual void OnActivateView(BOOL bActivate, CView* pActivateView, CView* pDeactiveView);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CFtrScanApiExView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CFtrScanApiExView)
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg LRESULT OnImageChanged(WPARAM, LPARAM);
	afx_msg LRESULT OnStatusTextChanged(WPARAM, LPARAM);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in ftrScanApiExView.cpp
inline CFtrScanApiExDoc* CFtrScanApiExView::GetDocument()
   { return (CFtrScanApiExDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FTRSCANAPIEXVIEW_H__B833DB41_6394_457E_A8C5_5B9CF8FE586C__INCLUDED_)
