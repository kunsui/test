﻿require("日课")
require("Sakura+")
require("EqptAdd")
require("AutoHeal")

-------------------------------------------------------------------------------------
--[[日课设定]]
-------------------------------------------------------------------------------------
daily_switch = 1
--日课开关(0关,1开)

delete_time = 2 --刀解次数
delete_star = 3 --解几花及其以下的刀，特殊欧刀无特别处理(比如3花小狐丸)还是请注意锁刀！

smith_time = 2 --锻刀次数
smith_recipe = {50,50,50,50} --锻刀配方{木炭，玉钢，冷却，砥石}

fusion_time = 2 --錬結次数
fusion_star = 3 --錬結几花及其以下的刀，同上请注意锁刀！

equip_time = 3 --制作刀装次数
equip_recipe = {50,50,50,50} --刀装配方{木炭，玉钢，冷却，砥石}

--append = 1 --追加锻刀次数,床位多的就不需要了,用--注释掉
-------------------------------------------------------------------------------------
--[[出阵设定]]
-------------------------------------------------------------------------------------
max_count = 10
--最多进入多少次地图

map_id = {100,4}
--出击地图

max_battle_count = 100
--最多进入多少次战斗点

wait_time = 0
--在每次出击完成后等待时间（分钟）

formation = 2
--索敌失败后使用的阵型
--阵型1-6依次为 鱼鳞 横队 雁行 鹤翼 方阵 逆行 如果非1-6数值 则选择2

team_id = 1
--出击的队伍(1-4)

ignore_lv_msg = false
--是否无视等级提示

战斗中中伤停止脚本 = false
--false=不停止 true=停止

战斗中轻伤停止脚本 = false
--false=不停止 true=停止

遇到检非不进入地图 = false
--如果为true 则在出击时地图上有检非标记就会返回出击失败

战斗中遇到检非停止脚本 = false
--道中遇到检非打不打，false=不停止 true=停止

-------------------------------------------------------------------------------------
--[[远征设定]]
-------------------------------------------------------------------------------------
easy_expedition = true
--远征开关

--远征时代
k2_conquest = {2,3} --第2队伍
k3_conquest = {2,4} --第3队伍
k4_conquest = {4,4} --第4队伍

--远征多长时间检测一遍
time1 = 60*10 --时间间隔最小(秒)
time2 = 60*30 --时间间隔最大(秒)

-------------------------------------------------------------------------------------
--[[刷花设定]]
-------------------------------------------------------------------------------------
init = 0
--第一次运行先刷花：0不刷，1都刷，2检测状态刷

auto_sakura = 1
--刷花开关，每出阵多少次刷一次花，0不刷
--在筛选范围和页数范围内的刀会被拖去1_1心理治疗，远征手入中的会被跳过

check_status = true
--true：检测是否樱吹雪，没有花就拖去刷;  false：不检测，都拖去刷

max_11 = 3
--出1_1击次数

筛选范围 = 10
--0全部，1短，2胁，3打，4太，5大太，6枪，7薙，8刀装，9马，10守

页数范围 = 0
--翻到第几页，0翻到最后

部队结成筛选范围={
  --刷完花后重新结成原先的队伍，设置范围寻找要出阵的刀
  --0全部，1短，2胁，3打，4太，5大太，6枪，7薙，8刀装，9马，10守
    [1] = {9}, --部队一
    [2] = {10},--部队二
    [3] = {10},--部队三
    [4] = {10},--部队四
}

-------------------------------------------------------------------------------------
--[[手入设定]]
-------------------------------------------------------------------------------------
insta_heal_nonstop = true
--重伤后不停止脚本，自动加速手入重伤刀

bed_count = 2
--床位，最低1，最高4

loop_heal = {true, 0 }
--每次出阵前手入受伤刀
--是否加速true/false，不用加速可能会床位不足无法手入，或者手入中的刀没法出阵
--伤的多重才送去手入，0不修刀，1擦伤及以上，2轻伤及以上，3中伤及以上，4重伤

repair = {false, 1 }
--出阵次数达到后修刀，是否加速true/false，手入伤势同上

-------------------------------------------------------------------------------------
--[[刀装设定]]
-------------------------------------------------------------------------------------
auto_equipment = true
--出阵前检测补充刀装，没刀装补充会做一次，还是无法补充就停止出击

预设策略 = {
    --策略模板：策略名1 = {{"种类1","质量1"},{"种类2","质量2"},},
    --顺序越前的刀装优先级越高
    --注意括号、逗号不能少，还有繁体字建议复制
	
    --种类：投石兵 槍兵 軽歩兵 重歩兵 盾兵 軽騎兵 重騎兵 精鋭兵 弓兵 銃兵
    --质量：特上 上 並
    轻骑 = {{"軽騎兵","上"},{"軽騎兵","並"},{"軽騎兵","特上"},},
	轻步 = {{"軽歩兵","上"},{"軽歩兵","並"},{"軽歩兵","特上"},},
	重骑 = {{"重騎兵","上"},{"重騎兵","並"},{"重騎兵","特上"},},
	重步 = {{"重歩兵","上"},{"重歩兵","並"},{"重歩兵","特上"},},
	精锐 = {{"精鋭兵","上"},{"精鋭兵","並"},{"精鋭兵","特上"},},
	投石 = {{"投石兵","上"},{"投石兵","並"},{"投石兵","特上"},},
	弓 = {{"弓兵","上"},{"弓兵","並"},{"弓兵","特上"},},
	铳 = {{"銃兵","上"},{"銃兵","並"},{"銃兵","特上"},},
	枪 = {{"槍兵","上"},{"槍兵","並"},{"槍兵","特上"},},
	盾 = {{"盾兵","上"},{"盾兵","並"},{"盾兵","特上"},},
	--上面的是例子
	
	枪重步轻步={
	{"槍兵","上"},{"槍兵","並"},{"槍兵","特上"},
	{"軽歩兵","上"},{"軽歩兵","並"},{"軽歩兵","特上"},
	{"重歩兵","上"},{"重歩兵","並"},{"重歩兵","特上"},
	},
	重步轻步={
	{"軽歩兵","上"},{"軽歩兵","並"},{"軽歩兵","特上"},
	{"重歩兵","上"},{"重歩兵","並"},{"重歩兵","特上"},
	},
	重骑轻骑={
	{"軽騎兵","上"},{"軽騎兵","並"},{"軽騎兵","特上"},
	{"重騎兵","上"},{"重騎兵","並"},{"重騎兵","特上"},
	},
}

补充刀装设定 = {	
    -- 策略就是上面预设好的策略
    [1] = {
        策略 = "轻骑",
        允许补充任意刀装 = false,
    },
    [2] = {
        策略 = "轻步",
        允许补充任意刀装 = false,
    },
    [3] = {
        策略 = "轻步",
        允许补充任意刀装 = false,
    },
    [4] = {
        策略 = "轻步",
        允许补充任意刀装 = false,
    },
    [5] = {
        策略 = "轻步",
        允许补充任意刀装 = false,
    },
    [6] = {
        策略 = "轻骑",
        允许补充任意刀装 = false,
    },
}

制作刀装设定 = {
    --用同一个配方一直搓满为止
    木炭 = 50,
    玉钢 = 50,
    冷却 = 50,
    砥石 = 50,
}

删除刀装 = 0
--0不删除，1删轻步兵，2删轻骑兵，暂时没别的选项，会留下特上，比较浪费资源看个人需要

-------------------------------------------------------------------------------------




 


-------------------------------------------------------------------------------------
Base.SetConfig("Sleep+?",1000)

 --判断界面是否正确
if IsDmmunlocker() then 
    Win.Print("坐标无法对应，脚本无法运行")
	return
else
	mode = 0
	if 战斗中遇到检非停止脚本 then mode = mode + 4 end
	if 战斗中中伤停止脚本 then mode = mode + 1 end	
	if 战斗中轻伤停止脚本 then mode = mode + 2 end
end

if insta_heal_nonstop == true then
	Win.Pop("现在重伤后不停止脚本，自动加速手入重伤刀，请保证加速足够，要不会有碎刀危险")
end

Tou.GoHome()

--日课
if daily_switch > 0 then 
if Win.MessageBox("拆刀喂刀请注意锁刀！\n拆刀喂刀请注意锁刀！\n拆刀喂刀请注意锁刀！",1)>6 then return else
    if delete_time > 0 then Delete() end
    if smith_time > 0 then Smith() end
    if fusion_time > 0 then Fusion() end
    if equip_time > 0 then Eqpt_single() end
end;end

--刷花
if init == 0 then
elseif init == 1 then AutoSakura(false,AutoEquipment)
elseif init == 2 then AutoSakura(true,AutoEquipment)
end

--远征
if easy_expedition then
	Tou.EasyConquestInit(time1,time2)
	Tou.EasyConquestRun(false)
end

Tou.RecvTask()

--出阵
for n = 1, max_count do --循环次数

   	Win.Print("开始第:"..n.."次")
	
	--手入
	AutoHeal(table.unpack(loop_heal))
	
	--刀装
	if AutoEquipment() == false then
	    Win.Print("---------没有可用刀装，中断脚本---------")
	    break
	end
	
	--出击
    if Tou.Sally(map_id[1],map_id[2],遇到检非不进入地图) == false then
   	    Win.Print('无法出阵退出')
   	    break --无法出阵
    end
	
	--战斗
   	ret = Tou.Battle(max_battle_count,formation,mode,team_id,ignore_lv_msg)
	
	Tou.WaitHome()
	
	--判断
   	if ret > 0 then 
        if insta_heal_nonstop then --加速手入，只加速重伤刀
	   		Win.Print('重伤，用加速手入把队员拉起来') --发现重伤了
	        if AutoHealMain(bed_count,4,true) == 0 then
	            Win.Print('无法治愈重伤队员，中断脚本')--比如没有手入位
	            break
			end
        else
	        Win.Print('重伤中断脚本') --发现重伤了
	        break
	    end
    elseif ret == -1 then 
	    Win.Print('检非中断脚本') --发现检非
   		break
   	elseif ret == -2 then 
    	Win.Print('超过等级 中断脚本') --超过等级
   		break
   	end
	
	--等待
    Win.Print('出击后等待' .. wait_time .. '分钟...')
    Base.Sleep(1000 * 60 * wait_time)
    Base.Sleep(2000)
	Tou.RecvTask()
	
	--刷花
	if auto_sakura > 0 then
	if n%auto_sakura == 0 then 
	    AutoSakura(check_status,AutoEquipment)
    end;end
	
end

--达到出阵次数
Tou.RecvTask(Smith,append)
Tou.EasyConquestEnterLoop(AutoHeal(table.unpack(repair)))

