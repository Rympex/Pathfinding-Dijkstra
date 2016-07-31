-- ESSENTIALS --
-- IN RECTANGLE --
function inRectangle(UpperX, UpperY, LowerX, LowerY)
	ActX = getPlayerX()
	ActY = getPlayerY()
	if (ActX >= UpperX and ActX <= LowerX) and (ActY >= UpperY and ActY <= LowerY) then
		return true
	else
		return false
	end
end

-- CHECK EXCEPTION MAP1 TO MAP2    - IF FOUND CALL RESOLUTION EXCEPTION
function CheckException(EMap)
	for index, value in pairs(DescMaps) do
		if index == EMap then		
			SolvingException(EMap)
			return true
		end
	end
end

-- CALL FUNCTION ON EXCEPTION TABLE
function SolvingException(EMap)
	for index, value in pairs(DescMaps) do
		if index == EMap then
			-- CHECK MODE
			--Res = tonumber(tablelength(DescMaps[index]))
			for val, func in pairs(DescMaps[index]) do
				if DescMaps[index][val]() == false then
					return
				end 
			end
		end
	end
end



-- FUNCTION FOR ADD DIALOG AND PUSHDIALOG

DialogCheck = ""
DialogChoose = {}

function SolveDialog(message)
	if message == DialogCheck then
		for value, index in pairs(DialogChoose) do
			pushDialogAnswer(index)
			log("Pushing Dialog: " .. index)
		end
	end
end

-- RESOLUTION EXCEPTION FOR MOVE MAP1 TO MAP2 SPEAKING WITH NPC
function Mode_MoveToCell(MapName,Xh,Yh,Xl,Yl,Xc,Yc)
	if inRectangle(Xh,Yh,Xl,Yl) == true and MapName == getMapName()then
	    log1time("Exception Resolution:  [ " .. getMapName() .." To " .. PathSolution[1] .." ]  GoTo  X:".. Xc .." Y:" .. Yc)
		moveToCell(Xc,Yc)
	else
		return false
	end
end

-- RESOLUTION EXCEPTION FOR MOVE MAP1 TO MAP2 SPEAKING WITH NPC
function Mode_SpeakWithNPC(MapName,Check,Dialogs,cellX,cellY,npcX,npcY)
	DialogCheck = Check
	DialogChoose = Dialogs
	log1time("Exception Resolution:  [ " .. getMapName() .." To " .. PathSolution[1] .." ]  SpeakWithNPC  X:".. cellX .." Y:" .. cellY)
	if (getPlayerX() == cellX) and (getPlayerY() == cellY) and isNpcOnCell(npcX, npcY) == true then
			talkToNpcOnCell(npcX, npcY)
		else
		if MapName == getMapName() then
			moveToCell(cellX,cellY)
		end
	end	
end


-- EDIT PATH FOR NO EDIT BASIC MAP TABLE
function EditPathGenerated()
	for val, zone in pairs(PathSolution) do -- for every val in array path 
		for valx, exce in pairs(ExceRouteEdit) do -- for every val in exception, based on path, compare
			if zone == ExceRouteEdit[valx][1][1] then -- if 1 of element is a start of exception- get table length exception
				finded = true
				for stat, element in pairs(ExceRouteEdit[valx][1]) do
					posp = val - 1
					if element == PathSolution[(posp + stat)] then
					else
						finded = false
					end
				end
				if finded == true then
					exclng = tonumber(val - 1 + tablelength(ExceRouteEdit[valx][1]))
					--print("need replace path pos:" .. val .. "  to pos:" .. exclng)
					replacepath(val, exclng, valx)
					return
				else
					
				end
			end
		end
	end

end

-- FUNCTION NO BULTIN FOR ADD VALUE ON A TABLE
function replacepath(startpos, endpos, namexc)
	temppath = {}
	for posS=1,(startpos-1) do	
		table.insert(temppath,PathSolution[posS])
	end
	for posex, val in pairs(ExceRouteEdit[namexc][1]) do
		table.insert(temppath,ExceRouteEdit[namexc][2][posex])
	end
	for posE=1,(tablelength(PathSolution) - endpos) do
		table.insert(temppath,PathSolution[(endpos + posE)])
	end
	--log("Orginal: ".. table.concat(PathSolution,"",""))
	PathSolution = temppath
end


-- TABLE- PATHEDIT FORCE 
ExceRouteEdit = {} 
ExceRouteEdit["1"] = {{"Mt. Moon B1F","Mt. Moon B2F","Mt. Moon Exit"},{"Mt. Moon Exit"}}
ExceRouteEdit["2"] = {{"Mt. Moon B2F","Mt. Moon B1F","Mt. Moon 1F"},{"Mt. Moon B1F","Mt. Moon 1F"}}
--ExceRouteEdit["2"] = {{"Mt. Moon B1F","Mt. Moon 1F"},{"Mt. Moon 1F"}}
ExceRouteEdit["3"] = {{"Rock Tunnel 1","Rock Tunnel 2","Route 9"},{"Rock Tunnel 1","Route 10","Route 9"}}
ExceRouteEdit["4"] = {{"Rock Tunnel 2","Route 9"},{"Rock Tunnel 1","Route 10","Route 9"}}
ExceRouteEdit["5"] = {{"Pokemon Tower B9","Pokemon Tower B10","Pokemon Tower B11"},{"Pokemon Tower B9","Pokemon Tower B11"}}
ExceRouteEdit["6"] = {{"Safari Stop","Safari Effort Wald 1"},{"Safari Stop","Safari Effort Wald 2","Safari Effort Wald 1"}}
ExceRouteEdit["7"] = {{"Safari Effort Wald 1","Safari Effort Wald 2","Safari Stop"},{"Safari Effort Wald 1","Safari Stop"}}
ExceRouteEdit["8"] = {{"Rock Tunnel 1","Route 10","Route 10","Lavender Town"},{"Rock Tunnel 1","Lavender Town"}}
ExceRouteEdit["10"] = {{"Seafoam 1F","Route 20","Route 19"},{"Seafoam 1F","Route 19"}}
ExceRouteEdit["9"] = {{"Route 9","Route 10","Lavender Town"},{"Route 9","Lavender Town"}}
ExceRouteEdit["11"] = {{"Route 9","Route 10","Pokecenter Route 10"},{"Route 9","Pokecenter Route 10"}}
ExceRouteEdit["11"] = {{"Lavender Town","Route 9","Pokecenter Route 10"},{"Lavender Town","Route 10","Route 9","Pokcenter Route 10"}}
--ExceRouteEdit["12"] = {{"Route 10","Pokecenter Route 10"},{"Route 10","Route 9","Pokecenter Route 10"}}

--7ExceRouteEdit["11"] = {{"Route 19","Route 20","Cinnabar Island"},{"Seafoam 1F","Route 19"}}
--ExceRouteEdit["12"] = {{"Route 19","Seafoam B1F"},{"Route 19","Route 20","ccc","lol"}}
--ExceRouteEdit[" "] = {{""},{""}}





-- MOVE TO CELL --
DescMaps = {}

-- DIGLETTS CAVE (VIRIDIAN OR PEWTER CITY)
DescMaps["Route 2_to_Digletts Cave Entrance 1"] = {function() Mode_MoveToCell("Route 2", 6,0,44,90,33,31) end,function() Mode_MoveToCell("Route 2", 3,95,45,130,40,96) end}
DescMaps["Route 2 Stop3_to_Digletts Cave Entrance 1"] = {function() Mode_MoveToCell("Route 2 Stop3", 0,2,7,12,3,2) end}

-- ROUTE 2 GO TO (VIRIDIAN OR PEWTER)
DescMaps["Route 2_to_Pewter City"] = {function() Mode_MoveToCell("Route 2", 6,0,44,90,25,0) end,function() Mode_MoveToCell("Route 2", 3,95,45,130,40,96) end}
DescMaps["Route 2 Stop3_to_Pewter City"] = {function() Mode_MoveToCell("Route 2 Stop3", 0,2,7,12,3,2) end}
DescMaps["Route 2_to_Viridian City"] = {function() Mode_MoveToCell("Route 2", 6,0,44,90,39,90) end,function() Mode_MoveToCell("Route 2", 3,95,45,130,8,130) end}
DescMaps["Route 2 Stop3_to_Viridian City"] = {function() Mode_MoveToCell("Route 2 Stop3", 0,2,7,12,4,12) end}

-- MT MOON GO TO (ROUTE 3 OR ROUTE 4)
DescMaps["Mt. Moon 1F_to_Mt. Moon Exit"] = {function() Mode_MoveToCell("Mt. Moon 1F", 19,16,74,64,21,20) end}
DescMaps["Mt. Moon B1F_to_Mt. Moon Exit"] = {function() Mode_MoveToCell("Mt. Moon B1F", 70,14,78,35,56,34) end,function() Mode_MoveToCell("Mt. Moon B1F", 52,28,71,35,56,34) end,function() Mode_MoveToCell("Mt. Moon B1F", 30,18,44,22,41,20) end,function() Mode_MoveToCell("Mt. Moon B1F", 57,18,65,21,65,20) end}
DescMaps["Mt. Moon B2F_to_Mt. Moon Exit"] = {function() Mode_MoveToCell("Mt. Moon B2F", 36,34,71,41,17,27) end,function() Mode_MoveToCell("Mt. Moon B2F", 50,42,71,71,17,27) end,function() Mode_MoveToCell("Mt. Moon B2F", 14,60,49,72,17,27) end,function() Mode_MoveToCell("Mt. Moon B2F", 12,17,27,59,17,27) end}
--DescMaps["Mt. Moon 1F_to_Route 3"] = {function() Mode_MoveToCell("Mt. Moon 1F", 19,16,74,64,38,63) end}
DescMaps["Mt. Moon B1F_to_Mt. Moon 1F"] = {function() Mode_MoveToCell("Mt. Moon B1F", 70,14,78,35,75,15) end,function() Mode_MoveToCell("Mt. Moon B1F", 52,28,71,35,75,15) end,function() Mode_MoveToCell("Mt. Moon B1F", 30,18,44,22,32,21) end,function() Mode_MoveToCell("Mt. Moon B1F", 17,15,25,17,18,15) end}
DescMaps["Mt. Moon B2F_to_Mt. Moon 1F"] = {function() Mode_MoveToCell("Mt. Moon B2F", 36,34,71,41,38,40) end,function() Mode_MoveToCell("Mt. Moon B2F", 50,42,71,71,38,40) end,function() Mode_MoveToCell("Mt. Moon B2F", 14,60,49,72,38,40) end,function() Mode_MoveToCell("Mt. Moon B2F", 12,17,27,59,38,40) end}

-- ROUTE 4 TO CERULEAN CITY
DescMaps["Route 4_to_Cerulean City"] = {function() Mode_MoveToCell("Route 4", 8,9,96,29,96,21) end}

-- ROUTE 5 TO CERULEAN City
DescMaps["Route 5_to_Cerulean City"] = {function() Mode_MoveToCell("Route 5", 0,0,41,39,13,0) end}

-- SEAFOAM (CINNABAR OR FUCHSIA)
DescMaps["Route 20_to_Seafoam 1F"] = {function() Mode_MoveToCell("Route 20", 55,20,120,34,60,32) end,function() Mode_MoveToCell("Route 20", 0,13,52,47,73,40) end,function() Mode_MoveToCell("Route 20", 53,38,84,45,73,40) end}
DescMaps["Route 20_to_Route 19"] = {function() Mode_MoveToCell("Route 20", 55,20,120,34,120,29) end,function() Mode_MoveToCell("Route 20", 50,39,77,44,73,40) end,function() Mode_MoveToCell("Route 20", 0,0,49,46,73,40) end}
DescMaps["Route 20_to_Cinnabar Island"] = {function() Mode_MoveToCell("Route 20", 0,13,82,46,0,33) end,function() Mode_MoveToCell("Route 20", 55,18,120,37,60,32) end}
DescMaps["Seafoam B1F_to_Cinnabar Island"] = {function() Mode_MoveToCell("Seafoam B1F", 15,9,86,28,85,22) end}
DescMaps["Seafoam B1F_to_Route 19"] = {function() Mode_MoveToCell("Seafoam B1F", 15,9,86,28,15,12) end}
DescMaps["Seafoam 1F_to_Cinnabar Island"] = {function() Mode_MoveToCell("Seafoam 1F", 64,7,78,16,71,15) end,function() Mode_MoveToCell("Seafoam 1F", 7,7,20,16,20,8) end}
DescMaps["Seafoam 1F_to_Route 19"] = {function() Mode_MoveToCell("Seafoam 1F", 6,6,20,16,13,16) end,function() Mode_MoveToCell("Seafoam 1F", 64,7,77,15,64,8) end}


-- ROUTE 9 ,ROUTE 10 AND ROCKTUNNEL 1,2
DescMaps["Route 10_to_Route 9"] = {function() Mode_MoveToCell("Route 10", 1,43,32,71,5,44) end,function() Mode_MoveToCell("Route 10", 9,0,25,12,23,0) end,function() Mode_MoveToCell("Route 10", 6,13,33,35,28,0) end,function() Mode_MoveToCell("Route 10", 26,0,31,12,28,0) end}
DescMaps["Route 9_to_Lavender Town"] = {function() Mode_MoveToCell("Route 9", 0,0,100,100,86,33) end}
DescMaps["Route 10_to_Lavender Town"] = {function() Mode_MoveToCell("Route 10", 1,43,32,71,16,71) end,function() Mode_MoveToCell("Route 10", 9,0,25,12,11,5) end,function() Mode_MoveToCell("Route 10", 26,0,31,12,28,0) end}
DescMaps["Rock Tunnel 1_to_Route 10"] = {function() Mode_MoveToCell("Rock Tunnel 1", 5,26,26,33,7,30) end,function() Mode_MoveToCell("Rock Tunnel 1", 5,5,32,17,7,7) end,function() Mode_MoveToCell("Rock Tunnel 1", 32,4,48,19,43,11) end}
DescMaps["Rock Tunnel 2_to_Route 10"] = {function() Mode_MoveToCell("Rock Tunnel 2", 5,12,29,29,10,13) end,function() Mode_MoveToCell("Rock Tunnel 2", 5,4,48,11,36,16) end,function() Mode_MoveToCell("Rock Tunnel 2", 34,12,39,18,36,16) end}
DescMaps["Rock Tunnel 1_to_Route 9"] = {function() Mode_MoveToCell("Rock Tunnel 1", 5,26,26,33,7,30) end,function() Mode_MoveToCell("Rock Tunnel 1", 5,5,32,17,7,7) end,function() Mode_MoveToCell("Rock Tunnel 1", 32,4,48,19,43,11) end}
DescMaps["Rock Tunnel 2_to_Route 9"] = {function() Mode_MoveToCell("Rock Tunnel 2", 5,12,29,29,10,13) end,function() Mode_MoveToCell("Rock Tunnel 2", 5,4,48,11,36,16) end,function() Mode_MoveToCell("Rock Tunnel 2", 34,12,39,18,36,16) end}
DescMaps["Rock Tunnel 1_to_Lavender Town"] = {function() Mode_MoveToCell("Rock Tunnel 1", 5,26,26,33,21,32) end,function() Mode_MoveToCell("Rock Tunnel 1", 5,5,32,17,8,15) end,function() Mode_MoveToCell("Rock Tunnel 1", 32,4,48,19,35,16) end}
DescMaps["Rock Tunnel 2_to_Lavender Town"] = {function() Mode_MoveToCell("Rock Tunnel 2", 5,12,29,29,8,26) end,function() Mode_MoveToCell("Rock Tunnel 2", 5,4,48,11,7,5) end,function() Mode_MoveToCell("Rock Tunnel 2", 34,12,39,18,7,5) end}

-- POWERPLANT (ROUTE 9)
DescMaps["Route 9_to_Power Plant"] = {function() Mode_MoveToCell("Route 9", 0,0,97,35,92,33) end}
DescMaps["Route 10_to_Power Plant"] = {function() Mode_MoveToCell("Route 10", 8,0,25,11,22,0) end,function() Mode_MoveToCell("Route 10", 8,21,26,34,15,26) end,function() Mode_MoveToCell("Route 10", 27,0,30,34,15,26) end}
DescMaps["Power Plant_to_Route 9"] = {function() Mode_MoveToCell("Power Plant", 0,0,48,39,5,39) end}
DescMaps["Route 10_to_Pokecenter Route 10"] = {function() Mode_MoveToCell("Route 10", 8,0,25,11,18,4) end,function() Mode_MoveToCell("Route 10", 8,21,26,34,28,0) end,function() Mode_MoveToCell("Route 10", 27,0,30,34,28,0) end}
DescMaps["Route 9_to_Pokecenter Route 10"] = {function() Mode_MoveToCell("Route 9", 0,0,97,35,87,33) end}

-- POKEMON TOWER 
DescMaps["Pokemon Tower B3_to_Pokemon Tower B4"] = {function() Mode_MoveToCell("Pokemon Tower B3", 23,17,23,19,23,20) end,function() Mode_MoveToCell("Pokemon Tower B3", 17,19,19,22,17,23) end,function() Mode_MoveToCell("Pokemon Tower B3", 23,20,23,21,23,22) end}
DescMaps["Pokemon Tower B7_to_Pokemon Tower B8"] = {function() Mode_MoveToCell("Pokemon Tower B7", 0,0,99,99,23,17) end}
DescMaps["Pokemon Tower B9_to_Pokemon Tower B11"] = {function() Mode_MoveToCell("Pokemon Tower B9", 17,17,19,21,18,21) end,function() Mode_MoveToCell("Pokemon Tower B9", 21,17,24,21,24,21) end}
DescMaps["Pokemon Tower B10_to_Pokemon Tower B11"] = {function() Mode_MoveToCell("Pokemon Tower B10", 17,16,23,21,23,17) end,function() Mode_MoveToCell("Pokemon Tower B10", 21,22,23,23,23,22) end}
DescMaps["Pokemon Tower B11_to_Pokemon Tower B12"] = {function() Mode_MoveToCell("Pokemon Tower B11", 0,0,99,99,17,17) end}
DescMaps["Pokemon Tower B17_to_Pokemon Tower B18"] = {function() Mode_MoveToCell("Pokemon Tower B17", 19,17,24,20,20,19) end,function() Mode_MoveToCell("Pokemon Tower B17", 17,21,21,23,18,22) end}
DescMaps["Pokemon Tower B18_to_Pokemon Tower B19"] = {function() Mode_MoveToCell("Pokemon Tower B18", 0,0,99,99,23,22) end}
DescMaps["Pokemon Tower B19_to_Pokemon Tower B20"] = {function() Mode_MoveToCell("Pokemon Tower B19", 20,22,23,22,20,21) end,function() Mode_MoveToCell("Pokemon Tower B19", 17,20,20,21,18,20) end,function() Mode_MoveToCell("Pokemon Tower B19", 17,22,19,23,18,20) end}
DescMaps["Pokemon Tower B20_to_Pokemon Tower B21"] = {function() Mode_MoveToCell("Pokemon Tower B20", 17,22,19,23,18,22) end,function() Mode_MoveToCell("Pokemon Tower B20", 20,20,24,23,22,19) end,function() Mode_MoveToCell("Pokemon Tower B20", 17,16,24,19,22,19) end}

-- SPEAK WITH NPC --
-- SAFARI KANTO ALL MAPS
DescMaps["Safari Stop_to_Safari Entrance"] = {function() Mode_SpeakWithNPC("Safari Stop","Hello! Welcome to the safari zone!",{1},6,5,6,4) end}
DescMaps["Safari Entrance_to_Safari Stop"] = {function() Mode_SpeakWithNPC("Safari Entrance","NoNeed",{1},27,24,27,25) end}
DescMaps["Safari Area 3_to_Safari Exclusive"] = {function() Mode_SpeakWithNPC("Safari Area 3","NoNeed",{1},17,33,17,34) end}
DescMaps["Safari Exclusive_to_Safari Area 3"] = {function() Mode_SpeakWithNPC("Safari Exclusive","NoNeed",{1},21,4,21,3) end}
DescMaps["Safari Stop_to_Safari Effort Wald 2"] = {function() Mode_SpeakWithNPC("Safari Stop","Hello! Welcome to the safari zone!",{2},7,5,7,4) end}
DescMaps["Safari Effort Wald 2_to_Safari Effort Wald 1"] = {function() Mode_SpeakWithNPC("Safari Effort Wald 2","NoNeed",{1},8,27,8,28) end}
DescMaps["Safari Effort Wald 1_to_Safari Effort Wald 2"] = {function() Mode_SpeakWithNPC("Safari Effort Wald 1","NoNeed",{1},6,22,6,21) end}
DescMaps["Safari Effort Wald 2_to_Safari Stop"] = {function() Mode_SpeakWithNPC("Safari Effort Wald 2","Hello. How may I help you?",{3,1},8,27,8,28) end}
DescMaps["Safari Effort Wald 1_to_Safari Stop"] = {function() Mode_SpeakWithNPC("Safari Effort Wald 1","Hello. How may I help you?",{3,1},6,22,6,21) end}

--DescMaps[" "] = {function() Mode_MoveToCell(" ", ,,,,,) end}
--DescMaps[" "] = {function() Mode_SpeakWithNPC("","",{},,,,) end}
