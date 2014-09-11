// fftwDlg.cpp : ʵ���ļ�
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
#include "Sigdefine.h"
#include "SigMath.h"
#include "DebugHelper.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// ����Ӧ�ó��򡰹��ڡ��˵���� CAboutDlg �Ի���

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// �Ի�������
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

// ʵ��
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


// CfftwDlg �Ի���



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


// CfftwDlg ��Ϣ�������

BOOL CfftwDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// ��\������...\���˵�����ӵ�ϵͳ�˵��С�

	// IDM_ABOUTBOX ������ϵͳ���Χ�ڡ�
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

	// ���ô˶Ի����ͼ�ꡣ��Ӧ�ó��������ڲ��ǶԻ���ʱ����ܽ��Զ�
	//  ִ�д˲���
	SetIcon(m_hIcon, TRUE);			// ���ô�ͼ��
	SetIcon(m_hIcon, FALSE);		// ����Сͼ��

	// TODO: �ڴ���Ӷ���ĳ�ʼ������
	
	return TRUE;  // ���������˿ؼ��Ľ��㣬���򷵻� TRUE
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



// �����Ի��������С����ť������Ҫ����Ĵ���
//  �����Ƹ�ͼ�ꡣ����ʹ���ĵ�/��ͼģ�͵� MFC Ӧ�ó���
//  �⽫�ɿ���Զ���ɡ�

void CfftwDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // ���ڻ��Ƶ��豸������

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// ʹͼ���ڹ��������о���
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// ����ͼ��
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//���û��϶���С������ʱϵͳ���ô˺���ȡ�ù����ʾ��
HCURSOR CfftwDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CfftwDlg::OnBnClickedOk()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	//1.load data
	char lpLineBuffer[1024]={0};
	std::vector<double> lvoData;
	std::vector<double> lvoAmp;
	std::vector<double> lvoPhase;
	std::vector<double> lvoFreq;
	std::vector<double> lvoFreqToAdjust;

	double ldblSampeRate = 25600;
	double ldblF0 =25;
	CString lstrfilename = "wave_001.txt";
	//lstrfilename = "Vib740ST0101B1H_2014-08-29 225812.090.txt";
	//lstrfilename = "K4003_1H2014-08-28 152028.637.txt";
	std::ifstream lofile(lstrfilename.GetBuffer(0), ios::in);
	
	//lofile.open("wave001.txt");
	//("C:/Users/eric/Documents/GitHub/phase/fftw/fftw/Debug/wave001.txt",ios::in);

	DWORD ldwRet = ::GetLastError();
	if (!lofile)
	{
		 ldwRet = ::GetLastError();
		CString lstrError;
		lstrError.Format(_T("%s ������"),lstrfilename);
		 AfxMessageBox(lstrError);
		 return;
	}
	
	while (!lofile.eof())
	{		
		//lofile.read(lpLineBuffer,100);
		double ldblData = 0;
		lofile>>ldblData;
		//TRACE(_T("%f\r\n"),ldblData);
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


	lvoAmp.clear();

	lvoPhase.clear();

	lvoFreq.clear();

	lvoAmp.resize(lvoData.size());

	lvoPhase.resize(lvoData.size());

	lvoFreq.resize(lvoData.size());

	lvoFreqToAdjust.clear();

	lvoFreqToAdjust.push_back(ldblF0*0.5);

	lvoFreqToAdjust.push_back(ldblF0*1);

	lvoFreqToAdjust.push_back(ldblF0*2);

	lvoFreqToAdjust.push_back(ldblF0*3);

	lnDataSize = lvoData.size();

	_DECLARE_PERF_MEASURE_TIME()


	CSigMath SigMath;		 
	vector<SSigParam> vSigComponet;
	vSigComponet.resize(10);
	double fSpecCorrectFreq_;
	fSpecCorrectFreq_ = double(ldblF0);
	int iSampleRate = ldblSampeRate;



	_BEGIN_PERF_MEASURE_TIME();

	lnRet = CFFT_Wrapper::APFFT(&lvoData.front(),
								&lvoFreqToAdjust.front(),
								&lvoAmp.front(),
								&lvoPhase.front(),
								&lvoFreq.front(),
								ldblSampeRate,
								lvoData.size(),
								lvoFreqToAdjust.size(),
								lnDataSize,4);

	_END_PERF_MEASURE_TIME("APFFT");


	_BEGIN_PERF_MEASURE_TIME();
	int iRes = SigMath.GetCalibratedSpectrumCharInfo(&lvoData.front(), 
		fSpecCorrectFreq_, 
		iSampleRate, 
		lvoData.size(), 
		vSigComponet, 
		E_SpectrumType_Peak_Peak);	

	_END_PERF_MEASURE_TIME("GetCalibratedSpectrumCharInfo");


	for (int i=0;i<lvoFreqToAdjust.size();i++)
	{

		zdlTraceLine("**********************************************");
		zdlTraceLine(_T("Ap_FFT: Freq:%.4f,Amp:%.4f,Phase:%.4f"),lvoFreq[i],lvoAmp[i],lvoPhase[i]);
		zdlTraceLine(_T("OlD_FFT: Freq:%.4f,Amp:%.4f,Phase:%.4f"),vSigComponet[i]._fFreq,vSigComponet[i]._fAmp,vSigComponet[i]._fPhase);
	}




}
