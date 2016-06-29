name = "Pathfind - Dijkstra Code - By Rympex"
author = "https://github.com/Rympex"

description = [[EDITED PATH FIND, WITH EXCEPTION MAPs]]

Import_Essentials = require "Maps_Pathfind"
	
function onPathAction()
	MoveTo("Fuchsia City") -- MoveTo is Casensitive 
end

function onBattleAction()
	return
end

function onDialogMessage(message)
	SolveDialog(message) -- allow the bot interact with NPC maps
end

function onStop()
	ResetPath() -- Reset Path and Recalc when is online again
end