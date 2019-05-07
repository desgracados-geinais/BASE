--Tirado de vk.com/mod_map_mta
--Assinar irmão!
--Cooperação com o grupo, servidores de RP, etc. vk.com/snackeros

local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth, windowHeight = 700, 700
local windowX, windowY = (screenWidth / 2) - (windowWidth / 2), (screenHeight / 2) - (windowHeight / 2)
local window = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Painel de Edição de Banco de Dados", false)

guiWindowSetSizable(window, false)
guiWindowSetMovable(window, false)
guiSetVisible(window, false)
gridlist = guiCreateGridList (0.01, 0.26, 1, 0.3, true, window)
guiGridListAddColumn(gridlist, "ID", 0.05)
guiGridListAddColumn(gridlist, "Name", 0.1)
guiGridListAddColumn(gridlist, "Owner", 0.34)
guiGridListAddColumn(gridlist, "Day", 0.12)
guiGridListAddColumn(gridlist, "x", 0.12)
guiGridListAddColumn(gridlist, "y", 0.12)
guiGridListAddColumn(gridlist, "z", 0.12)

guiCreateLabel(0.62, 0.075, 0.4, 0.2, "Nota: \ n Você só pode editar: \ n Proprietário, Passe, Rescisão de aluguel! \ N \ n", true, window )

guiCreateLabel(0.011, 0.04, 0.20, 0.03, "Série do proprietário:", true, window )
guiCreateLabel(0.62, 0.04, 0.20, 0.03, "Nome base:", true, window )
guiCreateLabel(0.011, 0.075, 0.20, 0.03, "Pass:", true, window )
guiCreateLabel(0.011, 0.11, 0.23, 0.03, "Dias até o final do aluguel:", true, window )
guiCreateLabel(0.011, 0.145, 0.20, 0.03, "Tipo de base:", true, window )
owneredit = guiCreateEdit (0.25, 0.04, 0.35, 0.03, "", true, window)
passedit = guiCreateEdit (0.25, 0.075, 0.35, 0.03, "", true, window)
dayedit = guiCreateEdit (0.25, 0.11, 0.35, 0.03, "", true, window)
nameedit = guiCreateEdit (0.75, 0.04, 0.35, 0.03, "", true, window)
customType = guiCreateComboBox (0.25, 0.145, 0.35, 0.2, "Um pequeno", true, window )
guiComboBoxAddItem(customType, "Um pequeno") guiComboBoxAddItem(customType, "Média") guiComboBoxAddItem(customType, "Grande") guiComboBoxAddItem(customType, "Огромная") guiComboBoxAddItem(customType, "VIP")
create = guiCreateButton (0.01, 0.185, 0.587, 0.03, "Criar", true, window, "create" )
redact = guiCreateButton (0.01, 0.22, 0.587, 0.03, "Editar", true, window, "Editar" )

deletebase = guiCreateButton (0.61, 0.15, 0.38, 0.03, "Remova a base", true, window, "deletebase" )
tpin = guiCreateButton (0.61, 0.185, 0.25, 0.03, "Teleport: saída da base", true, window, "tpin" )
tpout = guiCreateButton (0.61, 0.22, 0.25, 0.03, "Teleport: entrada para a base", true, window, "tpout" )
refreshgridd = guiCreateButton (0.87, 0.185, 0.12, 0.066, "Atualizar", true, window, "refreshgridd" )
--Игроки в базе
playergridlist = guiCreateGridList (0.01, 0.57, 0.6, 0.375, true, window)
column1 = guiGridListAddColumn(playergridlist, "Serial", 0.9)
--rowers = guiGridListAddRow(playergridlist)
--Игроки
playergrid = guiCreateGridList (0.62, 0.57, 0.6, 0.3, true, window)
column2 = guiGridListAddColumn(playergrid, "Player", 0.9)
guiCreateLabel(0.62, 0.87, 0.37, 0.02, "Jogador da série de TV:", true, window )
editserialplayer = guiCreateEdit(0.62, 0.9, 0.37, 0.04, "", true, window)
addserial = guiCreateButton(0.62, 0.95, 0.37, 0.035, "Adicionar jogador", true, window, "tpin" )
delserial = guiCreateButton(0.01, 0.95, 0.6, 0.035, "Remover jogador", true, window, "tpout" )

function show() 
	if getElementData(getLocalPlayer(),"logedin") then 
		guiSetVisible(window,not guiGetVisible(window))
		if not guiGetVisible(window) then
			guiSetInputMode("allow_binds")
		else
			guiSetInputMode("no_binds_when_editing")
		end
		showCursor(not isCursorShowing())
		guiGridListClear(playergrid)
		for id, player in ipairs ( getElementsByType ( "player" ) ) do
			local row = guiGridListAddRow(playergrid)
			if player ~= localPlayer then
				guiGridListSetItemText(playergrid, row, 1, getPlayerName(player), false, false)
			else
				guiGridListSetItemText(playergrid, row, 1, getPlayerName(player), false, false)
				guiGridListSetItemColor (playergrid, row, column2, 209,252,115 )
			end
		end
	end 
end
addEvent("show",true)
addEventHandler("show",getRootElement(),show)

addEventHandler ( "onClientGUIClick", getResourceRootElement(getThisResource()),
	function()
		if source == create then
				if guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "Um pequeno" then
					objectedit = 1
				elseif guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "Média" then
					objectedit = 2
				elseif guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "Grande" then
					objectedit = 3
				elseif guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "Enorme" then
					objectedit = 4
				elseif guiComboBoxGetItemText(customType, guiComboBoxGetSelected(customType)) == "VIP" then
					objectedit = 5
				else 
					outputChatBox("Escolha um tipo de base!")
					return
				end
			triggerServerEvent("bazecreate", localPlayer, localPlayer, "none", guiGetText(owneredit), objectedit, guiGetText(passedit), guiGetText(dayedit), guiGetText(nameedit))
				setTimer(refreshgrid, 1000, 1)
		elseif source == redact then
			if (guiGridListGetSelectedItem(gridlist) ~= -1) then
				local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
				triggerServerEvent("redactBase", localPlayer, localPlayer, id, guiGetText(owneredit), guiGetText(passedit), guiGetText(dayedit), guiGetText(nameedit))
			end
			setTimer(refreshgrid, 1000, 1)
		elseif source == gridlist then
			for index, baze in ipairs(bazadann) do
				if (guiGridListGetSelectedItem(gridlist) ~= -1) then
					if tonumber(guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)) == baze["id"] then
						guiSetText(owneredit, baze["serialowner"])
						guiSetText(passedit, baze["pass"])
						guiSetText(dayedit, math.floor((baze["day"]-getRealTime().timestamp)/86400))
						guiSetText(nameedit, baze["owner"])
					end
				end
			end
			guiGridListClear(playergridlist)
			if bazadann then
				for i,v in ipairs(bazadann) do
					if (guiGridListGetSelectedItem(gridlist) ~= -1) then
						if v["id"] == tonumber(guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)) then
							if v["human"] ~= "none" then
								for i,vel in ipairs(fromJSON(v["human"])) do
									if vel[1] then
										local row = guiGridListAddRow(playergridlist)
										if vel[1] ~= getPlayerSerial(localPlayer) then
											guiGridListSetItemText(playergridlist, row, 1, vel[1], false, false)
										else
											guiGridListSetItemText(playergridlist, row, 1, vel[1], false, false)
											guiGridListSetItemColor (playergridlist, row, column2, 209,252,115 )
										end
									end
								end
							end
						end
					end
				end
			end
		elseif source == tpin then
			if (guiGridListGetSelectedItem(gridlist) ~= -1) then
			local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
			local id = tonumber(id)
				for index, baze in ipairs(bazadann) do
					object = tonumber(baze['object'])
					if baze["id"] == id then
						setElementPosition(getPedOccupiedVehicle(localPlayer) or localPlayer, baze["x"], baze["y"], -95+3)
					end
				end
			end
		elseif source == tpout then
			if (guiGridListGetSelectedItem(gridlist) ~= -1) then
			local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
			local id = tonumber(id)
				for index, baze in ipairs(bazadann) do
					if baze["id"] == id then
						setElementPosition(getPedOccupiedVehicle(localPlayer) or localPlayer, baze["x"], baze["y"], baze["z"] + 3)
					end
				end
			end
		elseif source == refreshgridd then refreshgrid()
		elseif source == deletebase then
			if (guiGridListGetSelectedItem(gridlist) ~= -1) then
			local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
			local id = tonumber(id)
				triggerServerEvent("bazedel", localPlayer, localPlayer, "none", id)
				setTimer(refreshgrid, 2000, 1)
			end
		elseif source == playergrid then
			if (guiGridListGetSelectedItem(playergrid) ~= -1) then
				local serial = getPlayerFromPartialName(guiGridListGetItemText(playergrid, guiGridListGetSelectedItem(playergrid), 1))
				if serial then
					triggerServerEvent("bazepayer", localPlayer, serial)
				end
			else
				guiSetText(editserialplayer, "")
			end
		elseif source == addserial then
			if (guiGridListGetSelectedItem(gridlist) ~= -1) then
				local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
				if tonumber(id) ~= "" then
					friend = {}
					rowers = guiGridListAddRow(playergridlist)
					for i=0, rowers-1 do
						idis = tostring(guiGridListGetItemText(playergridlist, i, column1))
						table.insert(friend,{idis,1})
					end
					local idis = tostring(guiGetText(editserialplayer)) 
					if idis ~= "" then
						table.insert(friend,{idis,1})
					end
					triggerServerEvent("trigaddserial", localPlayer, toJSON(friend), id)
					idis = nil
					friend = nil
					refreshgrid()
				end
			end
		elseif source == delserial then
			if (guiGridListGetSelectedItem(gridlist) ~= -1) and (guiGridListGetSelectedItem(playergridlist) ~= -1) then
				local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
				local dels = guiGridListGetItemText(playergridlist, guiGridListGetSelectedItem(playergridlist), 1)
				friend = {}
				rowers = guiGridListAddRow(playergridlist)
					for i=0, rowers-1 do
						idis = tostring(guiGridListGetItemText(playergridlist, i, column1))
						if dels ~= idis then
							table.insert(friend,{idis,1})
						end
					end
				triggerServerEvent("trigaddserial", localPlayer, toJSON(friend), id)
				idis = nil
				friend = nil
				refreshgrid()
			end
		end
	end)
	
function refreshgrids(target, serial)
guiSetText(editserialplayer, target)
end
addEvent("playerinbazeinf", true)
addEventHandler("playerinbazeinf", getRootElement(), refreshgrids)

function getPlayerFromPartialName ( nick )
	for id, player in ipairs(getElementsByType("player")) do
		if ( getPlayerName ( player ) == nick ) then return player end
	end
	return false
end
	
function bazeinf(bazadan)
	bazadann = bazadan
end
addEvent("bazeinf",true)
addEventHandler("bazeinf",getRootElement(),bazeinf)

function refreshbazedaninfo()
	triggerServerEvent("bazedaninfo",getLocalPlayer())
end
setTimer(refreshbazedaninfo, 1000, 0)

function renderinfo()
local x,y,z = getElementPosition(getLocalPlayer())
	if bazadann then
		for i, row in pairs(bazadann) do
		local px,py,pz = tonumber(row['x']),tonumber(row['y']),tonumber(row['z']) -- Login	
		if tostring(row['serialowner']) == "none" then
			namebase = "Base №"..tonumber(row['id']).."\ nNome de base: Para venda \ nTipo de base: "..tostring(row['namebaze']).."("..tonumber(row['object'])..")\nДней до окончания срока аренды базы: Не занята"
		else
			namebase = "Base №"..tonumber(row['id']).."\ nNome de base: "..tostring(row['owner']).."\nТип базы: "..tostring(row['namebaze']).."("..tonumber(row['object'])..")\nДней до окончания срока аренды базы: "..tostring(math.floor((row["day"]-getRealTime().timestamp)/86400))
		end
		local pdistance = math.floor(getDistanceBetweenPoints3D ( x,y,z,px,py,pz ))
			if pdistance <= 10 then
				local sx,sy = getScreenFromWorldPosition (px, py, pz+0.95, 0.06 )
				if sx and sy then
					local w = dxGetTextWidth(namebase,1.02,"default-bold")
					dxDrawText(namebase, sx-(w/2), sy, sx-(w/2), sy,tocolor ( 209,252,115, 255 ), 1, "default-bold" )
				end
			end
		end
	end
end
addEventHandler ( "onClientRender",getRootElement(), renderinfo)

function refreshgrid()
guiGridListClear(gridlist)
guiGridListClear(playergridlist)
	if bazadann then
		for index, baze in ipairs(bazadann) do
			if baze["serialowner"] == "none" then owner = "Está vazio" else owner = baze["serialowner"] end
			local row = guiGridListAddRow(gridlist)
			guiGridListSetItemText(gridlist, row, 1, baze["id"], false, false)
			guiGridListSetItemText(gridlist, row, 2, baze["namebaze"], false, false)
			guiGridListSetItemText(gridlist, row, 3, owner, false, false)
			guiGridListSetItemText(gridlist, row, 4, math.floor((baze["day"]-getRealTime().timestamp)/86400), false, false)
			guiGridListSetItemText(gridlist, row, 5, baze["x"], false, false)
			guiGridListSetItemText(gridlist, row, 6, baze["y"], false, false)
			guiGridListSetItemText(gridlist, row, 7, baze["z"], false, false)
		end
	end
end
setTimer(refreshgrid, 3000, 1)

addEventHandler('onClientResourceStart', resourceRoot,
function()
txd = engineLoadTXD ( "stena.txd" ) -- pequeno
engineImportTXD ( txd, 2681 )
col = engineLoadCOL ( "stena.col" )
engineReplaceCOL ( col, 2681 )
dff = engineLoadDFF ( "stena.dff", 0 )
engineReplaceModel ( dff, 2681 )
engineSetModelLODDistance(2681, 500)

txd = engineLoadTXD ( "stena2.txd" ) -- médio / grande
engineImportTXD ( txd, 2754 )
col = engineLoadCOL ( "stena2.col" )
engineReplaceCOL ( col, 2754 )
dff = engineLoadDFF ( "stena2.dff", 0 )
engineReplaceModel ( dff, 2754 )
engineSetModelLODDistance(2754, 500)

txd = engineLoadTXD ( "stena3.txd" ) -- Vip
engineImportTXD ( txd, 2779 )
col = engineLoadCOL ( "stena3.col" )
engineReplaceCOL ( col, 2779 )
dff = engineLoadDFF ( "stena3.dff", 0 )
engineReplaceModel ( dff, 2779 )
engineSetModelLODDistance(2779, 500)
end)
