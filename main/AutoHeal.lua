--手入脚本v1.2（合并逻辑和取色部分）
--?论坛@sakura_candy，群内@肝力不足
--Changelog:
-- V1.2:
-- 取色改为用右上角取色，不收疲劳影响也应该不会受樱吹雪影响（吹到右上角有时间差，不影响取色）




-------取色part
function IsColorAll(array)
	n = 0
	ok = 0
	while(array[n] ~= nil)
	do
		if Base.IsColor(array[n][0],array[n][1],array[n][2])==true then
			ok = ok + 1
		end
		n= n+1
	end
	
	if ok==n then
		return true
	else
		return false
	end
end

function Hospital_IsColorAll()
	count = {}
	table.insert(count,0,{[0]=165,106,14220285}) 
	table.insert(count,0,{[0]=732,256,10740205}) 
	return IsColorAll(count)
end

function Bed_IsEmpty(n)
	if n == 1 then
		count = {}
		table.insert(count,0,{[0]=440,138,9015441}) 
		table.insert(count,0,{[0]=361,104,4016202}) 
		table.insert(count,0,{[0]=541,174,1120797}) 
		return IsColorAll(count)
	elseif n==2 then
		count = {}
		table.insert(count,0,{[0]=362,221,4147788}) 
		table.insert(count,0,{[0]=451,256,16777215}) 
		table.insert(count,0,{[0]=527,283,1450532}) 
		return IsColorAll(count)
	elseif n==3 then
		count = {}
		table.insert(count,0,{[0]=358,350,3753287}) 
		table.insert(count,0,{[0]=514,396,285}) 
		return IsColorAll(count)
	elseif n==4 then
		count = {}
		table.insert(count,0,{[0]=452,462,206664}) 
		table.insert(count,0,{[0]=374,503,2174512}) 
		return IsColorAll(count)
	else	
		Win.Print("手入：非法手入室番号")
	end
end

function InBed_isColorAll()
	count = {}
	table.insert(count,0,{[0]=552,279,7830397})
    table.insert(count,0,{[0]=745, 443, 13233909})
	return IsColorAll(count)
end

function SelectedSword_IsColorAll()
	count = {}
	table.insert(count,0,{[0]=516, 281, 2175839})
	table.insert(count,0,{[0]=707, 282, 2175581})
	return IsColorAll(count)
end

function CurrentSwordHealable()
	count = {}
	table.insert(count,0,{[0]=712,477,8542689}) 
	table.insert(count,0,{[0]=565,502,4260561})
	return IsColorAll(count)
end


function Wound_isLight()
	count = {}
	table.insert(count,0,{[0]=731,104,50926}) 
	return IsColorAll(count)
end

function Wound_isHospitalized()
	count = {}
	table.insert(count,0,{[0]=731,104,15232533}) 
	return IsColorAll(count)
end

function Wound_isDying()
	count = {} 
	table.insert(count,0,{[0]=731,104,131823})
	return IsColorAll(count)
end

function Wound_isMedium()
	count = {}
	table.insert(count,0,{[0]=731,104,32511}) 
	return IsColorAll(count)
end




-------函数part
function GetCurrentSwordStatus()
--1轻伤，2中伤，3重伤，0手入，-1嘛事儿没有
	color = Base.GetColor(729,106)
	if color == 50926 then
		Win.Print("手入：轻伤")
		return 2
		
	elseif color == 32511 then
		Win.Print("手入：中伤")
		return 3
		
	elseif color == 131823 then
		Win.Print("手入：重伤")
		return 4
		
	elseif color == 15232533 then
		Win.Print("手入：已在手入")
		return 0
		
	elseif CurrentSwordHealable() then
		Win.Print("手入：擦伤")
		return 1
		
	else
		Win.Print("手入：无伤")
		return -1
	end
end

function EnterHospital()
	repeat
		Base.ClickRectEx(907,270,80,30)
		Base.Sleep(1000)
    until Hospital_IsColorAll()
	Win.Print("手入：进入手入画面")
end

function EnterBed(n)
    Win.Print("手入：检查手入室番号"..n.."是否有刀")
	if Bed_IsEmpty(n) then
        Win.Print("手入："..n.."号手入室空闲")
	
		repeat
			y = 136+(n-1)*121
			Base.ClickRectEx(451,y,600,80)
			Base.Sleep(1000)
		until InBed_isColorAll()
		Win.Print("手入：进入手入室")
		return true
	else
		return false
	end
end

function CheckSwordN(n)

	repeat
		y = 118+(n-1)*77
		Base.ClickRectEx(454,y,20,20)
		Base.Sleep(1000)
	until SelectedSword_IsColorAll()
	return GetCurrentSwordStatus()
end

function SetInstaHeal()
	Win.Print("手入：使用加速")
	Base.ClickRectEx(670,392,100,8)
	Base.Sleep(700)
	Base.ClickRectEx(670,413,100,8)
	Base.Sleep(1000)
end

function StartHeal()
	Win.Print("手入：开始手入")
	repeat
		Base.ClickRectEx(635,490,150,30)
		Base.Sleep(1000)
    until Hospital_IsColorAll()
	--Win.Print("返回手入画面")
end

function ReturnHeal()
	Win.Print("手入：没有需要手入的刀")
	repeat
		Base.ClickRectEx(730,66,35,10)
		Base.Sleep(1000)
    until Hospital_IsColorAll()
	--Win.Print("返回手入画面")
end

function Home_IsColorAll()
	array = {};count = {};
	array = {[0]=53,72,11397105}; count[0] = array;
	return IsColorAll(count)
end

function EnterHome()
	repeat
		Base.Sleep(1000,true)  --等待1秒
		Base.ClickRectEx(900,65,50,10)  --初始化回本丸
		Base.Sleep(1000,true)  --等待1秒
	until Home_IsColorAll()
	
end

function AutoHealMain(in_bed_count, in_heal_level, in_instaheal)
	EnterHome()
	bed_count = in_bed_count

	heal_level = in_heal_level

	instant_heal = in_instaheal

	Base.Sleep(1000,true)  --等待1秒
	Win.Print("?sakura_candy 手入脚本v1.0开始，尝试进入手入画面")
	EnterHospital()	--进入手入画面
	Base.Sleep(1000,true)  --等待1秒
	
	heal_count = 0	--return total number of swords healed
	idx = 0
	repeat -- Bed loop
		idx = idx+1
		if EnterBed(idx) then
			for i=1, 4 do -- check first page swords
				status = CheckSwordN(i)
				if status >= heal_level then
					if instant_heal then
						idx = idx-1	-- reuse same bed
						SetInstaHeal()						
					end
					StartHeal()
					heal_count = heal_count+1
					Base.Sleep(3000,true)  --等待3秒
					if instant_heal then	--回到本丸一次，刷新手入列表
						EnterHome()
						EnterHospital()
					end
					break
				end
				Base.Sleep(1000,true)
			end
			Base.Sleep(2000,true)
			if not Hospital_IsColorAll() then
				ReturnHeal()
				break
			end
		end
	until idx >= bed_count

	EnterHome()
	Win.Print("手入：任务结束，共手入"..heal_count.."次")
	return heal_count
end

function AutoHeal(instant_heal,heal_level)
    if heal_level>0 then
	    AutoHealMain(bed_count,heal_level,instant_heal)
	end
end

