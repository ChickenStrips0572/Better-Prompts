--[[
        Better_Promts

	written by the_beanz68(ChickenStrips0572)
    made to fix an issue with trying to refreance Proximity Prompts.

    refreances

    :listeningpromts(Name:string) is to check if the code is listenting to a promt.

    :Add(Listen:string,Module:ModuleScript) is to add a promt to listen to.

    :remove(Listen:string) is to remove a promt that are being listen to.
]]




local Better_Promts = {}

local Serverlisteningpromts = {}
local Runservice = game:GetService("RunService")
local Event

type ServerListenTemp = {
	promtName:string,
	Module:ModuleScript?
}




function Better_Promts:ListeningtoPromt(Listen:string):boolean
	for _,V in Serverlisteningpromts do
		if V.promtName == Listen then
			return true
		end
	end
	return false
end

function Better_Promts:Add(Listen:string,Module:ModuleScript|nil)
	if Better_Promts:ListeningtoPromt(Listen) == false and Runservice:IsServer() then
		local temptable:ServerListenTemp = {
			promtName = Listen,
			Module = Module
		}
		table.insert(Serverlisteningpromts,temptable)
		
		if script:FindFirstChildOfClass("RemoteEvent") then
			script:FindFirstChildOfClass("RemoteEvent"):FireAllClients("Add",temptable.promtName)
		end
	end
end

function Better_Promts:Remove(Listen:string)
	if Runservice:IsServer() then
		for Num,V in Serverlisteningpromts do
			if V.promtName == Listen then
				table.remove(Serverlisteningpromts,Num)
				break
			end
		end
		if script:FindFirstChildOfClass("RemoteEvent") then
			script:FindFirstChildOfClass("RemoteEvent"):FireAllClients("Remove",Listen)
		end
	end
end

local function TriggerAlowed(Plyr:Player,Promt:ProximityPrompt):boolean|nil
	if Runservice:IsServer() then
		
		if Promt.RequiresLineOfSight == false then
			if (Plyr.Character:GetPivot().Position -  Promt.Parent.Position).Magnitude < Promt.MaxActivationDistance then
				for _,Tab:ServerListenTemp in Serverlisteningpromts do
					if Tab.promtName == Promt.Name then
						local suc,err = pcall(function()
							require(Tab.Module):Trigger(Plyr,Promt)
						end)
						if not suc then
							print(err)
						end
						break
					end
				end
			end
		else
			--TODO:
		end
		return false
	end
	warn("Trigger allowed checking is server side only")
end


-- auto init
if Runservice:IsServer() and not script:FindFirstChildOfClass("RemoteEvent") then


	Instance.new("RemoteEvent").Parent = script
	
	game.Players.PlayerAdded:Connect(function(plyr)
		for _,Tab in Serverlisteningpromts do
			script:FindFirstChildOfClass("RemoteEvent"):FireClient(plyr,"Add",Tab.promtName)
		end
	end)
	script:FindFirstChildOfClass("RemoteEvent").OnServerEvent:Connect(function(plyr,Promt)
		TriggerAlowed(plyr,Promt)
	end)
end


return Better_Promts