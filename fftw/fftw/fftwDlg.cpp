// fftwDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "fftw.h"
#include "fftwDlg.h"
#include ".\fftwdlg.h"
#include "fftw3.h"
#include "fftwx.h"
#include <fstream>
#include <vector>
#include <iostream>
#include <iosfwd>
#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CfftwDlg 对话框



CfftwDlg::CfftwDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CfftwDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CfftwDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CfftwDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()


// CfftwDlg 消息处理程序

BOOL CfftwDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// 将\“关于...\”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码
	
	return TRUE;  // 除非设置了控件的焦点，否则返回 TRUE
}

void CfftwDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}



// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CfftwDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标显示。
HCURSOR CfftwDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CfftwDlg::OnBnClickedOk()
{
	// TODO: 在此添加控件通知处理程序代码
	//1.load data
	std::ifstream lofile;
	lofile.open("wave_001.txt");
	char lpLineBuffer[1024]={0};
	std::vector<double> lvoData;
	std::vector<double> lvoAmp;
	std::vector<double> lvoPhase;
	std::vector<double> lvoFreq;
	std::vector<double> lvoFreqToAdjust;
	while (!lofile.eof())
	{		
		double ldblData = 0;
		lofile>>ldblData;
		lvoData.push_back(ldblData);
	}
	
	//1. test fft
	lvoAmp.resize(lvoData.size());
	lvoPhase.resize(lvoData.size());
	int lnDataSize = lvoData.size();
	int lnRet =0;
	
/*
	 lnRet =CFFT_Wrapper::FFT2(&lvoData.front(),
		&lvoAmp.front(),
		&lvoPhase.front(),
		lvoData.size(),
		lnDataSize);
	ASSERT(lnRet == CFFT_Wrapper::ERR_NO_ERROR);*/

	//2. test apfft
	double ldblSampeRate = 25600;

	double ldblF0 =25.00;

	lvoAmp.clear();

	lvoPhase.clear();

	lvoFreq.clear();

	lvoAmp.resize(lvoData.size());

	lvoPhase.resize(lvoData.size());

	lvoFreq.resize(lvoData.size());

	lvoFreqToAdjust.clear();

	lvoFreqToAdjust.push_back(ldblF0);

	lvoFreqToAdjust.push_back(ldblF0*2);

	lvoFreqToAdjust.push_back(ldblF0*3);

	lvoFreqToAdjust.push_back(ldblF0*4);

	lnDataSize = lvoData.size();

	lnRet = CFFT_Wrapper::APFFT(&lvoData.front(),
								&lvoFreqToAdjust.front(),
								&lvoAmp.front(),
								&lvoPhase.front(),
								&lvoFreq.front(),
								ldblSampeRate,
								lvoData.size()-1,
								lvoFreqToAdjust.size(),
								lnDataSize);

}
