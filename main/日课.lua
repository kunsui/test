--日课test v0.5




--Color
function Wait(func,x,y,w,h)
    repeat
	    if x and y and w and h then
        Base.ClickRectEx(x,y,w,h)
		end
		Base.Sleep(500)
    until func()
end

function Base.IsColorAll(array)
    for i, item in pairs(array) do
        if not Base.IsColor(table.unpack(item)) then
            return false
        end
    end
    return true
end

function IsDmmunlocker()
   return Base.IsColorAll({
        {17, 19, 16777215},
        {52, 15, 16777215},
        {105, 16, 16777215},
        {165, 16, 16777215},
    })
end

function TaskOK()
	return Base.IsColorAll({
        {857,391,69077},
        {870,391,69077},
    })
end

function Task_IsColorAl()
	return Base.IsColorAll({
        {910,388,1725853},
        {938,385,2646696},
    })
end

function Smith_IsColorAl()
	return Base.IsColorAll({
        {321,126,4305903},
        {655,66,4395023},
    })
end

function Fusion1_IsColorAl()
	return Base.IsColorAll({
        {907,308,7813658},
        {875,309,7154956},
    })
end

function Fusion2_IsColorAl()
	return Base.IsColorAll({
        {603,254,2372697},
        {725,252,2503520},
    })
end


--Task
function Tou.RecvTask()
    if TaskOK() then
	    Win.Print("任务：进入任务")
        Wait(Task_IsColorAl,910,388,20,10)
	    Base.Click(770,236)
	    Base.Sleep(2000)
	    while Base.IsColor(708,118,4079540) do
	        Base.Click(708,118)
            Base.WaitColor("[[653,366,1510850]]","任务完了")
		    Base.ClickRect(480,280,100)
	        Base.Sleep(2000)
	    end
	    Win.Print("任务：收取任务完成")
        Tou.GoHome()
	end
end


--Delete
function Delete()
    Tou.GoHome()
	Win.Print("刀解：设定=[[ 次数:"..delete_time.." , 星级:"..delete_star.." ]]")
	delete_count=Tou.DeleteSword(delete_time, delete_star)
    if delete_count<1 then
        Tou.RecvMessage()
		delete_count=Tou.DeleteSword(delete_time, delete_star)
	end
	Win.Print("刀解：总共刀解次数："..delete_count)
end


--Smith
function SmithRoomStatus(n)
    if Base.ImageHashContrast(Base.ImageHash(342,-31+121*n,180,90),"FF808C88BEBCB682") < 10 then return 0
	elseif Base.ImageHashContrast(Base.ImageHash(342,-31+121*n,180,90),"BE808EBF1F9FB680") < 10 then return 1
	else return -1
	end
end

function 揭锅(n)
    Wait(Smith_IsColorAl,910,194,20,10)
   	Win.Print("锻刀："..n.."号位揭锅")
	Base.Click(432,16+121*n)
	Base.Sleep(3000)
    if Base.IsColor(487,340,4260561)==true then--确认框
    	Win.Print("锻刀：揭不开锅")
    	Wait(Smith_IsColorAl,487,340,20,10)
		Tou.GoHome()
		if Tou.DeleteSword(1,delete_star)<1 then
		    Win.Print("锻刀：刀解也不行")
			return false
		else
		    揭锅(n)
		end
    else
	    Wait(Smith_IsColorAl,290,480,290,480)
		return true
	end
end

function 锻刀(n,array)
	Win.Print("锻刀：选择"..n.."号床位")
    Base.Click(432,16+121*n)
	Base.Sleep(2000)
	for i=1,4 do
		while (array[i] >=150) do
			Base.Click(719,132+96*(i-1))
			array[i] = array[i]-100
			Base.Sleep(500)
		end
		while (array[i] >=150) do
			Base.Click(719,108+96*(i-1))
			array[i] = array[i]-100
			Base.Sleep(500)
		end
	end
	Base.Click(647,516)--锻刀开始
	Win.Print("锻刀：开始锻刀")
	Wait(Smith_IsColorAl)
end

function Smith()
	Win.Print("锻刀：设定=[[ 次数:"..smith_time.." , 材料:"..require("base.inspect")(smith_recipe).." ]]")
	Win.Print("锻刀：进入锻刀")
	Wait(Smith_IsColorAl,910,194,20,10)
	room={}
	smith_count=0
    for i=1,4 do
		room[i]=SmithRoomStatus(i)
		if smith_count<smith_time then
		    if room[i]==0 then
		        锻刀(i,smith_recipe)
			    smith_count=smith_count+1
		    end
		end
	end
    for i=1,4 do
		if smith_count<smith_time then
	        if room[i]==1 then
			    if 揭锅(i) then 
				    锻刀(i,smith_recipe)
			        smith_count=smith_count+1
			    else break end
			end
	    end
	end
	if smith_count<smith_time then
	    Win.Print("锻刀：床位不足，总共锻刀次数："..smith_count)
	else
	    Win.Print("锻刀：锻刀完成，总共锻刀次数："..smith_count)
	end
	Tou.GoHome()
end


--Fusion
function 錬結(time)
    Wait(Fusion1_IsColorAl,907,308,20,10)
    i=1 
	while not Base.IsColor(740,49+77*i,9842194) do 
	    i=i+1
        if i==7 then 
		    Base.ClickRect(548,550,1)
            Base.Sleep(1000)
		    i=1 
		end
	end
    Base.Click(740,49+77*i)
    Base.Sleep(2000)
	ok=false
	if not fusion_count then fusion_count=0 end
	for n=1,time do
		Win.Print("錬結：开始錬結")
        Base.Click(490,155)
		Base.Sleep(2000)
		i=1
        while Base.IsColor(492+12*(fusion_star+1),50+77*i,10766323) do 
			i=i+1
            if i==7 then 
		        Base.ClickRect(537,549,1)
                Base.Sleep(1000)
		        i=1
		    end
	    end
		if Base.IsColor(738,46+77*i,9842194) then
			ok=1
            Base.Click(740,38+77*i)
			Win.Print("錬結：选择"..i.."号位")
            Base.Sleep(2000)
            Base.ClickRectEx(699,523,20,10)
            Base.Sleep(10000)
	    	Wait(Fusion2_IsColorAl)
		    fusion_count=fusion_count+1
            Base.Sleep(2000)
	    else
		    Win.Print("錬結：没有可以錬結的刀")
		    if not fail or ok then
			    fail=1
				Win.Print("錬結：收一次刀看看")
			    Tou.GoHome()
			    Tou.RecvMessage()
			    錬結(time-fusion_count)
				break
			else
			    Win.Print("錬結：结束錬結")
			    break
			end
		end
	end
end

function Fusion()
	Win.Print("錬結：设定=[[ 次数:"..fusion_time.." , 星级:"..fusion_star.." ]]")
	Win.Print("錬結：进入錬結")
	fail=false
    錬結(fusion_time)
	if fusion_count<fusion_time then
	    Win.Print("錬結：材料不足，总共錬結次数："..fusion_count)
	else
	    Win.Print("錬結：錬結完成，总共錬結次数："..fusion_count)
	end
	Tou.GoHome()
end

