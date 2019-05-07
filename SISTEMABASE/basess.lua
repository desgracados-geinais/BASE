--Взято с vk.com/mod_map_mta
--Подпишись братка!
--Сотрудничество с группой,пиар серверов и.т.д - vk.com/snackeros

database = dbConnect( "sqlite", "main.db" )

baseID = 0
function loadBases()
local idquery = dbQuery( database, "SELECT Max(id) FROM bases" )
	local result, num_affected_rows, errmsg = dbPoll ( idquery, -1 )
	if num_affected_rows > 0 then
		for result, row in pairs ( result ) do
			if row['Max(id)'] then baseID = tonumber(row['Max(id)']) end
			break
		end
	end
local qh = dbQuery(database, "SELECT * FROM bases")
	if qh then
		local result, num_affected_rows, errmsg = dbPoll ( qh, -1 )
		if num_affected_rows > 0 then
			for result, row in pairs ( result ) do
				createBase(row)
			end
		end
	end
end
addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),loadBases)

function bazedaninfo()
local qhh = dbQuery(database, "SELECT * FROM bases")
	if qhh and database then
	local bazadan = dbPoll(qhh,-1)
		triggerClientEvent(source,"bazeinf",source,bazadan)
	end
end
addEvent("bazedaninfo",true)
addEventHandler("bazedaninfo",getRootElement(),bazedaninfo)


function createBase(row)
	local id = tonumber(row['id'])
	local object = tonumber(row['object'])
	local owner = tostring(row['serialowner'])
	local x = tonumber(row['x'])
	local y = tonumber(row['y'])
	local z = tonumber(row['z'])
	local r = tonumber(row['r'])
	local pass = tostring(row['pass'])
	
	object = tonumber(object)
	if object == 2681 then
		zmin = 750
	elseif object == 2754 then
		zmin = 750
	elseif object == 2779 then
		zmin = 750
	else
		outputChatBox("Ид объекта базы не дейтвителен!",source)
		return false
	end
	
	-- Создание объекта
	local base_o = createObject(object,x,y,zmin)
	setElementRotation(base_o,0,0,r)
	
	local marker = createMarker ( x, y, z-1, "cylinder", 3, 255, 255, 255, 20 ) -- Вход
	local marker2 = createMarker ( x,y,730, "cylinder", 3, 255, 255, 255, 20 ) -- Выход

	addCommandHandler ( pass,function (source)
		if isElement(marker) and isElement(marker) then
			if isElementWithinMarker ( source, marker ) then
				setElementPosition ( getPedOccupiedVehicle ( source ) or source,  x,y,730+3 )
			elseif isElementWithinMarker ( source, marker2 ) then
				setElementPosition ( getPedOccupiedVehicle ( source ) or source,  x, y, z+3 )
			end
		end
	end)
	
	baseCol = createColCuboid(x-100,y-100,730-3,200,200,50)
	setElementData(baseCol,"base",true)
	setElementData(baseCol,"base_o",base_o)
	setElementData(baseCol,"owner",owner)
	setElementData(baseCol,"id",id)
	setElementData(baseCol,"marker",marker)
	setElementData(baseCol,"marker2",marker2)
	setElementData(baseCol,"pass",pass)
end

function bazedel(source,cmd,id)
	if not (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(source)), aclGetGroup("Admin"))) then
		return
	end
	id = tonumber(id)
	if not id then
		outputChatBox("Введите ID удаляемой базы!",source)
		return false
	elseif id > baseID or id < 0 then
		outputChatBox("Такой базы не существует!",source)
		return false
	end	
	local qh = dbQuery(database, "DELETE FROM bases WHERE id='"..id.."'")
	local result = dbPoll( qh, -1 )
	for i, v in ipairs(getElementsByType("colshape")) do
		if getElementData(v,"base") and getElementData(v,"id") == id then
			local base_o = getElementData(v,"base_o")
			local marker = getElementData(v,"marker")
			local marker2 = getElementData(v,"marker2")
			local passer = getElementData(v,"pass")
			destroyElement(base_o)
			destroyElement(marker)
			destroyElement(marker2)
			removeCommandHandler(getElementData(v,"pass"))
			setElementData(v,"pass",nil)
			destroyElement(v)
			outputChatBox("База удалена!",source)
			return
		end
	end
end
addEvent("bazedel",true)
addEventHandler("bazedel",getRootElement(),bazedel)

function createNewBase(source,cmd,owner,obj,pass,day,namebase)
	if not (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(source)), aclGetGroup("Admin"))) then
		return
	end
	local namebase = tostring(namebase)
	local colvo = string.len(namebase)
	if colvo > 40 then
	outputChatBox("Имя базы может состоять максимум из 30 символов!",source, 255, 255, 255) 
	return end
	if not owner or owner == "" then
		outputChatBox("Введите сериал будущего хозяина базы!",source)
		return false
	end
	if not obj then
		outputChatBox("Введите номер объекта базы!",source)
		return false
	end
	if not pass or pass == "" then
		outputChatBox("Введите пароль базы!",source)
		return false
	end	
	local bazas = dbPoll(dbQuery(database, "SELECT * FROM bases"),-1)
	for index, baze in ipairs(bazas) do
		if baze["pass"] == pass then
			outputChatBox("Нельзя использовать этот пароль!",source,255,255,255)
			return
		end
	end
	day = tonumber(day)
	if not day then
		outputChatBox("Введите число окончания срока аренды!",source)
		return false
	end	
	
	obj = tonumber(obj)
	if obj == 1 then
		objj = 2681
		zmin = 750
		namebaze = "Маленькая"
	elseif obj == 2 then
		objj = 2754
		zmin = 750
		namebaze = "Средняя"
	elseif obj == 3 then
		objj = 2754
		zmin = 750
		namebaze = "Большая"
	elseif obj == 4 then
		objj = 2779
		zmin = 750
		namebaze = "Огромная"
	elseif obj == 5 then
		objj = 2779
		zmin = 750
		namebaze = "VIP"
	else
		outputChatBox("Ид объекта базы не дейтвителен!",source)
		return false
	end
	objj = tonumber(objj)
		
		
	-- Создание объекта
	baseID = baseID+1
	local x,y,z = getElementPosition(source)
	local xr,yr,zr = getElementRotation(source)
	px, py, pz = getElementPosition(source)
	prot = getPedRotation(source)
	local offsetRot = math.rad(prot+90)
	local vx = px + 5 * math.cos(offsetRot)
	local vy = py + 5 * math.sin(offsetRot)
	local vz = pz + 2
	local vrot = prot+180
	local base_o = createObject(objj,x,y,zmin)
	setElementRotation(base_o,0,0,vrot)
	
	local marker = createMarker ( x, y, z-1, "cylinder", 3, 255, 255, 255, 20 ) -- Вход
	local marker2 = createMarker ( x,y,730, "cylinder", 3, 255, 255, 255, 20 ) -- Выход

	addCommandHandler ( pass,function (source)
	if isElement(marker) and isElement(marker2) then
		if isElementWithinMarker ( source, marker ) then
			setElementPosition ( getPedOccupiedVehicle ( source ) or source,  x,y,730+3 )
		elseif isElementWithinMarker ( source, marker2 ) then
			setElementPosition ( getPedOccupiedVehicle ( source ) or source,  x, y, z+3 )
		end
	end
	end)
	
	baseCol = createColCuboid(x-100,y-100,730-3,200,200,50)
	setElementData(baseCol,"base",true)
	setElementData(baseCol,"base_o",base_o)
	setElementData(baseCol,"owner",owner)
	setElementData(baseCol,"id",baseID)
	setElementData(baseCol,"marker",marker)
	setElementData(baseCol,"marker2",marker2)
	setElementData(baseCol,"pass",pass)
	friends = {}
	setElementData(baseCol,"friends",friends)
	local serial = getPlayerSerial(source)
	for i=1, 1 do
		if serial == owner then
			table.insert(friends,{serial,1})
		else
			table.insert(friends,{serial,1})
			table.insert(friends,{owner,1})
		end
	end
	-- Запись в базу данных
	local result = dbQuery( database, "INSERT INTO `bases` VALUES ('"..baseID.."', '"..namebase.."', '"..objj.."', '"..x.."', '"..y.."', '"..z.."', '"..vrot.."', '"..pass.."', '"..namebaze.."', '"..math.floor(getRealTime().timestamp+(86400*day)).."', '"..toJSON(friends).."', '"..owner.."');")
	friends = nil
end
addEvent("bazecreate",true)
addEventHandler("bazecreate",getRootElement(),createNewBase)

function redactBase(source,id,owner,pass,day,namebase)
if not (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(source)), aclGetGroup("Admin"))) then return end
local namebase = tostring(namebase)
local colvo = string.len(namebase)
if colvo > 40 then
outputChatBox("Имя базы может состоять максимум из 40 символов!",source, 255, 255, 255) 
return end
if not (id or owner or pass or day) then outputChatBox("Заполните необходимые поля!",source) return end
local id = tonumber(id)
local owner = tostring(owner)
local pass = tostring(pass)
local day = tonumber(day)
local bazas = dbPoll(dbQuery(database, "SELECT * FROM bases"),-1)
for index, baze in ipairs(bazas) do
	if baze["pass"] == pass then
		outputChatBox("Нельзя использовать этот пароль!",source,255,255,255)
		return
	end
end
for i, v in ipairs(getElementsByType("colshape")) do
	if getElementData(v,"base") and getElementData(v,"id") == id then
		local markerred = getElementData(v,"marker")
		local markerred2 = getElementData(v,"marker2")
		local passer = getElementData(v,"pass")
		destroyElement(markerred)
		destroyElement(markerred2)
		--destroyElement(passer)
		removeCommandHandler(getElementData(v,"pass"))
		setElementData(v,"pass",nil)
	end
end
dbQuery( database, "UPDATE `bases` SET serialowner='"..owner.."', pass='"..pass.."', owner='"..namebase.."', day='"..math.floor(getRealTime().timestamp+(86400*(day+1))).."' WHERE id='"..id.."';")
	
	local bazas = dbPoll(dbQuery(database, "SELECT * FROM bases WHERE id='"..id.."'"),-1)
	for index, baze in ipairs(bazas) do
		object = tonumber(baze['object'])
			markerr = createMarker ( baze['x'], baze['y'], baze['z']-1, "cylinder", 3, 255, 255, 255, 20 ) -- Вход
			markerr2 = createMarker ( baze['x'],baze['y'],730, "cylinder", 3, 255, 255, 255, 20 ) -- Выход
			addCommandHandler ( pass,function (source)
			if isElement(markerr) and isElement(markerr2) then
				if isElementWithinMarker ( source, markerr ) then
					setElementPosition ( getPedOccupiedVehicle ( source ) or source,  baze['x'],baze['y'],730+3 )
				elseif isElementWithinMarker ( source, markerr2 ) then
					setElementPosition ( getPedOccupiedVehicle ( source ) or source,  baze['x'], baze['y'], baze['z']+3 )
				end
			end
			end)
	end
	
	for i, v in ipairs(getElementsByType("colshape")) do
		if getElementData(v,"base") and getElementData(v,"id") == id then
			setElementData(v,"base",true)
			setElementData(v,"marker",markerr)
			setElementData(v,"marker2",markerr2)
			setElementData(v,"pass",pass)
			--error("Redact")
		end
	end

end
addEvent("redactBase",true)
addEventHandler("redactBase",getRootElement(),redactBase)

function redactBasepl(source,id,pass,namebase)
local namebase = tostring(namebase)
local colvo = string.len(namebase)
if colvo > 40 then
outputChatBox("Имя базы может состоять максимум из 40 символов!",source, 255, 255, 255) 
return end
if not (id or namebase or pass) then outputChatBox("Заполните необходимые поля!",source) return end
local id = tonumber(id)
local pass = tostring(pass)
local bazas = dbPoll(dbQuery(database, "SELECT * FROM bases"),-1)
for index, baze in ipairs(bazas) do
	if baze["pass"] == pass then
		outputChatBox("Нельзя использовать этот пароль!",source,255,255,255)
		return
	end
end
for i, v in ipairs(getElementsByType("colshape")) do
	if getElementData(v,"base") and getElementData(v,"id") == id then
		local markerred = getElementData(v,"marker")
		local markerred2 = getElementData(v,"marker2")
		destroyElement(markerred)
		destroyElement(markerred2)
		removeCommandHandler(getElementData(v,"pass"))
		setElementData(v,"pass",nil)
	end
end
dbQuery( database, "UPDATE `bases` SET owner='"..namebase.."', pass='"..pass.."' WHERE id='"..id.."';")
	
	local bazas = dbPoll(dbQuery(database, "SELECT * FROM bases WHERE id='"..id.."'"),-1)
	for index, baze in ipairs(bazas) do
		markerr = createMarker ( baze['x'], baze['y'], baze['z']-1, "cylinder", 3, 255, 255, 255, 20 ) -- Вход
		markerr2 = createMarker ( baze['x'],baze['y'],730, "cylinder", 3, 255, 255, 255, 20 ) -- Выход
		addCommandHandler ( pass,function (source)
		if isElement(markerr) and isElement(markerr2) then
			if isElementWithinMarker ( source, markerr ) then
				setElementPosition ( getPedOccupiedVehicle ( source ) or source,  baze['x'],baze['y'],730+3 )
			elseif isElementWithinMarker ( source, markerr2 ) then
				setElementPosition ( getPedOccupiedVehicle ( source ) or source,  baze['x'], baze['y'], baze['z']+3 )
			end
		end
		end)
	end
	
	for i, v in ipairs(getElementsByType("colshape")) do
		if getElementData(v,"base") and getElementData(v,"id") == id then
			setElementData(v,"base",true)
			setElementData(v,"marker",markerr)
			setElementData(v,"marker2",markerr2)
			setElementData(v,"pass",pass)
			outputChatBox(pass,source,255,255,255)
		end
	end

end
addEvent("redactBasepl",true)
addEventHandler("redactBasepl",getRootElement(),redactBasepl)

function checkbaze()
local bazas = dbPoll(dbQuery(database, "SELECT * FROM bases"),-1)
	for index, baze in ipairs(bazas) do
		if baze["serialowner"] ~= "none" then
			if math.floor((baze["day"]-getRealTime().timestamp)/86400) < 0 then
			local pass = createRandomPassword(10)
			friends = {}
				for i=1, 1 do
					table.insert(friends,{"ergrgo",1})
				end
				dbQuery( database, 'UPDATE `bases` SET owner="none", pass="'..pass..'", human="none", serialowner="none" WHERE id="'..baze['id']..'";')
				local id = baze["id"]
				for i, v in ipairs(getElementsByType("colshape")) do
					if getElementData(v,"base") and getElementData(v,"id") == id then
						local marker = getElementData(v,"marker")
						local marker2 = getElementData(v,"marker2")
						local passer = getElementData(v,"pass")
						destroyElement(marker)
						destroyElement(marker2)
						removeCommandHandler(getElementData(v,"pass"))
						setElementData(v,"pass",nil)
						--error("Check")
					end
				end
						markerr = createMarker ( baze['x'], baze['y'], baze['z']-1, "cylinder", 3, 255, 255, 255, 20 ) -- Вход
						markerr2 = createMarker ( baze['x'],baze['y'],730, "cylinder", 3, 255, 255, 255, 20 ) -- Выход
						addCommandHandler ( pass,function (source)
							if isElement(markerr) and isElement(markerr2) then
								if isElementWithinMarker ( source, markerr ) then
									setElementPosition ( getPedOccupiedVehicle ( source ) or source,  baze['x'],baze['y'],730+3 )
								elseif isElementWithinMarker ( source, markerr2 ) then
									setElementPosition ( getPedOccupiedVehicle ( source ) or source,  baze['x'], baze['y'], baze['z']+3 )
								end
							end
						end)
				for i, v in ipairs(getElementsByType("colshape")) do
					if getElementData(v,"base") and getElementData(v,"id") == id then
						setElementData(v,"marker",markerr)
						setElementData(v,"marker2",markerr2)
						setElementData(v,"pass",pass)
						setElementData(v,"friends",friends)
						friends = nil
						--error("SET CHECK")
					end
				end
			end
		end
	end
end
setTimer(checkbaze, 10000, 0)

alarmTimer = {}
function onPlayerBases(theElement)
	if getElementType(theElement) == "player" and getElementData(source,"base") then
		local result = dbQuery(database, "SELECT * FROM `bases` WHERE `id` = '"..getElementData(source,"id").."';")
		local result2, num = dbPoll ( result, 10 )
		if result and result2 and result2[1] then
			if result2[1].human ~= "[ [ ] ]" then
				if fromJSON(result2[1].human) then
					for i,v in ipairs(fromJSON(result2[1].human)) do
						local serial = getPlayerSerial(theElement)
						if v[1] and serial == v[1] then
							setElementData(theElement,"inBase",source)
							if isTimer(alarmTimer[theElement]) then
								killTimer(alarmTimer[theElement])
							end
							break
						else
							if not isTimer(alarmTimer[theElement]) then
								alarmTimer[theElement] = setTimer(function()
									setElementPosition ( getPedOccupiedVehicle ( theElement ) or theElement,  result2[1].x, result2[1].y, result2[1].z+3 )
									outputChatBox("У вас нет доступа к этой базе.",theElement)
								end,300,1,theElement)
							end
							setElementData(theElement,"inBase",false)
						end
					end
				else
					if not isTimer(alarmTimer[theElement]) then
						alarmTimer[theElement] = setTimer(function()
							setElementPosition ( getPedOccupiedVehicle ( theElement ) or theElement,  result2[1].x, result2[1].y, result2[1].z+3 )
						end,50,1,theElement)
						outputChatBox("У вас нет доступа к этой базе.",theElement)
					end
					setElementData(theElement,"inBase",false)
				end
			else
				if not isTimer(alarmTimer[theElement]) then
						alarmTimer[theElement] = setTimer(function()
							setElementPosition ( getPedOccupiedVehicle ( theElement ) or theElement,  result2[1].x, result2[1].y, result2[1].z+3 )
						end,50,1,theElement)
						outputChatBox("У вас нет доступа к этой базе.",theElement)
					end
				setElementData(theElement,"inBase",false)
			end
		end
	end
end
addEventHandler("onColShapeHit",getRootElement(),onPlayerBases)

function offPlayerBases(theElement)
	if getElementType(theElement) == "player" and getElementData(source,"base") then
		if isTimer(alarmTimer[theElement]) then
			killTimer(alarmTimer[theElement])
		end
	end
end
addEventHandler("onColShapeLeave",getRootElement(),offPlayerBases)

addEvent("bazepayer", true)
addEventHandler("bazepayer", getRootElement(), function(serial)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(source)), aclGetGroup("Admin")) then
	local serials = getPlayerSerial(serial)
		triggerClientEvent(source, "playerinbazeinf", source, serials)
	end
end)

addEvent("bazepayerpl", true)
addEventHandler("bazepayerpl", getRootElement(), function(serial)
	local serials = getPlayerSerial(serial)
	triggerClientEvent(source, "playerinbazeinfpl", source, serials)
end)

addEvent("trigaddserial", true)
addEventHandler("trigaddserial", getRootElement(), function(friend, id)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(source)), aclGetGroup("Admin")) then
		dbQuery(database, "UPDATE `bases` SET human='"..friend.."' WHERE id='"..tonumber(id).."';")
	end
end)


function open(source, cmd)
if (isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(source)), aclGetGroup("Admin"))) then
		triggerClientEvent(source,"show",source)
	else
		outputChatBox("У вас нет прав!",source,209,252,115)
	end
end
addCommandHandler("editbase",open)


function openpl(source, cmd)
local bazas = dbPoll(dbQuery(database, "SELECT * FROM bases"),-1)
local serials = getPlayerSerial(source)
	for index, baze in ipairs(bazas) do
		if baze["serialowner"] == serials then
			triggerClientEvent(source,"showpl",source,serials)
			return
		end
	end
end
addCommandHandler("base",openpl)

addEvent("refreshplser", true)
addEventHandler("refreshplser", getRootElement(), function(source)
	local serials = getPlayerSerial(source)
	triggerClientEvent(source,"refreshpl",source,serials)
end)

symbols = {
"A","b","D","G","N","f","j","T","R","e","z","Z","X","x","V","v",'E',"H",'h', 's', 'S', 'a', 'B','n','m','M','l','L','g','F','y','Y','U','u','p','P'
}

function createRandomPassword (sym_num)
	local pass = ""
	for i = 1, sym_num do
		if math.random (1,2) == 1 then
			pass = pass..tostring(math.random(0,9))
		else
			pass = pass..symbols[math.random(1,#symbols)]
		end
	end
	return pass
end