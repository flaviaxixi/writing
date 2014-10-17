--��װ��׼���ֵ���Ϣ



local setmetatable = setmetatable
local pairs = pairs
local string = string
local tonumber = tonumber
local print = print
local math = math
local table =  table
local type = type

module("StandardZiInfo")

POINT = { GeoType = "KPOINT", x = 0, y = 0}
BH = { GeoType = "KBH", ptSet = {}, InflectionPoint = {}, }
StdHZ = { strokeNum = 0, strokes = {}, strokeStrings = {}  }

--split ������sep�Ǵ��з��ַ�����signΪ�ָ��ַ�
function string:split(sep,sign)
	local sep, fields = sep or "\t", {}
	local pattern = string.format("([^"..sign.."]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end


--##### �趨��׼������Ϣ end#####--

--##### �� begin#####--
function POINT:new(o)
	local o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end
--##### �� end#####--

--##### �ʻ�begin#####--
function BH:new(o)
	local o = o or {}
	o.ptSet = {}
	o.InflectionPoint = {}
	o.BDSet = {}
	setmetatable(o,self)
	self.__index = self
	return o
end

--���㼯�ַ����ָ����ʼ���ʻ��ĵ㼯
function BH:splitPoints(ptStr)
	local ptSet = {}
	for strx,stry in string.gmatch(ptStr,"(%d+)/(%d+)") do
		local pt = {}
		pt.x = tonumber(strx)
		pt.y = tonumber(stry)
		ptSet[#ptSet+1] = pt
	end
	self.ptSet = ptSet
end

function sortingFun(a,b)
	if b.angle < a.angle then
			return false
	elseif b.angle > a.angle then
			return true
	else
			return false
	end
end



--#####��д�� begin#####--
function StdHZ:new()
	local o = o or {}
	o.strokes = {}
	o.strokeStrings = {}
	setmetatable(o,self)
	self.__index = self
	return o
end

--�з��ַ���
function splitPoints(ptStr,ptSet)
	for strx,stry in string.gmatch(ptStr,"(%d+)/(%d+)") do
		local pt = {}
		pt.x = tonumber(strx)
		pt.y = tonumber(stry)
		ptSet[#ptSet+1] = pt
	end
end


function StdHZ:initialize(str)
	local strokeStrs  = {}
	strokeStrs  = str:split(str,"@")
	self:initStrokeStrs(strokeStrs)
	self:initStrokeNum(#strokeStrs)
end


--��ʼ����д�ֱʻ�������Ϣ
function StdHZ:initStrokeNum(strokeNum)
	self.strokeNum = strokeNum
end


--��ʼ����д�ֵ㼯��Ϣ
function StdHZ:initStrokeStrs( strokeStrs )
	for _,v in pairs(strokeStrs) do
		self.strokeStrings[#self.strokeStrings+1] = v
	end
	self:initStrokes()
end


--��ʼ���ʻ���Ϣ
function StdHZ:initStrokes()
	for i=1,#self.strokeStrings do
		local str = self.strokeStrings[i]
		local onestroke = BH:new()
		onestroke:splitPoints(str)
		self.strokes[#self.strokes+1] = onestroke
	end
end



function StdHZ:clearData()
	self.strokeNum = 0
	self.strokeStrings = {}
	self.strokes = {}
end

--#####��д�� end#####--



