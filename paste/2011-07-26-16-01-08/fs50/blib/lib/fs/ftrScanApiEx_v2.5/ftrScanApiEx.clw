; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CFtrScanApiExDoc
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "ftrScanApiEx.h"
LastPage=0

ClassCount=7
Class1=CFtrScanApiExApp
Class2=CFtrScanApiExDoc
Class3=CFtrScanApiExView
Class4=CMainFrame

ResourceCount=6
Resource1=IDR_MAINFRAME
Resource2=IDD_ABOUTBOX
Class5=CAboutDlg
Resource3=IDD_DIALOG1 (English (U.S.))
Resource4=IDR_MAINFRAME (English (U.S.))
Class6=CDlgFileName
Resource5=IDD_ABOUTBOX (English (U.S.))
Class7=CDlgOthers
Resource6=IDD_DIALOG_OTHERS

[CLS:CFtrScanApiExApp]
Type=0
HeaderFile=ftrScanApiEx.h
ImplementationFile=ftrScanApiEx.cpp
Filter=N
LastObject=CFtrScanApiExApp

[CLS:CFtrScanApiExDoc]
Type=0
HeaderFile=ftrScanApiExDoc.h
ImplementationFile=ftrScanApiExDoc.cpp
Filter=N
BaseClass=CDocument
VirtualFilter=DC
LastObject=ID_OTHERS_FUNCTIONS

[CLS:CFtrScanApiExView]
Type=0
HeaderFile=ftrScanApiExView.h
ImplementationFile=ftrScanApiExView.cpp
Filter=C
BaseClass=CView
VirtualFilter=VWC
LastObject=CFtrScanApiExView


[CLS:CMainFrame]
Type=0
HeaderFile=MainFrm.h
ImplementationFile=MainFrm.cpp
Filter=T
LastObject=IDM_LFD
BaseClass=CFrameWnd
VirtualFilter=fWC




[CLS:CAboutDlg]
Type=0
HeaderFile=ftrScanApiEx.cpp
ImplementationFile=ftrScanApiEx.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=CAboutDlg

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_INVERTCOLORS
Command2=ID_FILE_SAVE_BITMAP
Command3=ID_APP_EXIT
Command4=IDM_CAPTURE_TO_SCREEN
Command5=IDM_LFD
Command6=ID_APP_ABOUT
CommandCount=6

[ACL:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_EDIT_UNDO
Command5=ID_EDIT_CUT
Command6=ID_EDIT_COPY
Command7=ID_EDIT_PASTE
Command8=ID_EDIT_UNDO
Command9=ID_EDIT_CUT
Command10=ID_EDIT_COPY
Command11=ID_EDIT_PASTE
Command12=ID_NEXT_PANE
Command13=ID_PREV_PANE
CommandCount=13

[MNU:IDR_MAINFRAME (English (U.S.))]
Type=1
Class=CMainFrame
Command1=ID_FILE_INVERTCOLORS
Command2=ID_FILE_SAVE_BITMAP
Command3=ID_APP_EXIT
Command4=IDM_CAPTURE_TO_SCREEN
Command5=ID_CAPTUREFINGER_STARTGETFRAME
Command6=ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE1
Command7=ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE2
Command8=ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE3
Command9=ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE4
Command10=ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE5
Command11=ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE6
Command12=ID_CAPTUREFINGER_STARTGETIMAGE2_NDOSE7
Command13=IDM_LFD
Command14=ID_CAPTUREFINGER_INVERTCOLOR
Command15=ID_STRETCH_100
Command16=ID_STRETCH_50
Command17=ID_STRETCH_25
Command18=ID_OTHERS_FUNCTIONS
Command19=ID_APP_ABOUT
CommandCount=19

[ACL:IDR_MAINFRAME (English (U.S.))]
Type=1
Class=?
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_EDIT_UNDO
Command5=ID_EDIT_CUT
Command6=ID_EDIT_COPY
Command7=ID_EDIT_PASTE
Command8=ID_EDIT_UNDO
Command9=ID_EDIT_CUT
Command10=ID_EDIT_COPY
Command11=ID_EDIT_PASTE
Command12=ID_NEXT_PANE
Command13=ID_PREV_PANE
CommandCount=13

[DLG:IDD_ABOUTBOX (English (U.S.))]
Type=1
Class=CAboutDlg
ControlCount=5
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889
Control5=IDC_DLL_VERSION,static,1342308352

[CLS:CDlgFileName]
Type=0
HeaderFile=DlgFileName.h
ImplementationFile=DlgFileName.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC

[DLG:IDD_DIALOG1 (English (U.S.))]
Type=1
Class=?
ControlCount=4
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Control4=IDC_FILENAME,edit,1350631552

[DLG:IDD_DIALOG_OTHERS]
Type=1
Class=CDlgOthers
ControlCount=34
Control1=IDC_STATIC,button,1342177287
Control2=IDC_STATIC,static,1342308352
Control3=IDC_BUTTON_REFRESH,button,1342242816
Control4=IDC_EDIT_DEVICEMODEL,edit,1350633600
Control5=IDC_STATIC,static,1342308352
Control6=IDC_EDIT_VERSIONINFO,edit,1350633600
Control7=IDC_STATIC,button,1342177287
Control8=IDC_STATIC,static,1342308352
Control9=IDC_EDIT_SETGREEN,edit,1350631552
Control10=IDC_STATIC,static,1342308352
Control11=IDC_EDIT_SETRED,edit,1350631552
Control12=IDC_BUTTON_SETLEDS,button,1342242816
Control13=IDC_STATIC,static,1342177296
Control14=IDC_STATIC,static,1342308352
Control15=IDC_STATIC,static,1342308352
Control16=IDC_EDIT_GETGREEN,edit,1350633600
Control17=IDC_STATIC,static,1342308352
Control18=IDC_EDIT_GETRED,edit,1350633600
Control19=IDC_STATIC,button,1342177287
Control20=IDC_EDIT_7BYTES_WRITE,edit,1350631552
Control21=IDC_BUTTON_WRITE7BYTES,button,1476460544
Control22=IDC_EDIT_7BYTES_READ,edit,1350633600
Control23=IDC_BUTTON_READ7BYTES,button,1342242816
Control24=IDC_STATIC,button,1342177287
Control25=IDC_STATIC,static,1342308352
Control26=IDC_EDIT_AUTHORIZATION_CODE,edit,1350631552
Control27=IDC_BUTTON_SETAUTHCODE,button,1476460544
Control28=IDC_STATIC,static,1342308352
Control29=IDC_EDIT_SECRET_WRITE,edit,1350631552
Control30=IDC_BUTTON_WRITE_SECRET,button,1476460544
Control31=IDC_BUTTON_READ_SECRET,button,1476460544
Control32=IDC_EDIT_SECRET_READ,edit,1350633600
Control33=IDC_ALERT,button,1342242827
Control34=IDC_LBL_MESSAGE,static,1342312448

[CLS:CDlgOthers]
Type=0
HeaderFile=DlgOthers.h
ImplementationFile=DlgOthers.cpp
BaseClass=CDialog
Filter=D
LastObject=CDlgOthers
VirtualFilter=dWC

