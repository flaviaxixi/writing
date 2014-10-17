#ifndef __SQLiteData_H_
#define __SQLiteData_H_

#include "cocos2d.h"
USING_NS_CC;
using namespace std;

class SQLiteData
{
public:
	SQLiteData();
	~SQLiteData();
	/*
		��ȡ���ݿ��к�����Ϣ
	*/
	static void getHanziData(string hz,CCObject* p);
	/*
		��ȡ������strokeFunc����Ϣ
	*/
	static string getstrokeFunc(string strokeID);
	/*
		�������ݿ���strokeIDSeq�ֶ�
	*/
	static vector<string> splitStrokeSeq(string seq);
	/*
		��ȡ�ɽ�����ĺ���
	*/
	static void getHanziDataExtend(string hz,CCObject* p);
};



#endif