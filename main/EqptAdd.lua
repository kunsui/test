--[[
API扩展：在原有API的基础上增加新的功能，还有一些常用的函数
补充刀装：补充刀装模块本体
作者：黒田くん
----------------
制作刀装模块：sakura_candy（肝力不足）
配方输入（通用锻刀封装库1.33）: uint
--]]




全局设定 = {
    -- 当需要检查当前界面是否在某个状态时，多长时间检查一次。（单位：毫秒）
    状态检查间隔 = 200,
    -- 当需要检查当前界面是否在某个状态时，最多检查多久。0为永不言弃（笑）（单位：毫秒）
    状态检查超时 = 2000,
    -- 为了让脚本的行为更自然，在某些操作后附加一些随机的延迟。（单位：毫秒）
    操作延时上限 = 600,
}
-- API扩展
function table.key_of(array, value)
    for k, v in pairs(array) do
        if v == value then
            return k
        end
    end
    return nil
end

function table.index_of(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

function table.map(array, func)
    local new_array = {}
    for i, v in ipairs(array) do
        new_array[i] = func(v)
    end
    return new_array
end

function Base.IsColorAll(array)
    for i, item in pairs(array) do
        if not Base.IsColor(table.unpack(item)) then
            return false
        end
    end
    return true
end

function Base.IsOneOfColors(coord, colors_array)
    for i, color in pairs(colors_array) do
        local x, y = table.unpack(coord)
        if Base.IsColor(x, y, color) then
            return true
        end
    end
    return false
end

function Base.IsOneOfColorsAll(coords_array, colors_array)
    for i, coord in pairs(coords_array) do
        if not Base.IsOneOfColors(coord, colors_array) then
            return false
        end
    end
    return true
end

function Base.ClickRectEx2(x1, y1, x2, y2)
-- 根据两个点选择长方形区域并且随机点击其中一点

    -- 修正座标
    if x2 < x1 then
        local temp = x2
        x2 = x1
        x1 = temp
    end
    if y2 < y1 then
        local temp = y2
        y2 = y1
        y1 = temp
    end
	
    local width = x2 - x1
    local height =  y2 - y1

    -- 修正宽高为2的倍数
    width = math.floor(width / 2) * 2
    height = math.floor(height / 2) * 2

    return Base.ClickRectEx(x1 + width / 2, y1 + height / 2, width, height)
end

function 等待(...)
    local arg = table.pack(...)
    local timer = 0
    local check_func = nil

    if type(arg[1]) == "function" then
        check_func = arg[1]
        table.remove(arg, 1)
    else
        check_func = arg[1][arg[2]]
        table.remove(arg, 2)
    end

    while not check_func(table.unpack(arg)) do
        if 全局设定.状态检查超时 > 0 and timer >= 全局设定.状态检查超时 then
            return false
        end
        timer = timer + 全局设定.状态检查间隔
        Base.Sleep(全局设定.状态检查间隔)
    end
    return true
end

function 快速测试2(func, range)
    local result = {}
    for i = 1, range, 1 do
        table.insert(result, func(i))
    end
    return table.unpack(result)
end


----------


-- 各式常量
local 常量 = {
	刀装 = {
        种类 = {
            投石兵 = 1,
            槍兵 = 2,
            軽歩兵 = 3,
            重歩兵 = 4,
            盾兵 = 5,
            軽騎兵 = 6,
            重騎兵 = 7,
            精鋭兵 = 8,
            弓兵 = 9,
            銃兵 = 10,
        },
        质量 = {
            特上 = 100,
            上 = 200,
            並 = 300,
        },
    },
    翻页 = {
        全体位移 = {
            结成 = {320, 543},
            手入 = {316, 543},
            装备选择 = {127, 548},
        },
        控制位移 = {
            结成 = {6, 32, 235, 262},
            手入 = {6, 32, 235, 262},
            装备选择 = {6, 22, 194, 211},
        },
    },
}


-- 本丸相关
local 本丸 = {}

function 本丸.在本丸()
    return Base.IsColor(53, 72, 11397105)
end

function 本丸.在信箱()
    return Base.IsColor(730, 157, 6931435)
end

function 本丸.在刀帐()
    return Base.IsColor(853, 556, 353499)
end

function 本丸.回本丸()
    if not 本丸.在本丸() then
        repeat
            if 本丸.在信箱() then
                Base.ClickRect(770, 69, 10)
            elseif 本丸.在刀帐() then
                Base.ClickRect(859, 548, 4)
            else
                Base.ClickRectEx(900, 65, 50, 10)
            end
            Base.Sleep(500, true)
        until 等待(本丸.在本丸)
    end
    Win.Print("通用：返回本丸")
end

function 本丸.等待本丸()
    Win.Print("通用：等待本丸")
    while true do
        if 等待(本丸.在本丸) then
            break
        end
    end
end


-- 结成相关
local 结成 = {}

function 结成.在结成界面()
    return Base.IsColorAll({
        {877, 143, 3750327},
        {943, 159, 526464},
        {703,70,3486870},
    })
end

function 结成.去结成界面()
    repeat
        Base.ClickRectEx2(864, 135, 949, 165)
        Base.Sleep(500, true)
    until 等待(结成.在结成界面)
    Win.Print("通用：进入结成界面")
end

function 结成.当前队伍编号(n)
-- 如果提供n参数，返回boolean；如果不提供n参数，返回数字
    local result = 0
    if Base.IsColorAll({
        {779, 85, 13760508},
        {766, 155, 6996971},
    }) then result = 1 end
    if Base.IsColorAll({
        {779, 218, 13760508},
        {766, 291, 6996971},
    }) then result = 2 end
    if Base.IsColorAll({
        {779, 349, 13760508},
        {765, 424, 6996971},
    }) then result = 3 end
    if Base.IsColorAll({
        {779, 482, 13760508},
        {765, 555, 6996971},
    }) then result = 4 end
    if n then
        return result == n
    else
        return result
    end
end

function 结成.选择队伍(n)
    if 结成.当前队伍编号(n) then
        return
    end
    repeat
        Base.ClickRectEx2(761, -67 + 132 * n, 781, 34 + 132 * n)
        Base.Sleep(500, true)
    until 等待(结成.当前队伍编号, n)
    Win.Print("通用：切换到部队" .. tostring(n))
end


-- 翻页相关
local 翻页 = {}

function 翻页.在尾页(self)
    return Base.IsOneOfColors({
        self.control_offsets[4] + self.overall_offsets[1] + 6,
        7 + self.overall_offsets[2],
    }, {
        3355443,
        2763306,
    })
end

function 翻页.去上一页(self)
    Base.ClickRect(self.control_offsets[2] + self.overall_offsets[1], 7 + self.overall_offsets[2], 10)
    Base.Sleep(500)
end

function 翻页.去下一页(self)
    Base.ClickRect(self.control_offsets[3] + self.overall_offsets[1], 7 + self.overall_offsets[2], 10)
    Base.Sleep(500)
end

function 翻页:new(overall_offsets, control_offsets)
    local instance = {}
    setmetatable(instance, {__index = 翻页})
    instance.overall_offsets = overall_offsets
    instance.control_offsets = control_offsets
    return instance
end

setmetatable(翻页, {__call = 翻页.new})

local 翻页 = 翻页(常量.翻页.全体位移.装备选择, 常量.翻页.控制位移.装备选择)


----------


local 取色 = {}

local 取色信息 = {
    -- 133
    -- 83 161 239 317 395 473
    种类 = {
        投石兵 = {
            {12, 26, 10731719},
            {17, 20, 7036242},
        },
        槍兵 = {
            {11, 25, 3229023},
            {17, 21, 4740972},
        },
        軽歩兵 = {
            {7, 24, 5592918},
            {23, 20, 15920879},
        },
        重歩兵 = {
            {9, 14, 4163764},
            {14, 9, 14671843},
        },
        盾兵 = {
            {20, 20, 2031736},
            {18, 27, 3502495},
        },
        軽騎兵 = {
            {16, 3, 12951163},
            {18, 22, 2436478},
        },
        重騎兵 = {
            {14, 5, 4076960},
            {17, 24, 11305828},
        },
        精鋭兵 = {
            {10, 8, 4889742},
            {15, 15, 9041917},
        },
        弓兵 = {
            {17, 21, 3360865},
            {13, 25, 1716304},
        },
        銃兵 = {
            {11, 22, 1654115},
            {18, 20, 1520724},
        },
    },
    质量 = {
        特上 = {
            {2, 3, 13429229},
            {27, 27, 1085595},
        },
        上 = {
            {2, 3, 15329769},
            {27, 27, 9145227},
        },
        並 = {
            {2, 3, 14869973},
            {27, 27, 7175732},
        },
    },
}

function 取色.检查刀装状态()
    local result = {}
    for i = 1, 6, 1 do
        table.insert(result, {
            Base.IsColor(507, 60 + i * 77, 16777215),
            Base.IsColor(542, 60 + i * 77, 16777215),
            Base.IsColor(577, 60 + i * 77, 16777215),
        })
    end
    return result
end

function 取色.在装备变更界面()
    return Base.IsColorAll({
        {371, 66, 14346992},
        {406, 151, 7502974},
        {761, 390, 7502718},
    })
end

function 取色.装备选择界面已打开()
    return Base.IsColorAll({
        {119, 62, 1600656},
        {119, 556, 1731471},
    })
end

function 取色.取得刀装(n)
    if not n then return 快速测试2(取色.取得装备信息, 6) end
    local translate_coord = function (a)
        return {a[1] + 133, a[2] + 5 + n * 78, a[3]}
    end
    local result = 0
    for key, value in pairs(取色信息.质量) do
        if Base.IsColorAll(table.map(value, translate_coord)) then
            result = result + 常量.刀装.质量[key]
            break
        end
    end
    for key, value in pairs(取色信息.种类) do
        if Base.IsColorAll(table.map(value, translate_coord)) then
            result = result + 常量.刀装.种类[key]
            break
        end
    end
    return result
end

function 取色.已选择刀装(n)
    if not n then return 快速测试2(取色.已选择刀装, 6) end
    return Base.IsColorAll({
        {302, 13 + n * 78, 7039990},
        {333, 26 + n * 78, 131820},
    })
end

function 取色.已装备刀装(n)
    if not n then return 快速测试2(取色.已装备刀装, 3) end
    return Base.IsColorAll({
        {535, 141 + n * 38, 526508},
        {551, 156 + n * 38, 65905},
    })
end

function 取色.取得当前页面刀装()
    local result = {}
    for i = 1, 6, 1 do
        table.insert(result, 取色.取得刀装(i))
    end
    return result
end

----------

function 取色.刀装作成画面()
    return Base.ImageHashContrast(Base.ImageHash(337,57,200,20),"003C763F3B7F6E00") < 10
end

function 取色.EquipMakeTenFinished()
    return Base.IsColorAll({
        {289, 275, 2381689},
        {188, 275, 1387120},
        {387, 279, 1386602},
        {292, 127, 4081447},
        {272, 388, 2452862},
        {396, 426, 1789557},
    })
end

function 取色.EquipMakeOneFinished()
if Base.ImageHashContrast(Base.ImageHash(181,123,200,70),"3F7F0E7F77730000")<10 then
    return true
else
    return Base.ImageHashContrast(Base.ImageHash(262, 135, 50, 50), "3CDDDFD587800060") < 10
end
end

function 取色.等待刀装制作画面()
    while Base.ImageHashContrast(Base.ImageHash(256, 325, 80, 80), "000081FFFFC7E7EF") > 10 do
        Base.Sleep(1000)
    end
end

function 取色.等待刀装制作完毕()
    while not 取色.EquipMakeTenFinished() and not 取色.EquipMakeOneFinished() do
        Base.Sleep(1000)
    end
    Base.ClickRectEx(342, 384, 100, 100)
end


----------


local 制作刀装 = {}


--/**********************/
--/*      常量定义      */
--/* ****************** */
--锻刀正常
local EQUIP_OK = 1
local EQUIP_TEN_OK = 10
--参数类型错误
local EQUIP_ERR_INVALID_ARGS_TYPE = -1
--参数值错误
local EQUIP_ERR_INVALID_ARGS_VALUE = -2
--异常弹窗
local EQUIP_ERR_ABNORMAL_MESSAGE_BOX = 0
--是否已经输入好了配方
local Init = false
--/**********************/
--/*     处理对话框     */
--/* ****************** */
--/*   option:是或否    */
--/* 单按钮对话框可任意 */
--/*   返回值:是否成功  */
--/**********************/
function 制作刀装.ProcessMsgbox(option)
    --操作计数器
    local time = 0

    --并没有对话框，立即返回
    if not 制作刀装.IsMsgbox() then
        return false
    end

    --循环点击直到对话框消失，限时60s（每500ms计数器加一）
    while 制作刀装.IsMsgbox() and time < 120 do
        --是否有"否"按钮
        if Base.ImageHashContrast(Base.ImageHash(536, 324, 80, 30), "FFFFFB7F7B4B0100") < 10 then
                if option then
                    Base.ClickRect(386, 338)
                else
                    Base.ClickRect(571, 338)
                end
        else
            Base.ClickRect(486, 338)
        end
        Base.Sleep(500)
        time = time + 1
    end

    if time < 120 then
        return true
    else
        return false
    end
end

--/**********************/
--/*判断对话框是否正弹出*/
--/* ****************** */
--/*  返回值:对话框是否 */
--/*  弹出              */
--/**********************/
function 制作刀装.IsMsgbox()
    return (Base.ImageHashContrast(Base.ImageHash(252, 153, 100, 50), "007F7F7F7E7F7F7F") < 10)
end

--/**********************/
--/*自动输入一种资源的值*/
--/* ****************** */
--/*operationIndex:类型 */
--/*materialValue:数值  */
--/* ****************** */
--/*不建议直接调用此函数*/
--/**********************/
function 制作刀装.EquipMakeInput(operationIndex, materialValue)
    --按钮间距(Y轴)
    local buttonsSpacing = 96
    --百位十位增加按钮X坐标
    local hundredsAndTensAddButtonXPos = 719
    --百位十位减少按钮X坐标
    local hundredsAndTensSubButtonXPos = 648
    --个位增加按钮X坐标
    local unitsAddButtonXPos = 582
    --百位按钮基础Y坐标
    local hundredsButtonYPosBase = 132
    --十位按钮基础Y坐标
    local tensButtonYPosBase = 108
    --个位增加按钮基础Y坐标
    local unitsAddButtonYPosBase = 111
    --单击区域偏移像素个数
    local rectPixels = 2

    --拆分数字
    local hundredsDigit = math.floor(materialValue / 100 % 10)
    local tensDigit = math.floor(materialValue / 10 % 10)
    local unitsDigit = math.floor(materialValue % 10)

    --输入百位
    for i = 1, hundredsDigit do
        Base.ClickRect(hundredsAndTensAddButtonXPos, hundredsButtonYPosBase + buttonsSpacing * operationIndex, rectPixels)
        Base.Sleep(500)
    end
    --输入十位（初始值050因此分类讨论）
    if tensDigit > 5 then
        for i = 1, (tensDigit - 5) do
            Base.ClickRect(hundredsAndTensAddButtonXPos, tensButtonYPosBase + buttonsSpacing * operationIndex, rectPixels)
            Base.Sleep(500)
        end
    else
        for i = 1, (5 - tensDigit) do
            Base.ClickRect(hundredsAndTensSubButtonXPos, tensButtonYPosBase + buttonsSpacing * operationIndex, rectPixels)
            Base.Sleep(500)
        end
    end
    --输入个位
    for i = 1, unitsDigit do
        Base.ClickRect(unitsAddButtonXPos, unitsAddButtonYPosBase + buttonsSpacing * operationIndex, rectPixels)
        Base.Sleep(500)
    end
end

--/**********************/
--/*      公开函数      */
--/*    按照配方锻刀    */
--/* ****************** */
--/*  charcoal:木炭数   */
--/*    steel:玉钢数    */
--/*  coolant:冷却材数  */
--/*  grindstone:砥石数 */
--/*  makeTen:是否十连 */
--/**********************/
function 制作刀装.EquipMakeWithRecipe(charcoal, steel, coolant, grindstone, makeTen)
    --Assume每次执行都是从一个新的任务开始，配方初始化一次就够了

    if not Init then
        --检查传入的参数类型
        if (type(charcoal) ~= "number")
        or (type(steel) ~= "number")
        or (type(coolant) ~= "number")
        or (type(grindstone) ~= "number")
        or (type(makeTen) ~= "boolean")
        then
            Win.Print(type(charcoal)..type(steel)..type(coolant)..type(grindstone)..type(makeTen))
            return EQUIP_ERR_INVALID_ARGS_TYPE
        end

        --检查传入的参数范围
        if ((charcoal < 50) or (charcoal > 999))
        or ((steel < 50) or (steel > 999))
        or ((coolant < 50) or (coolant > 999))
        or ((grindstone < 50) or (grindstone > 999))
        then
            return EQUIP_ERR_INVALID_ARGS_VALUE
        end

        --按照数值输入
        制作刀装.EquipMakeInput(0, charcoal)
        制作刀装.EquipMakeInput(1, steel)
        制作刀装.EquipMakeInput(2, coolant)
        制作刀装.EquipMakeInput(3, grindstone)
        Init = true
    end

    --点按刀装制作开始
    if makeTen then
        Base.ClickRectEx(440, 507)
    else
        Base.ClickRectEx(639, 506)
    end
    Base.Sleep(1000)

    --弹出对话框，可能是满了什么的
    if 制作刀装.IsMsgbox() then
        制作刀装.ProcessMsgbox(false)
        return EQUIP_ERR_ABNORMAL_MESSAGE_BOX
    end

    取色.等待刀装制作完毕()

    if makeTen then
        return EQUIP_TEN_OK
    end
    return EQUIP_OK
end

function 制作刀装.执行()
    local Num = 0
    Init = false
	Win.Print("制作刀装：开始执行，设定 = " .. require("base.inspect")(制作刀装设定))

    --取色.等待刀装制作画面()
    while not 取色.刀装作成画面() do
        Base.Click(910, 232)
        Base.Sleep(2000)
    end
	
    full=false
    repeat
    local returncode = 1
    Win.Print("制作刀装：进入界面")
    --先试十连,然后一个一个做
    local makeTen = true
    while returncode > 0 do
        returncode = 制作刀装.EquipMakeWithRecipe(制作刀装设定.木炭, 制作刀装设定.玉钢, 制作刀装设定.冷却, 制作刀装设定.砥石, makeTen)
        if returncode < 0 then
            return returncode
        end
        Num = Num + returncode
        if returncode == 0 and makeTen then
            makeTen = false
            returncode = 1
        end
    end
	DeleteEqpt()
    until full==true
    Win.Print("制作刀装：共" .. tostring(Num) .. "个")
    本丸.回本丸()
    return Num
end

function Eqpt_single()
    local Num = 0
    Init = false
	Win.Print("制作刀装：设定=[[ 次数:"..equip_time.." , 材料:"..require("base.inspect")(equip_recipe).." ]]")
    Win.Print("制作刀装：开始执行")

    --取色.等待刀装制作画面()
    while not 取色.刀装作成画面() do
        Base.Click(910, 232)
        Base.Sleep(2000)
    end
	
    Win.Print("制作刀装：进入界面")
    for re=1,equip_time do
        returncode = 制作刀装.EquipMakeWithRecipe(equip_recipe[1],equip_recipe[2],equip_recipe[3],equip_recipe[4],false)
        if returncode < 0 then
            Win.Print("制作刀装：参数错误")
			break
		elseif returncode == 0 then
            Win.Print("制作刀装：刀装已满")
			break
        end
        Num = Num + returncode
    end
    Win.Print("制作刀装：共" .. tostring(Num) .. "个")
    本丸.回本丸()
    return Num
end

function FoundEqpt()
    for m=1,2 do
        for n=1,6 do
	        function IsEqptType()
	            if 删除刀装==1 then --轻步兵
            	    return Base.IsColorAll({
                        {310*m-133,23+77*n,3370393},
                        {310*m-146,35+77*n,14741750},
                    })
		        elseif 删除刀装==2 then --轻骑兵
		            return Base.IsColorAll({
                        {310*m-128,18+77*n,9131851},
                        {310*m-126,55+77*n,4219035},
                    })
                end
		    end
		    if IsEqptType() then
			    if not Base.IsColor(310*m-115,64+77*n,106152) then --留下特上
		            Base.Click(310*m+88,18+77*n)Base.Sleep(500)
			    end
		    end
	    end
    end
end

function DeleteEqpt()
    if 删除刀装~=0 then
        delete=0
        Base.Click(770,241)Base.Sleep(1000)
        Base.ClickRect(562,551,3)Base.Sleep(1000)
	    repeat
	        FoundEqpt()Base.Sleep(1000)
		    if Base.IsColor(434,502,4260561) then
    	        Base.Click(434,499)Base.Sleep(6000)--删除
			    delete=delete+1
	    	else 
			    Base.Click(336,550)Base.Sleep(1000)--翻页
			end
        until Base.IsColor(336,550,3355443)
	    Base.Click(770,113)Base.Sleep(1000)
	    if delete==0 then full=true end
	else full=true end
end


----------


local 补充刀装 = {}

function 补充刀装.去装备变更界面(self,n)
    repeat
        Base.ClickRectEx2(712, 51 + n * 77, 746, 68 + n * 77)
        Base.Sleep(500, true)
    until 等待(取色.在装备变更界面)
    Win.Print("补充刀装：补充" .. tostring(n) .. "号队员的刀装")
end

function 补充刀装.退出装备变更界面()
    repeat
	    Win.Print("退出装备变更页面")
        Base.ClickRectEx2(127, 59, 341, 558)
        Base.Sleep(500, true)
    until 等待(结成.在结成界面)
end

function 补充刀装.打开装备选择界面(self,n)
    repeat
        Base.ClickRectEx2(534, 139 + n * 38, 552, 157 + n * 38)
        Base.Sleep(500, true)
    until 等待(取色.装备选择界面已打开)
    Win.Print("补充刀装：补充" .. tostring(n) .. "号位的刀装")
end

function 补充刀装.选择刀装(self,n)
    repeat
        Base.ClickRectEx2(128, 3 + n * 78, 340, 71 + n * 78)
        Base.Sleep(500, true)
    until 等待(取色.已选择刀装, n)
end

function 补充刀装.装备刀装(self,n, i)
    repeat
        Base.ClickRectEx2(300, 11 + n * 78, 334, 28 + n * 78)
        Base.Sleep(500, true)
    until 等待(取色.已装备刀装, i)
end

local function 刀装ID到全名(id)
    return table.key_of(常量.刀装.种类, id % 100) .. "." .. table.key_of(常量.刀装.质量, math.floor(id / 100) * 100)
end

-- TODO: 需要测试完全没有可装备刀装的edge case，哪位好心人帮帮忙~
function 补充刀装.执行()
    local 总补充刀装数 = 0
    -- 替换预设策略
    for i = 1, 6, 1 do
        if type(补充刀装设定[i].策略) == "string" then
            if not 预设策略[补充刀装设定[i].策略] then
                Win.Print("补充刀装：预设策略\"" .. 补充刀装设定[i].策略 .."\"不存在！请检查你的设定")
                本丸.回本丸()
                return -1
            end
            补充刀装设定[i].策略 = 预设策略[补充刀装设定[i].策略]
        end
    end
    Win.Print("补充刀装：开始执行")

    结成.去结成界面()
    结成.选择队伍(team_id)

    local 刀装状态 = 取色.检查刀装状态()
    local 需要补充的刀装位 = {{}, {}, {}, {}, {}, {}}
    for i = 1, 6, 1 do
        for j = 1, 3, 1 do
            if 刀装状态[i][j] then
                table.insert(需要补充的刀装位[i], j)
            end
        end
    end

    for i = 1, 6, 1 do
        if #需要补充的刀装位[i] > 0 then
            -- 做思考状_(:3」∠)_
            Base.Sleep(1000, true)
            补充刀装:去装备变更界面(i)
            for key, j in ipairs(需要补充的刀装位[i]) do
                补充刀装:打开装备选择界面(j)
                local 当前页码 = 1
                local 策略 = table.map(补充刀装设定[i].策略, function (s)
                    return 常量.刀装.种类[s[1]] + 常量.刀装.质量[s[2]]
                end)
                local 已发现的刀装 = {}
                local 要补充的刀装 = nil
                while not 要补充的刀装 do
                    local 当前页面刀装 = 取色.取得当前页面刀装()
                    for index, id in ipairs(当前页面刀装) do
                        if table.index_of(策略, id) ~= 0 then
                            已发现的刀装[id] = {
                                ID = id,
                                页码 = 当前页码,
                                位置 = index,
                            }
                        end
                    end
                    -- 清理掉没找到以后也不可能找到的刀装
                    while not 已发现的刀装[策略[1]] and 策略[1] <= 当前页面刀装[#当前页面刀装] do
                        table.remove(策略, 1)
                    end
                    -- 看看是否已找到最合适的刀装
                    if 已发现的刀装[策略[1]] then
                        要补充的刀装 = 已发现的刀装[策略[1]]
                        break
                    end
                    -- 检查是否已经在尾页
                    if 翻页:在尾页() then
                        break
                    end
                    -- 去下一页
                    翻页:去下一页()
                    当前页码 = 当前页码 + 1
                end
                -- 已排查完所有刀装，使用有库存并且优先级最高的刀装
                if not 要补充的刀装 then
                    for k = 1, #策略, 1 do
                        if 已发现的刀装[策略[k]] then
                            要补充的刀装 = 已发现的刀装[策略[k]]
                            break
                        end
                    end
                end
                -- 如果最终还是什么都没找到_(:3」∠)_
                if not 要补充的刀装 then
                    if 补充刀装设定[i].允许补充任意刀装 then
						if Base.ImageHashContrast(Base.ImageHash(120,52,225,105),"00FFF3FF7C381C2E")<10 then 
						    Win.Print("补充刀装：找不到可用刀装，任务失败") 
							Equipment = false
						    本丸.回本丸() return -2
						else
                            要补充的刀装 = {
                                ID = 取色.取得刀装(1),
                                页码 = 当前页码,
                                位置 = 1,
                            }
                            Win.Print("补充刀装：未找到符合条件的刀装，尝试装备任意刀装")
                        end
					else
                        Win.Print("补充刀装：找不到可用刀装，任务失败")
						Equipment = false
                        本丸.回本丸()
                        return -2
                    end
                end
				
                -- 去装备要补充的刀装
                while 当前页码 ~= 要补充的刀装.页码 do
                    -- 当前页码只可能比要补充的刀装的页码大
                    翻页:去上一页()
                    当前页码 = 当前页码 - 1
                end
                补充刀装:选择刀装(要补充的刀装.位置)
                补充刀装:装备刀装(要补充的刀装.位置, j)
                总补充刀装数 = 总补充刀装数 + 1
                Win.Print("补充刀装：装备了一个" .. 刀装ID到全名(要补充的刀装.ID))
			end
            补充刀装:退出装备变更界面()
        end
    end
    本丸.回本丸()
    Win.Print("补充刀装：任务结束，共补充" .. tostring(总补充刀装数) .. "个刀装")
    return 总补充刀装数
end

function AutoEquipment()
    Equipment = true
    补充刀装.执行()
    if Equipment==false then
	    Equipment = true
        制作刀装.执行()
	    补充刀装.执行()
    end
end

