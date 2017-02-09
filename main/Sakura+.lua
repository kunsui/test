--Sakura+ v2.5




--func
function Base.IsColorAll(array)
    for i, item in pairs(array) do
        if not Base.IsColor(table.unpack(item)) then
            return false
        end
    end
    return true
end

function IsSwordOut(n)
	return Base.IsColorAll({
        {730,126+77*n,12840436},
    })
end

function TeamList_IsColorAll()
    return Base.IsColorAll({
        {877,143,3750327},
        {943,159,526464},
        {703,70,3486870},
    })
end

function Tou.GoTeamList()
    repeat
        Base.ClickRectEx(906,150,20,10)
        Base.Sleep(500,true)
    until TeamList_IsColorAll()
    Win.Print("通用：进入结成界面")
end


--clean
function clean2to6()
    for n=1,5 do
		if Base.ImageHashContrast(Base.ImageHash(600,101+77*n,150,50),"00FFFF0303272FA7") < 10 then
        else
		    Base.Print("外す")
	        repeat Base.Click(729,114+77*n) Base.Sleep(500)
			until IsSwordOut(n)== true
        end
    end
end

function 清空部队()
    Tou.GoTeamList()
	Win.Print("清空部队")
    for m=1,4 do
	    Base.Click(770,0+135*m) Base.Sleep(1000)
		if Base.IsColor(325,90,14894742)==true then 远征中=true Win.Print("远征中")
		else
			if Base.ImageHashContrast(Base.ImageHash(600,101,150,50),"00FFFF0303272FA7") < 10 then  Win.Print("队伍空白")
			else
			    clean2to6()
			    n=0
			    repeat Base.Click(729,114) Base.Sleep(500)
		        until IsSwordOut(n)== true
			end
		end
		Base.Sleep(1000)
	end
end


--sakura
function Hash()
    a=Base.ImageHash(162,8+77*i,200,50)
    Base.Sleep(1000)
    b=Base.ImageHash(162,8+77*i,200,50)
	Base.Sleep(1000)
	c=Base.ImageHash(162,8+77*i,200,50)
	Base.Sleep(1000)
	d=Base.ImageHash(162,8+77*i,200,50)
	if Base.ImageHashContrast(a,b)+Base.ImageHashContrast(a,c)+Base.ImageHashContrast(a,d)+Base.ImageHashContrast(b,c)+Base.ImageHashContrast(b,d)+Base.ImageHashContrast(c,d)==0 then h=true else h=false end
end

function CheckSakuraFailed()
    Hash()
    if h==true then
        Sakura = false
	    Win.Print(i.."号位:没有发现飘花")
    else
        Sakura = true
	    Win.Print(i.."号位:飘花")
    end
end

function 换刀()
    Base.Sleep(1000)
	if Base.IsColor(753,38+77*i,12315892)==true then --有刀
		if Base.IsColor(348,51+77*i,15232533)==true then --手入中
		    Win.Print("手入中，跳过") i=i+1
		elseif Base.IsColor(348,51+77*i,14829206)==true then --远征中
		    Win.Print("远征中，跳过") i=i+1
		else
		    if Base.IsColor(753,10+77*i,3684408)==true then --不能入替
			    Base.Click(732,551)--点下返回
		        Win.Print("已在队伍中") ok=true
	        else
		        Win.Print("换刀") 
		        Base.Click(753,10+77*i)
		        Base.Sleep(2000)
		    	Win.Print("换刀成功") ok=true
			end
		end
	else
	    Win.Print("刀不存在") i=7 --没刀了
	end
end

function IsSakura(check_status)
    Tou.GoTeamList()
	Base.Click(770,135) Base.Sleep(1000)
	Base.Click(728,92)-- 一号位入替
	Base.WaitColor("[[533,70,93557]]","选择界面")
	Base.Click(629,67)  Base.Sleep(1000)--点全部
	Base.ClickRectEx(629,67+18*筛选范围,7,1) Base.Sleep(1000)
	page=1
	ok=false
	if i==nil then i=1 end
	if click==nil then
	else
	    for k=1,click do
	        Base.ClickRect(552,550,3)Base.Sleep(1000)
		    page=page+1
	    end
	end
	while not allOK do
		if i==7 then
		    if page==页数范围 then
			    Win.Print("没有了,全员飘花") i=1 click=nil allOK=true --达到页数范围
		    else
    		    if Base.IsColor(552,550,5046092)==true then --可以翻页
				    Win.Print("翻页") Base.ClickRect(552,550,3)
					page=page+1 click=page-1
					Base.Sleep(1000) i=1
			    else 
				    Win.Print("没有了,全员飘花") i=1 click=nil allOK=true --最后一页了
			    end
			end
		end
	    if check_status then CheckSakuraFailed() --检测
	    	if Sakura then i=i+1 --有花，跳过
		    else 换刀() end --没花，换刀
		else 换刀() end --不检测，直接换
		if ok then i=i+1 break end
	end
	if not allOK then
	    clean2to6()
		asc=asc+1
	end
	Tou.GoHome()
end

function 出战1_1()
    for n = 1, max_11 do --循环次数
    	Win.Print("开始第:"..n.."次")
    	--出击
        if Tou.Sally(1,1,false) == false then 
            Win.Print('无法出阵退出')
            break --无法出阵
        end	
        --战斗
        ret = Tou.Battle(2, 1, 0, 1, true)
    	if ret > 0 then 
        	Win.Print('重伤中断脚本') --发现重伤了
    	    break
    	end
    	Base.Sleep(2000)
    end
end


--rank
team={
    [1]={seat={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},},},
    [2]={seat={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},},},
    [3]={seat={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},},},
    [4]={seat={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},},},
}

function GetHash()
    Tou.GoTeamList()
    for t=1,4 do
	    for s=1,6 do
            table.remove(team[t].seat[s])
		end
	end
	for t=1,4 do
	    Win.Print("gethash"..t)
	    Base.Click(770,0+135*t)
	    Base.Sleep(1000)
		for s=1,6 do
           table.insert(team[t].seat[s],Base.ImageHash(187,8+77*s,100,50))
		end
	end
end

function FoundSword()
    i=1
	page=1
	h=false
	Win.Print("等待寻找刀……")
	repeat
		Base.Sleep(2000)
        if Base.ImageHashContrast(Base.ImageHash(211,8+77*i,100,50),table.unpack(team[t].seat[s]))< 8 then
	        Win.Print("找到刀，位置："..i) h=true --yes
	    else
	        i=i+1 --no
	    end
        if i==7 then
		    if Base.IsColor(552,550,5046092)==true then 
			    Base.ClickRect(552,550,3) page=page+1 
		        Base.Sleep(1000)  i=1 
	        else
			    Win.Print("找不到刀，再找一遍") i=1
			    Base.ClickRect(328,550,3)
			end
		end
	until h==true
   	Base.Sleep(2000)
	Win.Print("入替")
	if Base.IsColor(754,10+77*i,3684408)==true then
	    Base.Click(732,551)--点下返回
		Win.Print("已在队伍中")
	else
	    repeat
            Base.Click(754,10+77*i)
	        Base.Sleep(500)
	    until Base.IsColor(703,70,3486870)==true
		repeat Base.Sleep(500)
	    until Base.ImageHashContrast(Base.ImageHash(710,50+77*c,40,20),"FFFFB7B6B6B68080") < 10 
		Win.Print("换刀成功")
	end
end

function Addition()
    c=1
    s=1
    repeat
		if table.unpack(team[t].seat[s])=="FFFFFFFFFF000000" then
   		else
            Win.Print(s.."号位入替")
		    Base.Print(table.unpack(team[t].seat[s]))
		    Base.Sleep(1000)
			repeat 
			    Base.Click(728,15+77*c)--点入替
				Base.Sleep(500)
			until Base.IsColor(533,70,93557)==true
			Win.Print("进入选择界面")
		    --复位
	    	Base.ClickRect(328,550,3) Base.Sleep(500)--首页
			if c==1 then
	    	    if Base.ImageHashContrast(Base.ImageHash(617,56,40,20),"00FFFFFF3C303400")<3 then  
		        else 
			        Base.Click(629,67) Base.Sleep(500)
 	                Base.Click(629,85) Base.Sleep(500)
	    	    end
				--筛选
				筛选=table.unpack(部队结成筛选范围[t])
		        Base.Click(629,67) Base.Sleep(500)
		        Base.ClickRectEx(629,67+18*筛选,7,1) Base.Sleep(500)
            end
 	        FoundSword()
		end
 	    --计数
		Base.Sleep(1000)
		s=s+1
		c=c+1
	until c==7
end

function 入替()
    清空部队()
    t = 1 
	for u=1,4 do
	    Win.Print("开始部队"..u.."入替")
	    Base.Click(770,0+135*u)
	    Base.Sleep(2000)
		if Base.IsColor(325,90,14894742)==true then 远征中=true
			Win.Print("部队"..u.."远征中")
			Base.Sleep(1000)
		else
    	    Addition()
		    Win.Print("部队"..u.."入替完成")
	        Base.Sleep(1000)
		end
		t = t+1
	end
	Tou.GoHome()
end


--main
function 刷花(check_status,func)
    Win.Print("-----刷花脚本开始-----")
    if func~=nil then func() end
	asc=0
	allOK=false
	GetHash()
    while not allOK do
        IsSakura(check_status)
		if not allOK then
            出战1_1()
		end
		Win.Print("完成第"..asc.."把刀刷花")
	end
	if asc>0 then
        入替()
	end
	Win.Print("共刷花"..asc.."把刀")
end

