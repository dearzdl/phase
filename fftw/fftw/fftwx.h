#pragma once
#include "fftw3.h"

class CFFT_Wrapper
{
public:
	//************************************
	// Method:    FFT ����ʵ���鲿
	// FullName:  CFFT_Wrapper::FFT
	// Access:    public static 
	// Returns:   int ����ֵ������_EER_CODE_
	// Qualifier:
	// Parameter: double * apInput		 ����ʵ��һά���� 
	// Parameter: double * apOutPutReal  ���ʵ������
	// Parameter: double * apOutPutImg   ����鲿���� 
	// Parameter: int anInputLength		 ���볤��
	// Parameter: int & anOutputLength   ������ȣ�����
	//************************************
	static int FFT( double * apInput,
					double * apOutPutReal,
					double * apOutPutImg,
					int   anInputLength,
					int& anOutputLength); 
	
	//************************************
	// Method:    FFT2 ���ط�ֵ��λ
	// FullName:  CFFT_Wrapper::FFT2
	// Access:    public static 
	// Returns:   int ����ֵ������_EER_CODE_
	// Qualifier:
	// Parameter: double * apInput		 ����ʵ��һά���� 
	// Parameter: double * apOutPutAmp   �����ֵ����
	// Parameter: double * apOutPutPhase �����λ���� 
	// Parameter: int anInputLength		 ���볤��
	// Parameter: int & anOutputLength   ������ȣ�����
	//************************************
	static int FFT2( double * apInput,
					double * apOutPutAmp,
					double * apOutPutPhase,
					int   anInputLength,
					int& anOutputLength); 

	//************************************
	// Method:    FFT3 ������FFT,�������ֹ��2����������
	// FullName:  CFFT_Wrapper::FFT3
	// Access:    public static 
	// Returns:   int
	// Qualifier:
	// Parameter: double * apInput
	// Parameter: double * apOutPutAmp
	// Parameter: double * apOutPutPhase
	// Parameter: int anInputLength
	// Parameter: int & anOutputLength
	//************************************
	static int FFT3( double * apInput,
					 double * apOutPutAmp,
					 double * apOutPutPhase,
					 int   anInputLength,
					 int& anOutputLength); 

	static int APFFT(	double *apInput,
						double * apInputFreqSequenceToAdjust,
						double * apOutPutAmp,
						double * apOutPutPhase,
						double * apOutPutFrequence,
						int anInputLength,
						int anFreqSequenceLength,
						int& anOutputLength);
	enum _EER_CODE_
	{
		ERR_NO_ERROR = 0,
		ERR_NULL_INPUT_BUFFER ,
		ERR_NULL_OUTPUT_IMG_BUFFER ,
		ERR_NULL_OUTPUT_REAL_BUFFER ,
		ERR_INVALID_INPUT_LENGTH,
		ERR_INVALID_INPUT_FREQUENCE_LENGTH,
		ERR_NOT_ENOUGH_OUTPUT_BUFFER_LENGTH,
		ERR_NULL_OUTPUT_AMP_BUFFER ,
		ERR_NULL_OUTPUT_PHASE_BUFFER ,
		ERR_NULL_OUTPUT_FREQ_BUFFER,
		ERR_NULL_INPUT_FREQ_SEQUENCE_BUFFER,
	};
protected:
private:
};




