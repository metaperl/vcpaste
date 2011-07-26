// DlgOthers.cpp : implementation file
//

#include "stdafx.h"
#include "ftrScanApiEx.h"
#include "DlgOthers.h"
#include "ftrScanAPI.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDlgOthers dialog


CDlgOthers::CDlgOthers(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgOthers::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDlgOthers)
	m_strWriteSecret = _T("");
	m_strAuthCode = _T("");
	m_strWrite7Bytes = _T("");
	m_nSetGreen = 0;
	m_nSetRed = 0;
	//}}AFX_DATA_INIT
}


void CDlgOthers::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDlgOthers)
	DDX_Control(pDX, IDC_BUTTON_SETLEDS, m_btnSetLed);
	DDX_Control(pDX, IDC_BUTTON_READ_SECRET, m_btnReadSecret);
	DDX_Control(pDX, IDC_BUTTON_WRITE_SECRET, m_btnWriteSecret);
	DDX_Control(pDX, IDC_BUTTON_SETAUTHCODE, m_btnSetAuthCode);
	DDX_Control(pDX, IDC_BUTTON_WRITE7BYTES, m_btnWrite7);
	DDX_Control(pDX, IDC_EDIT_VERSIONINFO, m_ctrlVersionInfo);
	DDX_Control(pDX, IDC_EDIT_7BYTES_READ, m_ctrlRead7Bytes);
	DDX_Control(pDX, IDC_EDIT_DEVICEMODEL, m_ctrlDeviceModel);
	DDX_Control(pDX, IDC_EDIT_SECRET_READ, m_ctrlReadSecret);
	DDX_Control(pDX, IDC_EDIT_GETRED, m_ctrlGetRed);
	DDX_Control(pDX, IDC_EDIT_GETGREEN, m_ctrlGetGreen);
	DDX_Control(pDX, IDC_LBL_MESSAGE, m_lblMsg);
	DDX_Text(pDX, IDC_EDIT_SECRET_WRITE, m_strWriteSecret);
	DDV_MaxChars(pDX, m_strWriteSecret, 7);
	DDX_Text(pDX, IDC_EDIT_AUTHORIZATION_CODE, m_strAuthCode);
	DDV_MaxChars(pDX, m_strAuthCode, 7);
	DDX_Text(pDX, IDC_EDIT_7BYTES_WRITE, m_strWrite7Bytes);
	DDV_MaxChars(pDX, m_strWrite7Bytes, 7);
	DDX_Text(pDX, IDC_EDIT_SETGREEN, m_nSetGreen);
	DDX_Text(pDX, IDC_EDIT_SETRED, m_nSetRed);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDlgOthers, CDialog)
	//{{AFX_MSG_MAP(CDlgOthers)
	ON_BN_CLICKED(IDC_BUTTON_SETLEDS, OnButtonSetleds)
	ON_BN_CLICKED(IDC_BUTTON_REFRESH, OnButtonRefresh)
	ON_BN_CLICKED(IDC_BUTTON_WRITE7BYTES, OnButtonWrite7bytes)
	ON_EN_CHANGE(IDC_EDIT_7BYTES_WRITE, OnChangeEdit7bytesWrite)
	ON_BN_CLICKED(IDC_BUTTON_READ7BYTES, OnButtonRead7bytes)
	ON_BN_CLICKED(IDC_ALERT, OnButtonAlert)
	ON_BN_CLICKED(IDC_BUTTON_SETAUTHCODE, OnButtonSetauthcode)
	ON_BN_CLICKED(IDC_BUTTON_READ_SECRET, OnButtonReadSecret)
	ON_BN_CLICKED(IDC_BUTTON_WRITE_SECRET, OnButtonWriteSecret)
	ON_EN_CHANGE(IDC_EDIT_AUTHORIZATION_CODE, OnChangeEditAuthorizationCode)
	ON_EN_CHANGE(IDC_EDIT_SECRET_WRITE, OnChangeEditSecretWrite)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

BOOL CDlgOthers::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	VERIFY(m_bbAlert.AutoLoad(IDC_ALERT, this));

	GetDeviceInfo();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgOthers::GetDeviceInfo()
{
	FTRHANDLE hDevice = NULL;

	m_btnSetLed.EnableWindow(1);

	hDevice = ftrScanOpenDevice();
	if( hDevice )
	{
		FTRSCAN_DEVICE_INFO infoDevice;
		// Initialize the FTRSCAN_DEVICE_INFO structure.
		ZeroMemory( &infoDevice, sizeof(infoDevice) );
		infoDevice.dwStructSize = sizeof(infoDevice);
		BOOL bRet = ftrScanGetDeviceInfo( hDevice, &infoDevice );
		if( bRet )
		{
			CString strTemp;
			switch( infoDevice.byDeviceCompatibility )
			{
			case FTR_DEVICE_USB_1_1:
			case FTR_DEVICE_USB_2_0_TYPE_1:
			case FTR_DEVICE_USB_2_0_TYPE_2:
				strTemp.Format(_T("%d: FS80"), infoDevice.byDeviceCompatibility );
				break;
			case FTR_DEVICE_USB_2_0_TYPE_3:
				strTemp.Format(_T("%d: FS88"), infoDevice.byDeviceCompatibility );
				break;
			case FTR_DEVICE_USB_2_0_TYPE_4:
				strTemp.Format(_T("%d: FS90"), infoDevice.byDeviceCompatibility );
				m_btnSetLed.EnableWindow(0);
				break;
			case FTR_DEVICE_USB_2_0_TYPE_50:
				strTemp.Format(_T("%d: FS50"), infoDevice.byDeviceCompatibility );
				break;
			default:
				strTemp.Format(_T("%d: -UNKNOWN Device-"), infoDevice.byDeviceCompatibility );
				break;
			}
			m_ctrlDeviceModel.SetWindowText( strTemp );
			//
			FTRSCAN_VERSION_INFO infoVersion;
			infoVersion.dwVersionInfoSize = sizeof( FTRSCAN_VERSION_INFO );
			bRet = ftrScanGetVersion( hDevice, &infoVersion );
			if( bRet )
			{
				CString strVersion;
				strVersion.Format(_T("ScanAPI: %d.%d.%d.%d, "), 
					infoVersion.APIVersion.wMajorVersionHi, 
					infoVersion.APIVersion.wMajorVersionLo,
					infoVersion.APIVersion.wMinorVersionHi,
					infoVersion.APIVersion.wMinorVersionLo );
				strTemp.Format( _T("Firmware: %d.%d"), 
					infoVersion.FirmwareVersion.wMajorVersionHi,
					infoVersion.FirmwareVersion.wMajorVersionLo );
				strVersion += strTemp;
				if( infoVersion.FirmwareVersion.wMinorVersionHi != 0xffff )
				{
					strTemp.Format(_T(".%d"), infoVersion.FirmwareVersion.wMinorVersionHi);
					strVersion += strTemp;
				}
				if( infoVersion.FirmwareVersion.wMinorVersionLo != 0xffff )
				{
					strTemp.Format(_T(".%d"), infoVersion.FirmwareVersion.wMinorVersionLo);
					strVersion += strTemp;
				}
				strTemp.Format( _T(", Hardware: %d.%d"), 
					infoVersion.HardwareVersion.wMajorVersionHi,
					infoVersion.HardwareVersion.wMajorVersionLo );
				strVersion += strTemp;
				if( infoVersion.HardwareVersion.wMinorVersionHi != 0xffff )
				{
					strTemp.Format(_T(".%d"), infoVersion.HardwareVersion.wMinorVersionHi);
					strVersion += strTemp;
				}
				if( infoVersion.HardwareVersion.wMinorVersionLo != 0xffff )
				{
					strTemp.Format(_T(".%d"), infoVersion.HardwareVersion.wMinorVersionLo);
					strVersion += strTemp;
				}
				m_ctrlVersionInfo.SetWindowText( strVersion );
			}
		}
		ftrScanCloseDevice( hDevice );
		hDevice = NULL;
	}
	else
	{
		m_ctrlDeviceModel.SetWindowText( _T("") );
		m_ctrlVersionInfo.SetWindowText( _T("") );
		m_lblMsg.SetWindowText(_T("Failed to open device!"));
	}
}
/////////////////////////////////////////////////////////////////////////////
// CDlgOthers message handlers

void CDlgOthers::OnButtonRefresh() 
{
	m_lblMsg.SetWindowText(_T(""));
	GetDeviceInfo();	
}

void CDlgOthers::OnButtonSetleds() 
{
	UpdateData(1);
	FTRHANDLE hDevice = NULL;
	hDevice = ftrScanOpenDevice();
	if( hDevice )
	{
		if( !ftrScanSetDiodesStatus( hDevice, m_nSetGreen, m_nSetRed ) )
		{
			ftrScanCloseDevice( hDevice );
			hDevice = NULL;
			m_lblMsg.SetWindowText(_T("Failed to SetDiodesStatus!"));
			return;
		}
		BOOL bGreen, bRed;
		if( !ftrScanGetDiodesStatus( hDevice, &bGreen, &bRed ) )
		{
			ftrScanCloseDevice( hDevice );
			hDevice = NULL;			
			m_lblMsg.SetWindowText(GetErrorMessage(_T("Failed to GetDiodesStatus!")));
			return;
		}
		ftrScanCloseDevice( hDevice );
		hDevice = NULL;
		if( bGreen )
			m_ctrlGetGreen.SetWindowText("On");
		else
			m_ctrlGetGreen.SetWindowText("Off");
		if( bRed )
			m_ctrlGetRed.SetWindowText("On");
		else
			m_ctrlGetRed.SetWindowText("Off");

		m_lblMsg.SetWindowText( _T("SetDiodesStatus OK!"));
	}	
	else
		m_lblMsg.SetWindowText( _T("Failed to open device!"));
}

void CDlgOthers::OnButtonWrite7bytes() 
{
	FTRHANDLE hDevice = NULL;
	hDevice = ftrScanOpenDevice();
	if( hDevice )
	{
		if( !ftrScanSave7Bytes( hDevice, (PVOID)(LPCTSTR)m_strWrite7Bytes ) )
		{		
			m_lblMsg.SetWindowText(GetErrorMessage(_T("Failed to ScanSave7Bytes!")));
			ftrScanCloseDevice(hDevice);
			hDevice = NULL;
			return;
		}
		ftrScanCloseDevice(hDevice);
		hDevice = NULL;
		m_lblMsg.SetWindowText(_T("ScanSave7Bytes OK!"));	
	}
	else
		m_lblMsg.SetWindowText( _T("Failed to open device!"));
}

void CDlgOthers::OnChangeEdit7bytesWrite() 
{
	UpdateData(1);
	if( m_strWrite7Bytes.GetLength() == 7 )
		m_btnWrite7.EnableWindow(1);
	else
		m_btnWrite7.EnableWindow(0);
}

void CDlgOthers::OnButtonRead7bytes() 
{
	FTRHANDLE hDevice = NULL;
	hDevice = ftrScanOpenDevice();
	if( hDevice )
	{
		char bufRead7Bytes[8];
		ZeroMemory( bufRead7Bytes, 8 );
		if( !ftrScanRestore7Bytes( hDevice, bufRead7Bytes ) )
		{
			m_lblMsg.SetWindowText(GetErrorMessage(_T("Failed to ScanRestore7Bytes!")));
			ftrScanCloseDevice(hDevice);
			hDevice = NULL;
			return;
		}
		ftrScanCloseDevice(hDevice);
		hDevice = NULL;
		m_ctrlRead7Bytes.SetWindowText( bufRead7Bytes );
		m_lblMsg.SetWindowText(_T("RestoreSave7Bytes OK!"));	
	}
	else
		m_lblMsg.SetWindowText( _T("Failed to open device!"));	
}

void CDlgOthers::OnButtonAlert() 
{
	CString strMsg;
	strMsg = _T("The ftrScanSetNewAuthorizationCode stores the authorization code to use with \r\n");
	strMsg = strMsg + _T("ftrScanSaveSecret7Bytes/ftrScanRestoreSecret7Bytes functions.\r\n\r\n");
	strMsg = strMsg + _T("NOTE: The authorization code can be set ONLY ONCE, and CAN NOT be changed.\r\n\r\n");
	MessageBox( strMsg, _T("--Warning--"), MB_OK|MB_ICONEXCLAMATION);
}

void CDlgOthers::OnButtonSetauthcode() 
{
	CString strMsg;
	strMsg = _T("NOTE: The authorization code can be set ONLY ONCE, and CAN NOT be changed.\r\n\r\n");
	strMsg += _T("Do you want to Set Authorization Code?\r\n\r\n");
	int nRet = MessageBox( strMsg, 0, MB_YESNO|MB_ICONQUESTION );
	if( nRet == IDYES )
	{
		FTRHANDLE hDevice = NULL;
		hDevice = ftrScanOpenDevice();
		if( hDevice )
		{
			if( !ftrScanSetNewAuthorizationCode( hDevice, (PVOID)(LPCTSTR)m_strAuthCode ) )
			{
				m_lblMsg.SetWindowText(GetErrorMessage(_T("Failed to SetNewAuthorizationCode!")));
				ftrScanCloseDevice(hDevice);
				hDevice = NULL;
				return;
			}
			ftrScanCloseDevice(hDevice);
			hDevice = NULL;
			m_lblMsg.SetWindowText(_T("SetNewAuthorizationCode OK!"));	
		}
		else
			m_lblMsg.SetWindowText( _T("Failed to open device!"));	
	}
}

void CDlgOthers::OnButtonReadSecret() 
{
	FTRHANDLE hDevice = NULL;
	hDevice = ftrScanOpenDevice();
	if( hDevice )
	{
		char bufRead[8];
		ZeroMemory( bufRead, 8 );

		if( !ftrScanRestoreSecret7Bytes( hDevice, (PVOID)(LPCTSTR)m_strAuthCode, bufRead ) )
		{
			m_lblMsg.SetWindowText(GetErrorMessage(_T("Failed to RestoreSecret7Bytes!")));
			ftrScanCloseDevice(hDevice);
			hDevice = NULL;
			return;
		}
		ftrScanCloseDevice(hDevice);
		hDevice = NULL;
		m_lblMsg.SetWindowText(_T("RestoreSecret7Bytes OK!"));	
		m_ctrlReadSecret.SetWindowText( bufRead );
	}
	else
		m_lblMsg.SetWindowText( _T("Failed to open device!"));	
}

void CDlgOthers::OnButtonWriteSecret() 
{
	FTRHANDLE hDevice = NULL;
	hDevice = ftrScanOpenDevice();
	if( hDevice )
	{
		if( !ftrScanSaveSecret7Bytes( hDevice, (PVOID)(LPCTSTR)m_strAuthCode, (PVOID)(LPCTSTR)m_strWriteSecret ) )
		{
			m_lblMsg.SetWindowText(GetErrorMessage(_T("Failed to SaveSecret7Bytes!")));
			ftrScanCloseDevice(hDevice);
			hDevice = NULL;
			return;
		}
		ftrScanCloseDevice(hDevice);
		hDevice = NULL;
		m_lblMsg.SetWindowText(_T("SaveSecret7Bytes OK!"));	
	}
	else
		m_lblMsg.SetWindowText( _T("Failed to open device!"));		
}

void CDlgOthers::OnChangeEditAuthorizationCode() 
{
	UpdateData(1);
	if( m_strAuthCode.GetLength() == 7 )
	{
		m_btnSetAuthCode.EnableWindow(1);
		m_btnReadSecret.EnableWindow(1);
		if( m_strWriteSecret.GetLength() == 7 )
			m_btnWriteSecret.EnableWindow(1);		
	}
	else
	{
		m_btnSetAuthCode.EnableWindow(0);	
		m_btnReadSecret.EnableWindow(0);
		m_btnWriteSecret.EnableWindow(0);		
	}
}

void CDlgOthers::OnChangeEditSecretWrite() 
{
	UpdateData(1);
	if( m_strAuthCode.GetLength() == 7  && m_strWriteSecret.GetLength() == 7 )
		m_btnWriteSecret.EnableWindow(1);
	else
		m_btnWriteSecret.EnableWindow(0);		
}

CString CDlgOthers::GetErrorMessage( CString strTitle )
{
	DWORD dwError = GetLastError();
	CString strMsg;
	strMsg = strTitle;

	switch( dwError ) 
	{
	case ERROR_SUCCESS:
		strMsg += "OK";
		break;
	case FTR_ERROR_EMPTY_FRAME:	// ERROR_EMPTY
		strMsg += "- Empty frame -";
		break;
	case FTR_ERROR_MOVABLE_FINGER:
		strMsg += "- Movable finger -";
		break;
	case FTR_ERROR_NO_FRAME:
		strMsg += "- Fake finger detected -";
		break;
	case FTR_ERROR_USER_CANCELED:
		strMsg += "- User canceled -";
		break;
	case FTR_ERROR_HARDWARE_INCOMPATIBLE:
		strMsg += "- Incompatible hardware -";
		break;
	case FTR_ERROR_FIRMWARE_INCOMPATIBLE:
		strMsg += "- Incompatible firmware -";
		break;
	case FTR_ERROR_INVALID_AUTHORIZATION_CODE:
		strMsg += "- Invalid authorization code -";
		break;
	case ERROR_WRITE_PROTECT:
		strMsg += "- Write Protect -";
		break;
	default:
		CString strTemp;
		strTemp.Format( "Unknown return code - %d", dwError );
		strMsg += strTemp;
		break;
	}
	return strMsg;
}

