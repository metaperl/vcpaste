// ftrScanApiEx.cpp : Defines the class behaviors for the application.
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


void ShMsgPump()
{
	// if we do MFC stuff in an exported fn, call this first!
	AFX_MANAGE_STATE(AfxGetStaticModuleState( ));

	DWORD dInitTime = GetTickCount();
	MSG m_msgCur;                   // current message
	CWinApp	*pWinApp = AfxGetApp();   
	while (::PeekMessage(&m_msgCur, NULL, NULL, NULL, PM_NOREMOVE)  &&
			(GetTickCount() - dInitTime < 200) )	
	{
		pWinApp->PumpMessage();
	}
}


/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExApp

BEGIN_MESSAGE_MAP(CFtrScanApiExApp, CWinApp)
	//{{AFX_MSG_MAP(CFtrScanApiExApp)
	ON_COMMAND(ID_APP_ABOUT, OnAppAbout)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
	// Standard file based document commands
	ON_COMMAND(ID_FILE_NEW, CWinApp::OnFileNew)
	ON_COMMAND(ID_FILE_OPEN, CWinApp::OnFileOpen)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExApp construction

CFtrScanApiExApp::CFtrScanApiExApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CFtrScanApiExApp object

CFtrScanApiExApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExApp initialization

BOOL CFtrScanApiExApp::InitInstance()
{
	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	// Change the registry key under which our settings are stored.
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization.
	SetRegistryKey(_T("Local AppWizard-Generated Applications"));

	LoadStdProfileSettings(0);  // Load standard INI file options (including MRU)

	// Register the application's document templates.  Document templates
	//  serve as the connection between documents, frame windows and views.

	CSingleDocTemplate* pDocTemplate;
	pDocTemplate = new CSingleDocTemplate(
		IDR_MAINFRAME,
		RUNTIME_CLASS(CFtrScanApiExDoc),
		RUNTIME_CLASS(CMainFrame),       // main SDI frame window
		RUNTIME_CLASS(CFtrScanApiExView));
	AddDocTemplate(pDocTemplate);

	// Parse command line for standard shell commands, DDE, file open
	CCommandLineInfo cmdInfo;
	ParseCommandLine(cmdInfo);

	// Dispatch commands specified on the command line
	if (!ProcessShellCommand(cmdInfo))
		return FALSE;

	// The one and only window has been initialized, so show and update it.
	m_pMainWnd->SetWindowText(_T("Futronic ftrScanApiEx v2.5"));
	m_pMainWnd->ShowWindow(SW_SHOWMAXIMIZED);
	m_pMainWnd->UpdateWindow();

	return TRUE;
}


/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	CString	m_strDllVersion;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

	void GetScanAPIVersion( char *verinfo, int buflen );

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	m_strDllVersion = _T("");
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	DDX_Text(pDX, IDC_DLL_VERSION, m_strDllVersion);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

// App command to run the dialog
void CFtrScanApiExApp::OnAppAbout()
{
	CAboutDlg aboutDlg;
	aboutDlg.DoModal();
}

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExApp message handlers


BOOL CAboutDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	char  verinfo[32];            // SDK version information
	char  vertext[256];
	// get SDK version information
	ZeroMemory( (LPVOID)verinfo, 32 );
	GetScanAPIVersion( verinfo, 31 );
	strcpy( vertext, "ftrScanAPI.dll Version: " );
	strcat( vertext, verinfo );
	m_strDllVersion = (CString) vertext;
	UpdateData(FALSE);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CAboutDlg::GetScanAPIVersion( char *verinfo, int buflen )
{
	DWORD dwZero;
	int viLen;
	void *verBuf;
	struct LANGANDCODEPAGE
	{
	  WORD wLanguage;
	  WORD wCodePage;
	} *lpTranslate;
	unsigned int cbTranslate;
	char SubBlock[64];
	BOOL bRet;
	char *lpBuffer;
	unsigned int uiBytes;

	viLen = GetFileVersionInfoSize( "ftrScanAPI.dll", &dwZero );
	if( viLen == 0 )
	{
	  strcpy( verinfo, "unknown version" );
	  return;
	}

	if( (verBuf = malloc( viLen )) == NULL )
	{
	  strcpy( verinfo, "unknown version" );
	  return;
	}

	bRet = GetFileVersionInfo( "ftrScanAPI.dll", dwZero, viLen, verBuf );
	if( bRet == FALSE )
	{
	  strcpy( verinfo, "unknown version" );
	  return;
	}

	bRet = VerQueryValue( verBuf, TEXT("\\VarFileInfo\\Translation"),
	  (LPVOID *)&lpTranslate, &cbTranslate );
	if( bRet == FALSE )
	{
	  strcpy( verinfo, "unknown version" );
	  return;
	}

	wsprintf( SubBlock, TEXT("\\StringFileInfo\\%04x%04x\\ProductVersion"),
			lpTranslate->wLanguage, lpTranslate->wCodePage);
	bRet = VerQueryValue( verBuf, SubBlock, (LPVOID *)&lpBuffer, &uiBytes );
	if( bRet == FALSE )
	{
	  strcpy( verinfo, "unknown version" );
	  return;
	}

	strncpy( verinfo, lpBuffer, __min( (DWORD)buflen, uiBytes ) );
	free( verBuf ); 
}
