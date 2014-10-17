#ifndef __LianxiScene_H__
#define __LianxiScene_H__

#include "cocos2d.h"
#include "TouchLayer.h"
#include "BackgroundLayer.h"
#include "TcharacterLayer.h"
#include "HcharacterLayer.h"
#include "CharacterExtend.h"
USING_NS_CC;


class LianxiScene : public CCScene
{
public:
	LianxiScene(string hanzi);
	~LianxiScene();
	//CREATE_FUNC(LianxiScene);
	static LianxiScene* create(string hanzi);
	virtual bool init();

	string CurrentCharacter;			//��ǰ������ϰ�ĺ����ַ�
	string funcs;

// 	BackgroundLayer* backgroundLayer;		//����ͼ��
// 	TouchLayer* touchLayer;			//�����¼���Ӧ��
// 	TcharacterLayer* TLayer;			//����ͼ��
// 	HcharacterLayer* HLayer;
	CC_SYNTHESIZE_RETAIN(BackgroundLayer*,backgroundLayer,backgroundLayer);
	CC_SYNTHESIZE_RETAIN(TouchLayer*,touchLayer,touchLayer);
	CC_SYNTHESIZE_RETAIN(TcharacterLayer*,TLayer,TLayer);
	CC_SYNTHESIZE_RETAIN(HcharacterLayer*,HLayer,HLayer);
	CC_SYNTHESIZE_RETAIN(CharacterEntity*,p,CharacterP);
	CC_SYNTHESIZE_RETAIN(CharacterExtend*,ext_p,CharacterExt);
private:

};



#endif
