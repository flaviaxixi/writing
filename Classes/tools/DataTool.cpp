#include "DataTool.h"

using namespace std;

DataTool::DataTool(void)
{
}


DataTool::~DataTool(void)
{
}

//string DataTool::GB2312ToUTF8(string strGBK){
//	string strOutUTF8 = "";
//
//#if WIN32
//
//	WCHAR * str1;
//
//	int n = MultiByteToWideChar(CP_ACP, 0, strGBK.c_str(), -1, NULL, 0);
//
//	str1 = new WCHAR[n];
//
//	MultiByteToWideChar(CP_ACP, 0, strGBK.c_str(), -1, str1, n);
//
//	n = WideCharToMultiByte(CP_UTF8, 0, str1, -1, NULL, 0, NULL, NULL);
//
//	char * str2 = new char[n];
//
//	WideCharToMultiByte(CP_UTF8, 0, str1, -1, str2, n, NULL, NULL);
//
//	strOutUTF8 = str2;
//
//	delete[]str1;
//
//	str1 = NULL;
//
//	delete[]str2;
//
//	str2 = NULL;
//
//#else
//
//	strOutUTF8 = strGBK;
//
//#endif
//
//	return strOutUTF8;
//}
//
//
////UTF8��GBK֮���ת��
//string DataTool::GBKToUTF8(string gbk)
//{
//	//����һ���ڴ��
//	char *szOut=new char[gbk.size()+2];
//	//���ڴ�ȫ��Ϊ0;
//	memset(szOut,0,gbk.size()+2);
//	//��������ʶ��Strcpy
//	memcpy(szOut,gbk.c_str(),strlen(gbk.c_str()));
//	char* strGBK = szOut;
//	//ӳ��һ���ַ�����һ�����ַ���unicode�����ַ���
//	int len=MultiByteToWideChar(CP_ACP, 0, (LPCSTR)strGBK, -1, NULL,0);
//	unsigned short * wszUtf8 = new unsigned short[len+1];
//	memset(wszUtf8, 0, len * 2 + 2);
//	MultiByteToWideChar(CP_ACP, 0, (LPCSTR)strGBK, -1, (LPWSTR)wszUtf8, len);
//	len = WideCharToMultiByte(CP_UTF8, 0, (LPWSTR)wszUtf8, -1, NULL, 0, NULL, NULL);
//	char *szUtf8=new char[len + 1];
//	memset(szUtf8, 0, len + 1);
//	WideCharToMultiByte (CP_UTF8, 0, (LPWSTR)wszUtf8, -1, szUtf8, len, NULL,NULL);
//	string result=szUtf8;
//	delete[] szUtf8;
//	delete[] wszUtf8;
//	delete[] szOut;
//	return result;
//}

string DataTool::intTostring(int a){
	stringstream s;
	s << a;
	return s.str();
}
