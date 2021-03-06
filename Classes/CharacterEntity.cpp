#include "CharacterEntity.h"

CharacterEntity::CharacterEntity():id(NULL),name(NULL),xml(NULL),rules(NULL),strokeIDSeq(NULL)
{
}

CharacterEntity::~CharacterEntity()
{
	CC_SAFE_RELEASE(id);
	CC_SAFE_RELEASE(name);
	CC_SAFE_RELEASE(xml);
	CC_SAFE_RELEASE(rules);
	CC_SAFE_RELEASE(strokeIDSeq);
}