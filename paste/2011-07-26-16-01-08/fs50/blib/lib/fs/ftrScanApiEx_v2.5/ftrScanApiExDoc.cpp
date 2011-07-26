// ftrScanApiExDoc.cpp : implementation of the CFtrScanApiExDoc class
//

#include "stdafx.h"
#include "ftrScanApiEx.h"
#include "ftrScanApiExDoc.h"
#include "DlgOthers.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

BOOL g_bStop;
CWinThread *g_pThread;

UINT ScanThreadFunc(LPVOID data) 
{
	CFtrScanApiExDoc* pd = (CFtrScanApiExDoc* ) data;
	FTRHANDLE hDevice = NULL;

	while(!g_bStop)
	{
        hDevice = pd->OpenDevice();
        if( hDevice != NULL )
        {
			pd->FPSetOptions( hDevice );
            pd->DoScan( hDevice );
            ftrScanCloseDevice( hDevice );
        }
		else
		{
			pd->ShowMessage(_T("Device is not connected!"));
		}
		ShMsgPump();
	}
	if( hDevice != NULL )
        ftrScanCloseDevice( hDevice );

	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExDoc

IMPLEMENT_DYNCREATE(CFtrScanApiExDoc, CDocument)

BEGIN_MESSAGE_MAP(CFtrScanApiExDoc, CDocument)
	//{{AFX_MSG_MAP(CFtrScanApiExDoc)
	ON_COMMAND(IDM_CAPTURE_TO_SCREEN, OnCaptureToScreen)
	ON_COMMAND(ID_FILE_SAVE_BITMAP, OnFileSaveBitmap)
	ON_UPDATE_COMMAND_UI(ID_FILE_SAVE_BITMAP, OnUpdateFileSaveBitmap)
	ON_UPDATE_COMMAND_UI(ID_FILE_INVERTCOLORS, OnUpdateFileInvertcolors)
	ON_COMMAND(ID_FILE_INVERTCOLORS, OnFileInvertcolors)
	ON_COMMAND(IDM_LFD, OnLfd)
	ON_UPDATE_COMMAND_UI(IDM_CAPTURE_TO_SCREEN, OnUpdateCaptureToScreen)
	ON_UPDATE_COMMAND_UI(IDM_LFD, OnUpdateLfd)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE1, OnCapturefingerStartgetimage2Ndose1)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE1, OnUpdateCapturefingerStartgetimage2Ndose1)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE2, OnCapturefingerStartgetimage2Ndose2)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE2, OnUpdateCapturefingerStartgetimage2Ndose2)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE3, OnCapturefingerStartgetimage2Ndose3)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE3, OnUpdateCapturefingerStartgetimage2Ndose3)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE4, OnCapturefingerStartgetimage2Ndose4)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE4, OnUpdateCapturefingerStartgetimage2Ndose4)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE5, OnCapturefingerStartgetimage2Ndose5)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE5, OnUpdateCapturefingerStartgetimage2Ndose5)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE6, OnCapturefingerStartgetimage2Ndose6)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE6, OnUpdateCapturefingerStartgetimage2Ndose6)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE7, OnCapturefingerStartgetimage2Ndose7)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE7, OnUpdateCapturefingerStartgetimage2Ndose7)
	ON_COMMAND(ID_CAPTUREFINGER_INVERTCOLOR, OnCapturefingerInvertcolor)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_INVERTCOLOR, OnUpdateCapturefingerInvertcolor)
	ON_COMMAND(ID_STRETCH_100, OnStretch100)
	ON_COMMAND(ID_STRETCH_50, OnStretch50)
	ON_COMMAND(ID_STRETCH_25, OnStretch25)
	ON_UPDATE_COMMAND_UI(ID_STRETCH_100, OnUpdateStretch100)
	ON_UPDATE_COMMAND_UI(ID_STRETCH_50, OnUpdateStretch50)
	ON_UPDATE_COMMAND_UI(ID_STRETCH_25, OnUpdateStretch25)
	ON_COMMAND(ID_CAPTUREFINGER_STARTGETFRAME, OnCapturefingerStartgetframe)
	ON_UPDATE_COMMAND_UI(ID_CAPTUREFINGER_STARTGETFRAME, OnUpdateCapturefingerStartgetframe)
	ON_COMMAND(ID_OTHERS_FUNCTIONS, OnOthersFunctions)
	ON_UPDATE_COMMAND_UI(ID_OTHERS_FUNCTIONS, OnUpdateOthersFunctions)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExDoc construction/destruction

CFtrScanApiExDoc::CFtrScanApiExDoc()
{
	m_pBuffer = NULL;
	m_bError = FALSE;
	m_strMsg = _T("");
	m_nStretch = 1;

	if( !m_imgShow.InitDib() )
	{
		MessageBox(NULL, _T("Init DIB Failed."), _T("Error"), MB_OK);
		m_bError = TRUE;
		return;
	}

	m_bScanning = FALSE;
	m_bLFD = FALSE;
	m_bEraseBkgnd = true;
	m_bInvert = FALSE;
	m_ImageSize.nHeight = m_ImageSize.nWidth = m_ImageSize.nImageSize = 0;
	m_nStretchToggleState = 1;	//100%
	m_nScanType = 0;		//GetFrame
	mbIsLFDSupported = FALSE;
}

CFtrScanApiExDoc::~CFtrScanApiExDoc()
{
	if( m_pBuffer != NULL )
		delete [] m_pBuffer;
}

BOOL CFtrScanApiExDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExDoc serialization

void CFtrScanApiExDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// TODO: add storing code here
	}
	else
	{
		// TODO: add loading code here
	}
}

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExDoc diagnostics

#ifdef _DEBUG
void CFtrScanApiExDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CFtrScanApiExDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CFtrScanApiExDoc commands

void CFtrScanApiExDoc::OnCaptureToScreen() 
{
	CWnd* pMain = AfxGetMainWnd();
	CMenu* mmenu = pMain->GetMenu();

	UINT id;
	
	CMenu* submenu = mmenu->GetSubMenu(1);

	if (!m_bScanning)
	{
		g_bStop = FALSE;
		g_pThread = AfxBeginThread(ScanThreadFunc,
										(LPVOID)this, //_param,
										THREAD_PRIORITY_NORMAL,
										0,
										CREATE_SUSPENDED,
										NULL );

		if( g_pThread == NULL )
		{
			MessageBox( NULL, "BeginThread failed!\n", NULL, MB_OK|MB_ICONSTOP );
			return;
		}
		g_pThread->m_bAutoDelete = FALSE;
		g_pThread->ResumeThread();

		id = submenu->GetMenuItemID(0);
		submenu->ModifyMenu(id, MF_BYCOMMAND, id, _T("&Stop"));
		m_bScanning = TRUE;
	}
	else
	{
		g_bStop = TRUE;

		id = submenu->GetMenuItemID(0);
		submenu->ModifyMenu(id, MF_BYCOMMAND, id, _T("&Start"));
		m_bScanning = FALSE;
	}	
}

FTRHANDLE CFtrScanApiExDoc::OpenDevice()
{
    FTRHANDLE hDevice;
    FTRSCAN_IMAGE_SIZE ImageSize;

    hDevice = ftrScanOpenDevice();
    if( hDevice == NULL )
        return hDevice;

    if( !ftrScanGetImageSize( hDevice, &ImageSize ) )
    {
        ftrScanCloseDevice( hDevice );
        return NULL;
    }

    if( (ImageSize.nWidth != m_ImageSize.nWidth) || (ImageSize.nHeight != m_ImageSize.nHeight) )
    {
		m_ImageSize.nHeight = ImageSize.nHeight;
		m_ImageSize.nWidth = ImageSize.nWidth;
		m_ImageSize.nImageSize = ImageSize.nImageSize;

        if( m_pBuffer != NULL )
        {
            delete [] m_pBuffer;
            m_pBuffer = NULL;
        }

        m_pBuffer = new BYTE[m_ImageSize.nImageSize];
        if( m_pBuffer == NULL )
        {
            if( m_pBuffer != NULL )
            {
                delete [] m_pBuffer;
                m_pBuffer = NULL;
            }
            ftrScanCloseDevice( hDevice );
            MessageBox(NULL, _T("Not enough memory!"), _T("Error"), MB_OK|MB_ICONSTOP);
            return NULL;
        }
	    ZeroMemory( m_pBuffer, m_ImageSize.nImageSize );

		if( !m_imgShow.PrepareView( m_ImageSize.nWidth, m_ImageSize.nHeight ) )
		{
            ftrScanCloseDevice( hDevice );
			MessageBox(NULL, _T("PrepareView Failed."), _T("Error"), MB_OK|MB_ICONSTOP);
			return NULL;
		}
  		m_bEraseBkgnd = true;
		m_pView->PostMessage(msgImageChanged);
    }

	CheckLFD(hDevice);

    return hDevice;
}

BOOL CFtrScanApiExDoc::DoScan( FTRHANDLE hDevice )
{
    BOOL bRC;
    DWORD dwErrCode = ERROR_SUCCESS;
	CString strMessage;
	DWORD dwT1, dwT2;

	if( m_nScanType == 0 )	// ftrScanGetFrame
	{
		if( ftrScanIsFingerPresent( hDevice, NULL ) )
		{
			dwT1 = GetTickCount();
			bRC = ftrScanGetFrame( hDevice, m_pBuffer, NULL );
			if (!bRC)
			{
				dwErrCode = GetLastError();
				if( dwErrCode == FTR_ERROR_NO_FRAME )	// Fake finger 
				{
					ShowMessage(_T(""));
					return FALSE;
				}
				else 
				{
					if( (dwErrCode != FTR_ERROR_EMPTY_FRAME) && (dwErrCode != FTR_ERROR_MOVABLE_FINGER) )
					{
						ShowMessage(_T(""));
						return FALSE;
					}
				}
			}
			else
			{ 
				dwT2 = GetTickCount();
  				m_bEraseBkgnd = false;
				m_pView->PostMessage(msgImageChanged);
				strMessage.Format(_T("OK! GetFrame time: %ld (ms)."), dwT2-dwT1);
				ShowMessage(strMessage);
			}
		}
		else
		{
			ShowMessage(_T("Put on your finger"));
		}
	}
	else
	{
		if( m_nScanType > 7 ) 
		{
			m_strMsg = _T("nDose value is invalid!");
			MessageBox( NULL, m_strMsg, NULL, MB_OK|MB_ICONSTOP );
			StopCaptureOnError();
			return FALSE;
		}
		dwT1 = GetTickCount();
		bRC = ftrScanGetImage2( hDevice, m_nScanType, m_pBuffer );
		dwT2 = GetTickCount();
		if (!bRC)
		{
			ShowMessage(_T(""));
			return FALSE;
		}
		else
		{
  			m_bEraseBkgnd = false;
			m_pView->PostMessage(msgImageChanged);
			strMessage.Format(_T("OK! GetImage2 time: %ld (ms)."), dwT2-dwT1);
			ShowMessage(strMessage);
		}		
	}
	return TRUE;
}

void CFtrScanApiExDoc::OnFileSaveBitmap() 
{
	if( m_pBuffer == NULL )
	{
		MessageBox(NULL, "No Image!", "Save bitmap", MB_OK|MB_ICONSTOP);
		return;
	}

	CFileDialog fileDlg
		( FALSE, 
		  NULL,
		  NULL,
		  OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER,
		  NULL,
		  this->m_pView);

	fileDlg.m_ofn.lpstrFilter = _T("Bitmap file(*.bmp)\0*.bmp\0\0");
	fileDlg.m_ofn.lpstrDefExt = _T("*.bmp");
	fileDlg.DoModal();
	CString strPath = fileDlg.GetPathName();
	if( !strPath.IsEmpty() )
	{
		m_imgShow.WriteBMPFile( (LPTSTR)(LPCTSTR)strPath, m_pBuffer );
	}
}

void CFtrScanApiExDoc::OnUpdateFileSaveBitmap(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bScanning && !m_bError);
}

void CFtrScanApiExDoc::OnUpdateFileInvertcolors(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bScanning && !m_bError);				
}

void CFtrScanApiExDoc::OnFileInvertcolors() 
{
	if( m_pBuffer == NULL )
		return;
	for( int i=0; i<m_ImageSize.nImageSize; i++ )
		m_pBuffer[i] = 0xff - m_pBuffer[i];
	UpdateAllViews(NULL);
}

void CFtrScanApiExDoc::OnLfd() 
{
	CWnd* pMain = AfxGetMainWnd();
	CMenu* mmenu = pMain->GetMenu();
	CString strMsg;

	UINT id;
	
	CMenu* submenu = mmenu->GetSubMenu(1);
	
	if( !m_bLFD )
	{
		id = submenu->GetMenuItemID(4);
		submenu->ModifyMenu(id, MF_BYCOMMAND, id, _T("Disable &LFD"));
		m_bLFD = TRUE;
	}	
	else
	{
		id = submenu->GetMenuItemID(4);
		submenu->ModifyMenu(id, MF_BYCOMMAND, id, _T("Enable &LFD"));
		m_bLFD = FALSE;
	}	
}


void CFtrScanApiExDoc::StopCaptureOnError()
{
	CWnd* pMain = AfxGetMainWnd();
	CMenu* mmenu = pMain->GetMenu();

	UINT id;
	
	CMenu* submenu = mmenu->GetSubMenu(1);

	g_bStop = TRUE;
	id = submenu->GetMenuItemID(0);
	submenu->ModifyMenu(id, MF_BYCOMMAND, id, _T("&Start GetFrame"));
	m_bScanning = FALSE;
}	

void CFtrScanApiExDoc::OnUpdateCaptureToScreen(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);
}

void CFtrScanApiExDoc::OnUpdateLfd(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError && mbIsLFDSupported );
}


void CFtrScanApiExDoc::OnCapturefingerStartgetframe() 
{
	m_nScanType = 0;	
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetframe(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 0)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerStartgetimage2Ndose1() 
{
	m_nScanType = 1;
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetimage2Ndose1(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 1)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerStartgetimage2Ndose2() 
{
	m_nScanType = 2;
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetimage2Ndose2(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 2)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerStartgetimage2Ndose3() 
{
	m_nScanType = 3;
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetimage2Ndose3(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 3)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerStartgetimage2Ndose4() 
{
	m_nScanType = 4;
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetimage2Ndose4(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 4)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerStartgetimage2Ndose5() 
{
	m_nScanType = 5;
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetimage2Ndose5(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 5)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerStartgetimage2Ndose6() 
{
	m_nScanType = 6;
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetimage2Ndose6(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 6)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerStartgetimage2Ndose7() 
{
	m_nScanType = 7;
}

void CFtrScanApiExDoc::OnUpdateCapturefingerStartgetimage2Ndose7(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
	if (m_nScanType == 7)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCapturefingerInvertcolor() 
{
	CWnd* pMain = AfxGetMainWnd();
	CMenu* mmenu = pMain->GetMenu();
	CString strMsg;
	UINT id;

	CMenu* submenu = mmenu->GetSubMenu(1);

	if( !m_bInvert )
	{
		id = submenu->GetMenuItemID(6);
		submenu->ModifyMenu(id, MF_BYCOMMAND, id, _T("&Invert color - Black background"));
		m_bInvert = TRUE;
	}	
	else
	{
		id = submenu->GetMenuItemID(6);
		submenu->ModifyMenu(id, MF_BYCOMMAND, id, _T("&Invert color - White background"));
		m_bInvert = FALSE;
	}		
}

void CFtrScanApiExDoc::OnUpdateCapturefingerInvertcolor(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bError);	
}

void CFtrScanApiExDoc::ShowMessage(CString strMsg)
{
	if( strMsg.IsEmpty() )
	{
		DWORD dwError = GetLastError();

		switch( dwError ) 
		{
		case ERROR_SUCCESS:
			m_strMsg = "OK";
			break;
		case FTR_ERROR_EMPTY_FRAME:	// ERROR_EMPTY
			m_strMsg = "- Empty frame -";
			break;
		case FTR_ERROR_MOVABLE_FINGER:
			m_strMsg = "- Movable finger -";
			break;
		case FTR_ERROR_NO_FRAME:
			m_strMsg = "- Fake finger detected -";
			break;
		case FTR_ERROR_USER_CANCELED:
			m_strMsg = "- User canceled -";
			break;
		case FTR_ERROR_HARDWARE_INCOMPATIBLE:
			m_strMsg = "- Incompatible hardware -";
			break;
		case FTR_ERROR_FIRMWARE_INCOMPATIBLE:
			m_strMsg = "- Incompatible firmware -";
			break;
		case FTR_ERROR_INVALID_AUTHORIZATION_CODE:
			m_strMsg = "- Invalid authorization code -";
			break;
		default:
			m_strMsg.Format( "Unknown return code - %d", dwError );
			break;
		}
	}
	else
		m_strMsg = strMsg;
	//set status text
	m_pView->PostMessage(msgStatusTextChanged);
}

void CFtrScanApiExDoc::FPSetOptions(FTRHANDLE hDevice)
{
	if( m_bLFD )
	{
		if( !ftrScanSetOptions( hDevice, FTR_OPTIONS_CHECK_FAKE_REPLICA,  FTR_OPTIONS_CHECK_FAKE_REPLICA ) )
		{
			ShowMessage(_T(""));
			return;
		}
	}
	else
		ftrScanSetOptions( hDevice, FTR_OPTIONS_CHECK_FAKE_REPLICA,  0 );

	if( m_bInvert )
	{
		if( !ftrScanSetOptions( hDevice, FTR_OPTIONS_INVERT_IMAGE,  FTR_OPTIONS_INVERT_IMAGE) )
		{
			ShowMessage(_T(""));
			return;
		}
	}
	else
		ftrScanSetOptions( hDevice, FTR_OPTIONS_INVERT_IMAGE,  0 );
}		

void CFtrScanApiExDoc::OnStretch100() 
{
	m_nStretch = 1;	
	m_nStretchToggleState = 1;
	UpdateAllViews(NULL);
}

void CFtrScanApiExDoc::OnStretch50() 
{
	m_nStretch = 2;		
	m_nStretchToggleState = 2;
	UpdateAllViews(NULL);
}

void CFtrScanApiExDoc::OnStretch25() 
{
	m_nStretch = 3;	
	m_nStretchToggleState = 3;
	UpdateAllViews(NULL);
}

void CFtrScanApiExDoc::OnUpdateStretch100(CCmdUI* pCmdUI) 
{
	// TODO: Add your command update UI handler code here
	if (m_nStretchToggleState == 1)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );

}

void CFtrScanApiExDoc::OnUpdateStretch50(CCmdUI* pCmdUI) 
{
	if (m_nStretchToggleState == 2)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );
	
}

void CFtrScanApiExDoc::OnUpdateStretch25(CCmdUI* pCmdUI) 
{
	if (m_nStretchToggleState == 3)
		pCmdUI->SetCheck( true );
	else
		pCmdUI->SetCheck( false );	
}

void CFtrScanApiExDoc::OnCloseDocument() 
{
	g_bStop = true;

	if( g_pThread )
	{
		WaitForSingleObject(g_pThread->m_hThread, INFINITE);
	}

	CDocument::OnCloseDocument();
}

void CFtrScanApiExDoc::OnOthersFunctions() 
{
	CDlgOthers dlgOthers;
	dlgOthers.DoModal();	
}

void CFtrScanApiExDoc::OnUpdateOthersFunctions(CCmdUI* pCmdUI) 
{
	pCmdUI->Enable(!m_bScanning);		
}

void CFtrScanApiExDoc::CheckLFD( FTRHANDLE hDevice )
{
	mbIsLFDSupported = FALSE;
	if( m_nScanType == 0 )
	{
		FTRSCAN_DEVICE_INFO infoDevice;
		// Initialize the FTRSCAN_DEVICE_INFO structure.
		ZeroMemory( &infoDevice, sizeof(infoDevice) );
		infoDevice.dwStructSize = sizeof(infoDevice);
		BOOL bRet = ftrScanGetDeviceInfo( hDevice, &infoDevice );
		if( bRet )
		{
			if( infoDevice.byDeviceCompatibility == FTR_DEVICE_USB_1_1 ||
				infoDevice.byDeviceCompatibility == FTR_DEVICE_USB_2_0_TYPE_1 ||
				infoDevice.byDeviceCompatibility == FTR_DEVICE_USB_2_0_TYPE_2 ||
				infoDevice.byDeviceCompatibility == FTR_DEVICE_USB_2_0_TYPE_3 )
			{
				mbIsLFDSupported = TRUE;
			}
		}
	}
}
