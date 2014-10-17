-----------------------------------------
--Ԫ������
--TODO�����ַ��������շ���һ���ַ������������ʹ��
--TODO ԭ�����쳣�������������жϣ��߽��жϵȵ�
-----------------------------------------

local print = print
local type = type
local loadstring = loadstring
local math = math
local pairs = pairs
local error = error
module("BaseLib")

local WriteHZ  = nil
local HZStruct = nil
local RunRule = nil
local WZEnv = nil
local StdHZ = nil

--�������н��������Ϣ
allInfoStr = ""
retInfoStr = ""

--#####���л������ú���#####--
function clearRetInfoStr()
	retInfoStr = ""
end

function setWriteZiInfo(WZ)
	WriteHZ = WZ
end

function setHZStruct(HS)
	HZStruct = HS
end

function setAllRule(RC)
	RunRule = RC
end


function setWZEnv(env)
	WZEnv = env
end

function setStdHZ(SZ)
	StdHZ = SZ
end
--#####Ԫ����ʵ��#####--
--���в���������0��ʼ
function GetBH( idx )
	local bh = WriteHZ.strokes[idx + 1]
	return bh
end

--����Ϊbd��bh����
function GetStartPoint(bh)
	local point = WZEnv.POINT:new()
	point.x = bh.ptSet[1].x
	point.y = bh.ptSet[1].y
	return point
end

function GetEndPoint(bh)
	local point = WZEnv.POINT:new()
	point.x = bh.ptSet[#bh.ptSet].x
	point.y = bh.ptSet[#bh.ptSet].y
	return point
end

--����е�
function	GetMidPoint ( bh )
 	local point = WZEnv.POINT:new()
	local len= #bh.ptSet
	local tmpIdx = math.floor ( len / 2 )
	point.x = bh.ptSet[tmpIdx].x
	point.y = bh.ptSet[tmpIdx].y
	return point
end


--��õ�ĺ�������
function GetPointX ( pt )
	return pt.x
end

function GetPointY ( pt )
	return pt.y
end



--��ȡĳһ�ʶ� �ʶ�������0��ʼ
function GetBDByBH(bh,bdIdx)
	local bd = WZEnv.BD:new()
	local preIdx = 1
	local postIdx = #bh.ptSet
	if (bdIdx ~= 0) then
		preIdx = bh.InflectionPoint[bdIdx ]
	end

	if (bdIdx < #bh.InflectionPoint) then
	   postIdx = bh.InflectionPoint[bdIdx + 1]
	end
	local bdPtSet = {}
	for i = preIdx, postIdx do
		bd.ptSet[#bd.ptSet + 1] = bh.ptSet[i]
	end
	return bd
end


function GetBDLen(bd)
	local len = 0
	for i = 1,#bd.ptSet - 1 do
		local curpt = bd.ptSet[i]
		local nextpt = bd.ptSet[i+1]
		local dis = math.sqrt( math.pow(curpt.x - nextpt.x,2) + math.pow(curpt.y - nextpt.y,2))
		len = len + dis
	end
	return len
end


--����curIdx��Ӧ�ĽǶ�

function Cal_Angle(prePt,curPt,postPt)
	local vecX = {}
	local vecY = {}
	vecX.x = prePt.x - curPt.x
	vecX.y = prePt.y - curPt.y
	vecY.x = postPt.x - curPt.x
	vecY.y = postPt.y - curPt.y
	disX = math.sqrt(vecX.x*vecX.x + vecX.y*vecX.y)
	disY = math.sqrt(vecY.x*vecY.x + vecY.y*vecY.y)
	cosXY = ( vecX.x*vecY.x + vecX.y*vecY.y )/(disX*disY)
	return  math.deg(math.acos(cosXY))
end


--[[
function Cal_Angle(prept,curpt,postpt)
	local a2 = (prept.x - curpt.x)*(prept.x - curpt.x) + (prept.y - curpt.y)*(prept.y - curpt.y)
	local b2 = (postpt.x - curpt.x)*(postpt.x - curpt.x) + (postpt.y - curpt.y)*(postpt.y - curpt.y)
	local c2 = (postpt.x - prept.x)*(postpt.x - prept.x) + (postpt.y - curpt.y)*(postpt.y - curpt.y)
	local a = math.sqrt(a2)
	local b = math.sqrt(b2)
	cosXY = (a2 + b2 - c2)/(2*a*b)
	return math.acos(cosXY)
end
]]
function sortingFun(a,b)
	if b.angle < a.angle then
			return false
	elseif b.angle > a.angle then
			return true
	else
			return false
	end
end


function GetAngel(spt,ept)
	local degree = 0
	if (math.abs(spt.x - ept.x)>0.0001 ) then
		degree = math.deg(math.atan( (ept.y- spt.y) / (ept.x - spt.x)))

	if (degree < 0) then
			degree = degree + 180
		end

	else
		if (ept.y < spt.y) then
			degree = -90
		else
			degree = 90
		end
	end
	return degree
end




--��д
function GetTurningPtNum(bh,BDNum)
	local height = 512
	local threshold_len = height / 28
	local threshold_count = 7

	local turning_ind = {}

	local len = GetBDLen(bh)
	if (len < threshold_len or #bh.ptSet <threshold_count  ) then
		return 0
	end

	local index_begin = 1
	local index_candidate = 4
	local index_end = 7

	while (index_end < #bh.ptSet - 1) do
		local it0 = bh.ptSet[1]
		local it1 = bh.ptSet[1]
		local it2 = bh.ptSet[1]
		local it0_index,it1_index,it2_index
		for i = 1,index_begin do
			it0 = bh.ptSet[i]
			it0_index = i
		end


		for i = 1, index_candidate do
			it1 = bh.ptSet[i]
			it1_index = i
		end


		for i = 1,index_end  do
			it2 = bh.ptSet[i]
			it2_index = i
		end


		local pt1 = it0
		local pt2 = it1
		local pt3 = it2

		local ang1 = GetAngel(pt1,pt2)
		local ang2 = GetAngel(pt2,pt3)
		local dis = math.abs(ang1 - ang2)

		if (dis > 180) then
			dis = 360 - dis
		end
		if (dis > 55) then
			if (#bh.ptSet - 1 - index_candidate < 4) then
				turning_ind[#turning_ind + 1] = index_candidate
				index_begin = index_candidate
				index_candidate = index_begin + 3
				index_end = index_candidate + 3
			else
				it1_index = it1_index + 1
				it2_index = it2_index + 1
				it1 = bh.ptSet[it1_index]
				it2 = bh.ptSet[it2_index]
				local a1 = GetAngel(it0,it1)
				local a2 = GetAngel(it1,it2)
				local dis1 = math.abs(a2 - a1)
				if(dis1 > 180) then
					dis1 = 360 - dis1
				end
				it1_index = it1_index + 1
				it2_index = it2_index + 1
				it1 =  bh.ptSet[it1_index]
				it2 = bh.ptSet[it2_index]
				a1 = GetAngel(it0,it1)
				a2 = GetAngel(it1,it2)
				local dis2 = math.abs(a2-a1)
				if(dis2 > 180) then
					dis2 = 360 - dis2
				end
				local f = math.max(dis,dis1,dis2)
				if (f == dis) then
					turning_ind[#turning_ind + 1] = index_candidate
					index_begin = index_candidate
					index_candidate = index_candidate + 3
					index_end = index_candidate + 3
				end

				if (f == dis1) then
					turning_ind[#turning_ind + 1] = index_candidate + 1
					index_begin = index_candidate + 1
					index_candidate = index_candidate + 4
					index_end = index_candidate + 3
				end


				if (f == dis2)then
					turning_ind[#turning_ind + 1] = index_candidate + 2
					index_begin = index_candidate + 2
					index_candidate = index_candidate + 5
					index_end = index_candidate + 3
				end

				it1_index = it1_index - 2
				it2_index = it2_index - 2
				it1 = bh.ptSet[it1_index]
				it2 = bh.ptSet[it2_index]
			end
		else
		index_candidate =  index_candidate + 1
		index_end = index_end + 1
	end
end

--[[test
for i = 1,#turning_ind do
	print (i,turning_ind[i])
end
]]

---------------------------------ȥ������-----------------------------------------------
--���ѡ���Ĺյ���ĿΪ0��ֱ�ӷ��أ���ʱCInflectionPts�ǿյ�
	if(#turning_ind <= 0) then
		return 0
	end
	--����յ���Ŀ�ȱ�׼�٣����յ����鸳ֵ������
	if (#turning_ind < BDNum - 1) then
		bh.InflectionPoint = turning_ind
		return #turning_ind;
	end


	--����յ���Ŀ���ڻ��ߵ��ڱ�׼ֵ
	if (#turning_ind >= BDNum-1) then
		--������һ���յ㣬α�յ�һ�����ڵ�һ���������һ�����ֱ�����������λ��ľ���
		local pos1 = turning_ind[1]
		local pos2 = turning_ind[#turning_ind]
		local spt = bh.ptSet[1]
		local ept = bh.ptSet[#bh.ptSet]
		local dis1 = math.sqrt( math.pow(bh.ptSet[pos1].x - spt.x,2) + math.pow(bh.ptSet[pos1].y - spt.y,2))
		local dis2 = math.sqrt( math.pow(bh.ptSet[pos2].x - ept.x,2) + math.pow(bh.ptSet[pos2].y - ept.y,2))
		--1.�����һ���յ��Ƕ�����
		if( dis1 < 30 ) then
			n_prePos = turning_ind[1]
			n_postPos = #bh.ptSet
			--�Ѷ��ʶδӱʻ���ɾ��
			for i = 1, n_prePos-1 do
				table.remove(bh.ptSet,1)
			end
			--�ӹյ�������ɾ���ùյ�
			table.remove(turning_ind,1)
			--�ƶ��յ�����������������λ��
			if ( #turning_ind > 0 ) then
				for i = 1,#turning_ind do
					 turning_ind[i] = turning_ind[i] - n_prePos + 1
				end
			end
		end
		--2.������һ���յ��Ƕ�����
		if (dis2 < 30) then
			n_prePos = 1
			n_postPos = turning_ind[#turning_ind]
			--�ӹյ�����ɾ���ùյ�
			table.remove(turning_ind,#turning_ind)
			--ɾ�����ʶ�
			for i = #bh.ptSet,n_postPos+1,-1 do
				table.remove(bh.ptSet,i)
			end
		end

	--����յ�֮��ľ���
	if (#turning_ind > 1) then
		for i = 1, #turning_ind - 1  do
			print (turning_ind[i])
			print (turning_ind[i + 1])
			local firstIndex = turning_ind[i]
			local nextIndex = turning_ind[i + 1]
			local pt1 = bh.ptSet[firstIndex]
			local pt2 = bh.ptSet[nextIndex]
			local distance = GetDistance(pt1,pt2)
			print (distance)
		end
	end
		bh.InflectionPoint = turning_ind
		print ("�յ����Ϊ...")
		print (#turning_ind)
		print ("test over")
		return #turning_ind
	end
end




--[[
--��ñʻ��յ�ĸ���
function GetTurningPtNum(bh,BDNum)
	local n_step = 5			--lua������1��ʼ
	if( #bh.ptSet <2*n_step+1) then
		return nil
	end
	local n_curIdx = n_step+1
	local n_preIdx = 1
	local n_postIdx = 2*n_step+1
	local angleArr = {}
	--������Ӧ�ĽǶ�
	for i = n_curIdx,(#bh.ptSet)-n_step do
		local ele = {}
		local angle = Cal_Angle(bh.ptSet[n_preIdx],bh.ptSet[i],bh.ptSet[n_postIdx])
		ele.pos = i
		ele.angle = angle
		table.insert(angleArr,ele)
		n_preIdx = n_preIdx + 1
		n_postIdx = n_postIdx + 1
	end
	--�ѽǶȰ��մ�С��������
	table.sort(angleArr,sortingFun)
	local nCandidateNum = #angleArr

	local CInflectionPts = {}		--�洢��ѡ�յ������
	--ѡ�������BDNum+1���յ㣬�洢��CInflectionPts��
	local f_angleThres = 12/18*3.14;
	for p = 1,nCandidateNum do
		local cFlag = false
		for q = 1,#CInflectionPts do
			if( math.abs(angleArr[p].pos - CInflectionPts[q]) < n_step) then
				cFlag = true
			end
		end

		if (cFlag == false) then
			if(angleArr[p].angle < f_angleThres) then
				CInflectionPts[#CInflectionPts+1] = angleArr[p].pos
			end
		end
	end

	--��CInflectionPts�м���ѡ�����չյ㣬
	--������Ҫ��Ϊ�����αʻ���˵Ķ�������С�յ�������
	local n_prePos
	local n_postPos
	table.sort(CInflectionPts)

--���ѡ���Ĺյ���ĿΪ0��ֱ�ӷ��أ���ʱCInflectionPts�ǿյ�
	if(#CInflectionPts <= 0) then
		return 0
	end
	--����յ���Ŀ�ȱ�׼�٣����յ����鸳ֵ������
	if (#CInflectionPts < BDNum - 1) then
		bh.InflectionPoint = CInflectionPts
		return #CInflectionPts
	end

   --����յ���Ŀ���ڻ��ߵ��ڱ�׼ֵ
	if (#CInflectionPts >= BDNum-1) then
		--������һ���յ㣬α�յ�һ�����ڵ�һ���������һ�����ֱ�����������λ��ľ���
		local pos1 = CInflectionPts[1]
		local pos2 = CInflectionPts[#CInflectionPts]
		local spt = bh.ptSet[1]
		local ept = bh.ptSet[#bh.ptSet]
		local dis1 = math.sqrt( math.pow(bh.ptSet[pos1].x - spt.x,2) + math.pow(bh.ptSet[pos1].y - spt.y,2))
		local dis2 = math.sqrt( math.pow(bh.ptSet[pos2].x - ept.x,2) + math.pow(bh.ptSet[pos2].y - ept.y,2))
		--1.�����һ���յ��Ƕ�����
		if( dis1 < 5 ) then
			n_prePos = CInflectionPts[1]
			n_postPos = #bh.ptSet
			--�Ѷ��ʶδӱʻ���ɾ��
			for i = 1, n_prePos-1 do
				table.remove(bh.ptSet,1)
			end

			--�ӹյ�������ɾ���ùյ�
			table.remove(CInflectionPts,1)

			--�ƶ��յ�����������������λ��
			if ( #CInflectionPts > 0 ) then
				for i = 1,#CInflectionPts do
					 CInflectionPts[i] = CInflectionPts[i] - n_prePos + 1
				end
			end
		end
		--2.������һ���յ��Ƕ�����
		if (dis2 < 5) then
			n_prePos = 1
			n_postPos = CInflectionPts[#CInflectionPts]
			--�ӹյ�����ɾ���ùյ�
			table.remove(CInflectionPts,#CInflectionPts)
			--ɾ�����ʶ�
			for i = #bh.ptSet,n_postPos+1,-1 do
				table.remove(bh.ptSet,i)
			end
		end
		bh.InflectionPoint = CInflectionPts
		return #CInflectionPts
	end
end
]]--

--��ñʻ��Ĺյ� ������0��ʼ
function GetTurningPt(bh,index)
	local ptIdx = bh.InflectionPoint[index + 1]
	return bh.ptSet[ptIdx]
end



 --�����������
 function GetDistance(pt1,pt2)
	local dis = math.sqrt( math.pow(pt1.x - pt2.x,2) + math.pow(pt1.y - pt2.y,2))
	return dis
 end



 function GetBDNum(bh)
	 local tnum = GetTurningPtNum(bh)
	 local bdnum = tnum + 1
	 return bdnum
 end


 function GetBHLen ( bh )

 end


function trace(var)
	retInfoStr = ""
	local varType = type(var)
	if(varType == "string") then
		retInfoStr = var .. "\r\n"
	end
	if(varType == "table") then
			if(var.GeoType == "KBH") then
			retInfoStr = "KBH:\r\n"
			retInfoStr = retInfoStr .. "start point: "..var.ptSet[1].x..","..var.ptSet[1].y
			retInfoStr = retInfoStr .. "\r\n"
			retInfoStr = retInfoStr .. "end point: "..var.ptSet[#var.ptSet].x..","..var.ptSet[#var.ptSet].y
			retInfoStr = retInfoStr .. "\r\n"
			end
	end
	if (varType == "number") then
		retInfoStr = var .. "\r\n"
	end
	allInfoStr = allInfoStr .. retInfoStr
end



--��þ�����pt1 pt2��ֱ�߷���ax+by+c = 0 ��������linevar��������ϵ��a b c
function GetLine(pt1,pt2)
	local linevar = {}
	linevar[1] = pt2.y - pt1.y
	linevar[2] = pt1.x - pt2.x
	linevar[3] = pt1.y*pt2.x - pt2.y*pt1.x
	return linevar
end

--�жϵ��Ƿ���ֱ���±�
function Point2LineDown(pt,line)
	local a,b,c = line[1],line[2],line[3]
	print ("the line var is...")
	print(a,b,c)
	print ("the curpt is ")
	print (pt.x,pt.y)
	local result = a*pt.x + b*pt.y + c
	if (result < 0) then
		return true
	end
	return false
end

--�жϵ��Ƿ���ֱ�ߵ��ϱ�
function Point2LineUp(pt,line)
	local a,b,c = line[1],line[2],line[3]
	local result = a*pt.x + b*pt.y + c
	if (result > 0) then
		return true
	end
	return false
end



--���������ĵ� bh/bd
function GetLeftMostPoint ( bh )
	if ( bh == nil ) then
		return nil
	end

	local pt = WZEnv.POINT:new()
	local index = 1
	pt.x , pt.y = 0 , 0
	if ( (#bh.ptSet) > 0 ) then
		pt.x = bh.ptSet[1].x
		pt.y = bh.ptSet[1].y
	end
	for i =1,#bh.ptSet do
		if ( pt.x > bh.ptSet[i].x ) then
			pt.x = bh.ptSet[i].x
			pt.y = bh.ptSet[i].y
			index = i
			end
	end
	return pt,index
end

--���������ĵ� bh/bd
function GetRightMostPoint ( bh )
	local pt = WZEnv.POINT:new()
	local index = 1
	pt.x , pt.y = 0 , 0
	if ( (#bh.ptSet) > 0 ) then
		pt.x = bh.ptSet[1].x
		pt.y = bh.ptSet[1].y
	end
	for i =1,#bh.ptSet do
		if ( pt.x < bh.ptSet[i].x ) then
			pt.x = bh.ptSet[i].x
			pt.y = bh.ptSet[i].y
			index = i
			end
	end
	return pt,index
end

--������Ϸ��ĵ�
function GetTopMostPoint ( bh )
	local pt = WZEnv.POINT:new()
	local index = 1
	pt.x , pt.y = 0 , 0
	if ( (#bh.ptSet) > 0 ) then
		pt.x = bh.ptSet[1].x
		pt.y = bh.ptSet[1].y
	end

	for i =1,#bh.ptSet do
		if ( pt.y > bh.ptSet[i].y ) then
			pt.x = bh.ptSet[i].x
			pt.y = bh.ptSet[i].y
			index = i
			end
	end
	return pt,index
end

--������·��ĵ� bd/bd
function GetBottomMostPoint ( bh )
	local pt = WZEnv.POINT:new()
	local index = 1
	pt.x , pt.y = 0 , 0
	if ( (#bh.ptSet) > 0 ) then
		pt.x = bh.ptSet[1].x
		pt.y = bh.ptSet[1].y
	end
	for i =1,#bh.ptSet do
		if ( pt.y < bh.ptSet[i].y ) then
			pt.x = bh.ptSet[i].x
			pt.y = bh.ptSet[i].y
			index =  i
			end
	end
	return pt,index
end

--���bh����pt����ĵ�
function GetVPoint(bh,pt)
	local minPtIndex = 0
	local minDis = GetDistance(pt,bh.ptSet[1])
	for i = 2,#bh.ptSet do
		local tmpDis = GetDistance(pt,bh.ptSet[i])
		if (tmpDis < minDis) then
			minDis = tmpDis
			minPtIndex = i
		end
	end
	return bh.ptSet[minPtIndex]
end


--��������ʻ��Ľ���  ����н��� ���ظý���
--							  ���û�н���  ����nil
function GetJoint(bh1, bh2)
	local disThreshold = 3
	local minDis = 256
	local index1 = 1
	local index2 = 1
	for i = 1,#bh1.ptSet do
		for j = 1,#bh2.ptSet do
			local pt1 = bh1.ptSet[i]
			local pt2 = bh2.ptSet[j]
			local tmpDis = GetDistance(pt1,pt2)
			if (tmpDis < minDis) then
				index1 = i
				index2 = j
				minDis = tmpDis
			end
		end
	end
	if (minDis > disThreshold) then
		return nil
	end
	local pts = bh1.ptSet[index1]
	local pte = bh2.ptSet[index2]
	local jpt = {}
	jpt.x = (pts.x + pte.x) / 2
	jpt.y = (pte.x + pte.y) / 2
	return  jpt
end



--pt ��ax + by + c = 0�ľ���
function Cal_Point2LineDis( pt, a, b, c)
	local x = pt.x
	local y = pt.y
	local m = math.abs(a*x+b*y+c)
	local n = 	math.sqrt(a*a+b*b)
	local dis = m/n
	return dis
end

--�ж�pt��ֱ��ax+by+c=0�ķ�λ
function Cal_Direction(pt, a, b,c)
	local x = pt.x
	local y = pt.y
	local dir = a*x+b*y+c
	return dir
end


--��ñʻ���ֱ�� line ax + by + c = 0������Զ�ĵ�
function GetFarthestPt2Line(bh,line)
	local a,b,c = line[1],line[2],line[3]
	local maxDis = 0
	local index = 1
	for i = 1,#bh.ptSet do
		local pt = bh.ptSet[i]
		local dis = Cal_Point2LineDis(pt,a,b,c)
		if (dis > maxDis) then
			maxDis = dis
			index = i
		end
	end
	return bh.ptSet[index],index
end


--------
function GetFarDis2Line(bh,line)
	local a,b,c = line[1],line[2],line[3]
	local maxDis = 0
	local index = 1
	for i = 1,#bh.ptSet do
		local pt = bh.ptSet[i]
		local dis = Cal_Point2LineDis(pt,a,b,c)
		if (dis > maxDis) then
			maxDis = dis
			index = i
		end
	end
	return maxDis
end


--��ñʻ���ֱ��line  ax + by + c = 0��
function GetBHTrend(bh,line)
	local a,b,c = line[1],line[2],line[3]
	local trendArray = {}
	trendArray[#trendArray + 1 ] = 0   --��һ��tag��ʼ��Ϊ0
	local preDis = 0
	--1 ��ʾ�����
	for i = 2,#bh.ptSet do
		local curPt = bh.ptSet[i]
		local curDis = Cal_Point2LineDis(curPt,a,b,c)
		if(curDis > preDis) then
			if (trendArray[#trendArray] == 0 )then
				trendArray[#trendArray + 1] = 1
			end
		end
		if (curDis < preDis) then
			if(trendArray[#trendArray] == 1) then
				trendArray[#trendArray + 1] = 0
			end
		end
		preDis = curDis
	end
	return trendArray
end


--����bh��ptSet�У�����ΪpreIdx��postIdx֮��ĵ㼯��ɵıʶ�
function GetTempBD(bh,preIdx,postIdx)
	local bd = WZEnv.BD:new()
	for i = preIdx, postIdx do
		bd.ptSet[#bd.ptSet + 1] = bh.ptSet[i]
	end
	return bd
end





--����Ĳ���Ϊ��ǰ�ʻ�������.�ʻ��������Ǵ�0��ʼ.
function IsPosRight(idx)
	local wbh = WriteHZ.strokes[idx + 1]
	local sbh = StdHZ.strokes[idx + 1]

	local wspt = wbh.ptSet[1]
	local wept = wbh.ptSet[#wbh.ptSet]

	local sspt = sbh.ptSet[1]
	local sept = sbh.ptSet[#sbh.ptSet]

	local xMin = sspt.x - 50
	local xMax = sspt.x + 50

	local yMin = sspt.y - 50
	local yMax = sspt.y + 50

	if(wspt.x < xMin or wspt.x > xMax or wspt.y < yMin or wspt.y > yMax) then
		return false
	else
		return true
	end
end



--�ж����ʻ��Ƿ��ཻ
function BH2BHXiangJiao(bh1,bh2)
	local threshold = 50
	local jpt = GetJoint(bh1,bh2)
	if (jpt == nil )then
		return false
	end
	--print (jpt.x,jpt.y)
	local spt1 = GetStartPoint(bh1)
	local ept1 = GetEndPoint(bh1)
	local spt2 = GetStartPoint(bh2)
	local ept2 = GetEndPoint(bh2)
	local dis10 = GetDistance(spt1,jpt)
	local dis11 = GetDistance(ept1,jpt)
	local dis20 = GetDistance(spt2,jpt)
	local dis21 = GetDistance(ept2,jpt)
	if (dis10 < threshold) then
		return false
	end
	if (dis11 < threshold) then
		return false
	end
	if (dis20 < threshold) then
		return false
	end
	if (dis21 < threshold) then
		return false
	end
	return true
end


--�ж����ʻ����
function BH2BHXiangJie(bh1,bh2)
	local threshold = 25
	local jpt = GetJoint(bh1,bh2)
	local spt1 = GetStartPoint(bh1)
	local ept1 = GetEndPoint(bh1)
	local spt2 = GetStartPoint(bh2)
	local ept2 = GetStartPoint(bh2)
	if (jpt ~= nil) then
		trace("jpt")
		local dis10 = GetDistance(spt1,jpt)
		local dis11 = GetDistance(ept1,jpt)
		local dis20 = GetDistance(spt2,jpt)
		local dis21 = GetDistance(ept2,jpt)
		trace(dis10)
		trace(dis11)
		trace(dis20)
		trace(dis21)
		if (dis10 <threshold) then
			return true
		end
		if (dis11 < threshold) then
			return true
		end
		if (dis20 < threshold) then
			return true
		end
		if (dis21 < threshold) then
			return true
		end

	end
	if (jpt == nil) then
		trace("now enter...")
		local vpt02 = GetVPoint(bh2,spt1)
		local dis02 = GetDistance(vpt02,spt1)
		local vpt12 = GetVPoint(bh2,ept1)
		local dis12 = GetVPoint(vpt12,ept1)
		local vpt01 = GetVPoint(bh1,spt2)
		local dis01 = GetDistance(vpt01,spt2)
		trace(dis01)
		local vpt11 = GetVPoint(bh1,ept2)
		local dis11 = GetDistance(vpt11,ept2)
		if (dis02 < threshold) then
			return true
		end
		if (dis12 < threshold) then
			return true
		end
		if (dis01 < threshold) then
			return true
		end
		if (dis11 < threshold) then
			return true
		end

	end
	return false
end



