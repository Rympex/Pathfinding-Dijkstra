

MapException_Lib = require "Maps_Exceptions"
KantoMap = require "Kanto/KantoMap"

-----------------------------------
--- DIJKSTRA CODE PATHFINDING   ---
-----------------------------------

local Nodes = {}
local NodesIndex = {}
local Edges = {}
local StartNode = nil

local push = table.insert

local function NewNode(name)
	node = {}
	node.name = name
	node.Pre = nil
	node.Dist = -1
	node.vis = false
	push(Nodes,node)
	NodesIndex[name] = #Nodes
end

local function NewEdge(Node1,Node2,EdgeVal)
	edge = {}
	edge.N1 = Node1
	edge.N2 = Node2
	edge.Dist = EdgeVal
	push(Edges,edge)
end

local function SetStartNode(name)
	Nodes[NodesIndex[name]].Dist = 0
	StartNode = name
end

local function EdgeConnectsNodes(E,N1,N2)
	return E.N1 == N1 and E.N2 == N2 or E.N1 == N2 and E.N2 == N1
end

local function GetDistance(N1,N2)
	for i=1,#Edges,1 do
		if EdgeConnectsNodes(Edges[i],N1,N2) then
			return Edges[i].Dist
		end
	end
	return -1
end

local function GetNumOfUnVisNodes()
	local NOUVN = 0
	for i=1,#Nodes,1 do
		if not Nodes[i].vis then
			NOUVN = NOUVN + 1
		end
	end
	return NOUVN
end

local function GetAllAdjcentNodes(N,AdjNodes)
	for i=1,#Edges,1 do
		if Edges[i].N1 == N and not Nodes[NodesIndex[Edges[i].N2]].vis then
			push(AdjNodes,Edges[i].N2)
		elseif Edges[i].N2 == N and not Nodes[NodesIndex[Edges[i].N1]].vis then
			push(AdjNodes,Edges[i].N1)
		end
	end
end

local function VisitClosestNode()
	local index=0
	local Dist=0
	for i=1,#Nodes,1 do
		if not Nodes[i].vis and Nodes[i].Dist >= 0 then
			Dist = Nodes[i].Dist
			index=i
			break
		end
	end
	for i=1,#Nodes,1 do
		if Nodes[i].Dist < Dist and not Nodes[i].vis and Nodes[i].Dist >= 0 then
			Dist = Nodes[i].Dist
			index = i
		end
	end
	Nodes[index].vis = true
	return index
end

local function Dijkstras()
	while GetNumOfUnVisNodes()>0 do
		local ClosetsNode = Nodes[VisitClosestNode()]
		local MyAdjNodes = {}
		GetAllAdjcentNodes(ClosetsNode.name,MyAdjNodes)
		if #MyAdjNodes ~= 0 then
		for i=1,#MyAdjNodes,1  do
			local Distance = ClosetsNode.Dist + GetDistance(ClosetsNode.name,MyAdjNodes[i])
			local AdjNode = Nodes[NodesIndex[MyAdjNodes[i]]]
			if AdjNode.Dist >= 0 then
				if Distance < AdjNode.Dist then
					AdjNode.Dist = Distance
					AdjNode.Pre = ClosetsNode.name
				end
			else
				AdjNode.Dist = Distance
				AdjNode.Pre = ClosetsNode.name
			end
		end
	end
	end
end

local function GetPathTo(N,Path)
	local CN = N
	while CN~=StartNode do
		local Temp = CN
		push(Path,1,Temp)
		CN = Nodes[NodesIndex[CN]].Pre
	end
	push(Path,1,StartNode)
end

function initDij(startPos, EndPos, path)
	for k, v in pairs(path) do
		NewNode(k)
		for l, m in pairs(v) do
			res = splitstring(m,"=")
			NewEdge(k, res[1], res[2]) --fixed distance for heuristic	
			--NewEdge(k, m, v[m]) --fixed distance for heuristic
		end
	end
	SetStartNode(startPos)
	local MyPath = {}
	Dijkstras()
	GetPathTo(EndPos, MyPath)
	return MyPath
end


---------------------------
--- FUNCTION FOR MOVETO ---
---------------------------

function ResetPath()
	PathDestStore = ""
end

function MoveTo(Destination)
	if PathDestStore == Destination then
		MoveWithCalcPath()	
	else
		if not moveToDestination(getMapName(), Destination) == false then
			PathSolution = moveToDestination(getMapName(), Destination)
			PathDestStore = Destination
			for i=0,15 do
			EditPathGenerated()
			end
			log("Percorso: " .. table.concat(PathSolution,"->"))
			MoveWithCalcPath()	
		else
			fatal("Path Not Found ERROR")
		end
	end
end

function MoveWithCalcPath()
	if tablelength(PathSolution) > 0 then	
		if PathSolution[1] == getMapName() then
			table.remove(PathSolution, 1)
			if tablelength(PathSolution) > 0 then
				MovingApply(PathSolution[1])
			end
		else
			MovingApply(PathSolution[1])
		end
	else
		return true
	end	
end

function MovingApply(ToMap)
	if CheckException(getMapName() .. "_to_" .. PathSolution[1]) == true then
		return
	else
		log1time("Maps Remains: " .. tablelength(PathSolution) .. "  Moving To: --> " .. PathSolution[1])	
		if moveToMap(ToMap) == true then
			return
		else
			ResetPath()
			log1time("Error in Path - Reset and Recalc")
			swapPokemon(getTeamSize(), getTeamSize()-1)
		end
	end
end

function moveToDestination(currentPosition, finalPosition)
	--local path = getShortestPath(KantoMap, currentPosition, finalPosition, {})
	local path = initDij(currentPosition, finalPosition, KantoMap)
	if tablelength(path) == 0 then
		return false
	else
		return path
	end	
end


-- ESSENTIAL FUNCTIONS --

-- STRING SPLIT --> RETURN ARRAY TABLE --
function splitstring(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- TABLE LENGTH --
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- LOG 1 TIME ONLY --
LastMessage = ""
function log1time(msg)
	if LastMessage == msg then
	else
		log(msg)
		LastMessage = msg
	end
end