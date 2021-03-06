#include "StrokeDrawnode.h"

StrokeDrawnode::StrokeDrawnode():visibleIndex(-1)
{
}

StrokeDrawnode::StrokeDrawnode(Stroke stro):visibleIndex(-1){
	this->stroke = stro;
}

void StrokeDrawnode::onEnter(){
	CCNode::onEnter();
}

void StrokeDrawnode::onExit(){
	CCNode::onExit();
}

StrokeDrawnode* StrokeDrawnode::create(Stroke stro){
	StrokeDrawnode* pRet = new StrokeDrawnode(stro);
	if (pRet && pRet->init())
	{
		pRet->autorelease();
		return pRet;
	}else{
		delete pRet;
		pRet = NULL;
		return NULL;
	}
}

StrokeDrawnode::~StrokeDrawnode()
{

}

void StrokeDrawnode::draw(){
	//CCLog("StrokeDrawnode::draw");
	//在这里设定笔画的粗细和颜色。 具体要查看
	glLineWidth(10.0f);					//笔画粗细
	ccDrawColor4F(0,0,0,1);				//笔画颜色
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//	glHint(GL_POINT_SMOOTH_HINT,GL_NICEST);
// 	glEnable(GL_LINE_SMOOTH);
	if (visibleIndex == -1)
	{
		CCPoint pre = stroke.pointList[0];					//直接拿了pointList第一个值
		for (int i = 1; i< stroke.getPointsCount(); i++)
		{
			ccDrawLine(pre,stroke.pointList[i]);
			pre = stroke.pointList[i];
		}
	}else
	{
		CCPoint pre = stroke.pointList[0];					//直接拿了pointList第一个值
		for (int i = 1; i< stroke.getPointsCount() && i < visibleIndex; i++)
		{
			ccDrawLine(pre,stroke.pointList[i]);
			pre = stroke.pointList[i];
		}
	}
// 	glDisable(GL_LINE_SMOOTH);
}

void StrokeDrawnode::addPoint(CCPoint point){
	this->stroke.addPoint(point);
}

void StrokeDrawnode::setVisibleIndex(int vi){
	if (vi >= stroke.getPointsCount())
	{
		this->visibleIndex = stroke.getPointsCount();
	}else{
		this->visibleIndex = vi;
	}
}
