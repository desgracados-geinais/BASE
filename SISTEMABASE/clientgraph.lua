--Взято с vk.com/mod_map_mta
--Подпишись братка!
--Сотрудничество с группой,пиар серверов и.т.д - vk.com/snackeros

local screenWidth, screenHeight = guiGetScreenSize()
local windowWidth, windowHeight = 700, 500
local windowX, windowY = (screenWidth / 2) - (windowWidth / 2), (screenHeight / 2) - (windowHeight / 2)
local windowpl = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Панель пользователя баз", false)

guiWindowSetSizable(windowpl, false)
guiSetVisible(windowpl, false)

guiCreateLabel(0.62, 0.04, 0.4, 0.2, "Примечание:\nРедактировать можно только:\nНазвание базы и пароль!\n\n", true, windowpl )

arent = guiCreateLabel(0.62, 0.16, 0.4, 0.2, "Дней до окончания срока аренды:\nnone", true, windowpl )

customTypepl = guiCreateComboBox (0.25, 0.05, 0.35, 0.2, "Выбери id базы", true, windowpl )

guiCreateLabel(0.011, 0.1, 0.20, 0.03, "Название базы:", true, windowpl )
guiCreateLabel(0.011, 0.15, 0.20, 0.03, "Пароль:", true, windowpl )
ownereditpl = guiCreateEdit (0.25, 0.1, 0.35, 0.04, "", true, windowpl)
passeditpl = guiCreateEdit (0.25, 0.15, 0.35, 0.04, "", true, windowpl)
redactpl = guiCreateButton (0.01, 0.2, 0.587, 0.04, "Редактировать", true, windowpl)
refreshgriddpl = guiCreateButton (0.01, 0.05, 0.23, 0.04, "Обновить", true, windowpl)
--Игроки в базе
playergridlistpl = guiCreateGridList (0.01, 0.25, 0.6, 0.67, true, windowpl)
column1pl = guiGridListAddColumn(playergridlistpl, "Serial", 0.9)
--Игроки
playergridpl = guiCreateGridList (0.62, 0.25, 0.6, 0.55, true, windowpl)
column2pl = guiGridListAddColumn(playergridpl, "Player", 0.9)
guiCreateLabel(0.62, 0.81, 0.37, 0.029, "Сериал игрока:", true, windowpl )
editserialplayerpl = guiCreateEdit(0.62, 0.85, 0.37, 0.06, "", true, windowpl)
addserialpl = guiCreateButton(0.62, 0.93, 0.37, 0.05, "Добавить игрока", true, windowpl)
delserialpl = guiCreateButton(0.01, 0.93, 0.6, 0.05, "Удалить игрока", true, windowpl)

function showpl(serial) 
	if getElementData(getLocalPlayer(),"logedin") then 
		guiSetVisible(windowpl,not guiGetVisible(windowpl))
		showCursor(not isCursorShowing())
		guiComboBoxClear(customTypepl)
		if bazadann then
			for index, baze in ipairs(bazadann) do
				if tostring(baze["serialowner"]) == tostring(serial) then
					guiComboBoxAddItem(customTypepl, baze["id"]) 
				end
			end
		end
		guiGridListClear(playergridlistpl)
		guiGridListClear(playergridpl)
		for id, player in ipairs ( getElementsByType ( "player" ) ) do
			local row = guiGridListAddRow(playergridpl)
			if player ~= localPlayer then
				guiGridListSetItemText(playergridpl, row, 1, getPlayerName(player), false, false)
			else
				guiGridListSetItemText(playergridpl, row, 1, getPlayerName(player), false, false)
				guiGridListSetItemColor (playergridpl, row, column2pl, 209,252,115 )
			end
		end
		guiSetText(ownereditpl, "")
		guiSetText(passeditpl, "")
		guiSetText(arent, "Дней до окончания срока аренды:\nnone")
	end 
end
addEvent("showpl",true)
addEventHandler("showpl",getRootElement(),showpl)

function refreshpl(serial) 
	if getElementData(getLocalPlayer(),"logedin") then 
		guiComboBoxClear(customTypepl)
		if bazadann then
			for index, baze in ipairs(bazadann) do
				if tostring(baze["serialowner"]) == tostring(serial) then
					guiComboBoxAddItem(customTypepl, baze["id"]) 
				end
			end
		end
		guiGridListClear(playergridlistpl)
		guiGridListClear(playergridpl)
		for id, player in ipairs ( getElementsByType ( "player" ) ) do
			local row = guiGridListAddRow(playergridpl)
			if player ~= localPlayer then
				guiGridListSetItemText(playergridpl, row, 1, getPlayerName(player), false, false)
			else
				guiGridListSetItemText(playergridpl, row, 1, getPlayerName(player), false, false)
				guiGridListSetItemColor (playergridpl, row, column2pl, 209,252,115 )
			end
		end
		guiSetText(ownereditpl, "")
		guiSetText(passeditpl, "")
		guiSetText(arent, "Дней до окончания срока аренды:\nnone")
	end 
end
addEvent("refreshpl",true)
addEventHandler("refreshpl",getRootElement(),refreshpl)


addEventHandler ( "onClientGUIClick", getResourceRootElement(getThisResource()),
	function()
		if source == redactpl then
			if guiComboBoxGetItemText(customTypepl, guiComboBoxGetSelected(customTypepl)) ~= "Выбери id базы" then
				local id = guiComboBoxGetItemText(customTypepl, guiComboBoxGetSelected(customTypepl))
				if guiGetText(passeditpl) ~= "" and guiGetText(ownereditpl) ~= "" then
					triggerServerEvent("redactBasepl", localPlayer, localPlayer, id, guiGetText(passeditpl), guiGetText(ownereditpl))
				else
					outputChatBox("Заполни все поля!", 255, 255, 255)
				end
			end
		elseif source == customTypepl then
			guiGridListClear(playergridlistpl)
			if bazadann then
				for index, baze in ipairs(bazadann) do
					if tonumber(guiComboBoxGetItemText(customTypepl, guiComboBoxGetSelected(customTypepl))) == tonumber(baze["id"]) then
						if baze["human"] ~= "none" then
							for i,vel in ipairs(fromJSON(baze["human"])) do
								if vel[1] then
									local row = guiGridListAddRow(playergridlistpl)
									if vel[1] ~= getPlayerSerial(localPlayer) then
										guiGridListSetItemText(playergridlistpl, row, 1, vel[1], false, false)
									else
										guiGridListSetItemText(playergridlistpl, row, 1, vel[1], false, false)
										guiGridListSetItemColor (playergridlistpl, row, column1pl, 209,252,115 )
									end
								end
							end
						end
						guiSetText(ownereditpl, baze["owner"])
						guiSetText(passeditpl, baze["pass"])
						guiSetText(arent, "Дней до окончания срока аренды:\n"..math.floor((baze["day"]-getRealTime().timestamp)/86400))
					return
					else
						guiSetText(ownereditpl, "")
						guiSetText(passeditpl, "")
						guiSetText(arent, "Дней до окончания срока аренды:\nnone")
					end
				end
			end
		elseif source == refreshgriddpl then
			triggerServerEvent("refreshplser", localPlayer, localPlayer)
		elseif source == playergridpl then
			if (guiGridListGetSelectedItem(playergridpl) ~= -1) then
				local serial = getPlayerFromPartialName(guiGridListGetItemText(playergridpl, guiGridListGetSelectedItem(playergridpl), 1))
				if serial then
					triggerServerEvent("bazepayerpl", localPlayer, serial)
				end
			else
				guiSetText(editserialplayerpl, "")
			end
		elseif source == addserialpl then
			if guiComboBoxGetItemText(customTypepl, guiComboBoxGetSelected(customTypepl)) ~= "Выбери id базы" then
				local id = guiComboBoxGetItemText(customTypepl, guiComboBoxGetSelected(customTypepl))
				if tonumber(id) ~= "" then
					friend = {}
					rowers = guiGridListAddRow(playergridlistpl)
					for i=0, rowers-1 do
						idis = tostring(guiGridListGetItemText(playergridlistpl, i, column1pl))
						table.insert(friend,{idis,1})
					end
					local idis = tostring(guiGetText(editserialplayerpl)) 
					if idis ~= "" then
						table.insert(friend,{idis,1})
					end
					triggerServerEvent("trigaddserial", localPlayer, toJSON(friend), id)
					idis = nil
					friend = nil
					triggerServerEvent("refreshplser", localPlayer, localPlayer)
				end
			end
		elseif source == delserialpl then
			if (guiComboBoxGetItemText(customTypepl, guiComboBoxGetSelected(customTypepl)) ~= "Выбери id базы") and (guiGridListGetSelectedItem(playergridlistpl) ~= -1) then
				local id = guiComboBoxGetItemText(customTypepl, guiComboBoxGetSelected(customTypepl))
				local dels = guiGridListGetItemText(playergridlistpl, guiGridListGetSelectedItem(playergridlistpl), 1)
				friend = {}
				rowers = guiGridListAddRow(playergridlistpl)
					for i=0, rowers-1 do
						idis = tostring(guiGridListGetItemText(playergridlistpl, i, column1pl))
						if dels ~= idis then
							table.insert(friend,{idis,1})
						end
					end
				triggerServerEvent("trigaddserial", localPlayer, toJSON(friend), id)
				idis = nil
				friend = nil
				triggerServerEvent("refreshplser", localPlayer, localPlayer)
			end
		end
	end)

function playerinbazeinfpl(target, serial)
	guiSetText(editserialplayerpl, target)
end
addEvent("playerinbazeinfpl", true)
addEventHandler("playerinbazeinfpl", getRootElement(), playerinbazeinfpl)