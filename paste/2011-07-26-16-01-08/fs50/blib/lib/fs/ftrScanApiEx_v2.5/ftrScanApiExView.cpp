// ftrScanApiExView.cpp : implementation of the CFtrScanApiExView class
//

#include "stdafx.h"
#include "ftrScanApiEx.h"
#include "MainFrm.h"

#include "ftrScanApiExDoc.h"
#include "ftrScanApiExView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExView

IMPLEMENT_DYNCREATE(CFtrScanApiExView, CView)

BEGIN_MESSAGE_MAP(CFtrScanApiExView, CView)
	//{{AFX_MSG_MAP(CFtrScanApiExView)
	ON_WM_ERASEBKGND()
	ON_REGISTERED_MESSAGE(msgImageChanged, OnImageChanged)
	ON_REGISTERED_MESSAGE(msgStatusTextChanged, OnStatusTextChanged)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExView construction/destruction

CFtrScanApiExView::CFtrScanApiExView()
{
	// TODO: add construction code here

}

CFtrScanApiExView::~CFtrScanApiExView()
{
}

BOOL CFtrScanApiExView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExView drawing

void CFtrScanApiExView::OnDraw(CDC* pDC)
{
	CFtrScanApiExDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	// TODO: add draw code for native data here

	if( pDoc->m_pBuffer == NULL )
	   return;
	pDoc->m_imgShow.DIBShow( pDC->m_hDC, pDoc->m_pBuffer, pDoc->m_nStretch );

}


void CFtrScanApiExView::SetStatus(CString strText)
{
}

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExView diagnostics

#ifdef _DEBUG
void CFtrScanApiExView::AssertValid() const
{
	CView::AssertValid();
}

void CFtrScanApiExView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CFtrScanApiExDoc* CFtrScanApiExView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CFtrScanApiExDoc)));
	return (CFtrScanApiExDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExView message handlers

BOOL CFtrScanApiExView::OnEraseBkgnd(CDC* pDC) 
{
	CFtrScanApiExDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);

	if( !pDoc->m_bEraseBkgnd )
	{
		pDoc->m_bEraseBkgnd = true;
		return TRUE;
	}
	
	return CView::OnEraseBkgnd(pDC);
}

LRESULT CFtrScanApiExView::OnImageChanged(WPARAM, LPARAM)
{
    CFtrScanApiExDoc *pDoc = GetDocument();
    pDoc->UpdateAllViews(NULL);
	return 1;
}

LRESULT CFtrScanApiExView::OnStatusTextChanged(WPARAM, LPARAM)
{
    CFtrScanApiExDoc *pDoc = GetDocument();
	CMainFrame *pMainFrame = (CMainFrame *)GetParentFrame();
	pMainFrame->SetStatusText(pDoc->m_strMsg);
	return 1;
}


void CFtrScanApiExView::OnActivateView(BOOL bActivate, CView* pActivateView, CView* pDeactiveView) 
{
	CFtrScanApiExDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	pDoc->m_pView = this;
	
	CView::OnActivateView(bActivate, pActivateView, pDeactiveView);
}
