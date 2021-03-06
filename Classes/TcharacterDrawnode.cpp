#include "TcharacterDrawnode.h"
#include "ReadXML.h"
#include "SqliteHelper.h"
#include "CharacterEntity.h"
#include "SQLiteData.h"

TcharacterDrawnode::TcharacterDrawnode():strokedrawList(NULL),
	visibleIndex(-1)
{
	
}

TcharacterDrawnode::~TcharacterDrawnode()
{
// 	for (int i = 0 ; i < strokedrawList.size(); i++)
// 	{
// 		StrokeDrawnode* temp = strokedrawList.back();
// 		strokedrawList.pop_back();
// 		temp->release();
// 	}
// 	CCLog("TcharacterDrawnode ref  %d",this->m_uReference);
	CC_SAFE_RELEASE(strokedrawList);
}

bool TcharacterDrawnode::init(string hz,CCSize showrect,CharacterEntity* p){
// 	CharacterEntity* p = new CharacterEntity();
// 	SQLiteData::getHanziData(hz,p);

// 	string dbpath = CCFileUtils::sharedFileUtils()->fullPathForFilename("test.db");
// #if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
// 	unsigned long int size = 0;
// 	char* pFileContent = (char*)CCFileUtils::sharedFileUtils()->getFileData(dbpath.c_str(),"rb",&size);
// 	CCLog("file %s",pFileContent);
// 	dbpath = CCFileUtils::sharedFileUtils()->getWritablePath()+"test.db";
// 	FILE* file = fopen(dbpath.c_str(),"w");
// 	if (file != NULL)
// 	{
// 		CCLog("file not NULL");
// 		file = fopen(dbpath.c_str(),"wb");
// 		fwrite(pFileContent,size,1,file);
// 		CC_SAFE_DELETE_ARRAY(pFileContent);
// 	}else{
// 		CCLog("file NULL");
// 	}
// 	fclose(file);
// #endif
// 	SqliteHelper::initDB(dbpath.c_str());
// 	string sql = "select * from table_test where name='"+hz+"'";
// 	CharacterEntity* p = new CharacterEntity();
// 	SqliteHelper::getDataInfo(sql,p);
// 	SqliteHelper::closeDB();
	strokedrawList = CCArray::create();
	strokedrawList->retain();

	CReadXML readxml(p->getXML()->getCString());
	this->m_character = readxml.getCharacter();
	this->showRect = showrect;

	this->m_character.getBox();
	this->m_character.resize(showRect);
	this->m_character.resample();

	vector<Bujian> bujianList = this->m_character.bujianList;
	vector<Bujian>::iterator iter = bujianList.begin();
	for (iter ; iter != bujianList.end() ; ++ iter)
	{
		Bujian bujian = (Bujian)*iter;
		vector<Stroke> strokeList = bujian.strokeList;
		for (int i = 0 ; i < strokeList.size() ; i++)
		{
			this->getstrokedrawList()->addObject(StrokeDrawnode::create(strokeList.at(i)));
			// 			strokeDrawnode->retain();
		}
	}
	return true;
}

TcharacterDrawnode* TcharacterDrawnode::create(string hz,CCSize showrect,CharacterEntity* p){
	TcharacterDrawnode* pRet = new TcharacterDrawnode();
	if (pRet && pRet->init(hz,showrect,p))
	{
		pRet->autorelease();
		return pRet;
	}else
	{
		delete pRet;
		pRet = NULL;
		return NULL;
	}
}

void TcharacterDrawnode::draw(){
	//CCLog("TcharacterDrawnode::draw");
// 	vector<StrokeDrawnode*>::iterator iter = strokedrawList.begin();
// 	for (iter ; iter != strokedrawList.end(); ++iter)
// 	{
// 		StrokeDrawnode* no = (StrokeDrawnode*)*iter;
// 		no->draw();
// 	}
// 	if (visibleStroke == -1) {
// 
// 	} else {
// 		CCObject* ob;
// 		int i = 0;
// 		CCARRAY_FOREACH(strokedrawList,ob){
// 			if (i >= visibleStroke) {
// 				return;
// 			}
// 			((StrokeDrawnode*)(ob))->draw();
// 		}
// 	}
	CCObject* ob;
	CCARRAY_FOREACH(strokedrawList,ob){
		((StrokeDrawnode*)(ob))->draw();
	}
}

int TcharacterDrawnode::getPointsCount(){
	CCObject* ob;
	int count = 0;
	CCARRAY_FOREACH(strokedrawList,ob){
		count += ((StrokeDrawnode*)(ob))->getStroke().getPointsCount();
	}
	return count;
}

void TcharacterDrawnode::setVisibleIndex(int vi){
	if (vi >= getstrokedrawList()->count())
	{
		this->visibleIndex = getstrokedrawList()->count();
	}else{
		this->visibleIndex = vi;
	}
}