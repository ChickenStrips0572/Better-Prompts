--[[
	Better_Promts

	written by the_beanz68(ChickenStrips0572)
    made to fix an issue with trying to refreance Proximity Prompts.

    reference

    :listeningprompts(Name:string) is to check if the code is listenting to a promt.

    :Add(Listen:string,Module:ModuleScript) is to add a promt to listen to.

    :remove(Listen:string) is to remove a promt that are being listen to.
]]



local Better_Prompts = {}

local Serverlisteningprompts = {}
local Runservice = game:GetService("RunService")
local PromtService = game:GetService("ProximityPromptService")



type ServerListenTemp = {
	promptName: string,
	Module: ModuleScript?
}




function Better_Prompts:IsListeningtoPrompt(Listen: string): boolean
	for _,V in Serverlisteningprompts do
		if V.promptName == Listen then
			return true
		end
	end
	return false
end

function Better_Prompts:Add(Listen: string , Module :ModuleScript|nil)
	if Better_Prompts:IsListeningtoPrompt(Listen) == false and Runservice:IsServer() then
		local temptable: ServerListenTemp = {
			promptName = Listen,
			Module = Module
		}
		table.insert(Serverlisteningprompts,temptable)
	end
end

function Better_Prompts:Remove(Listen: string)
	if Runservice:IsServer() then
		for Num,V in Serverlisteningprompts do
			if V.promptName == Listen then
				table.remove(Serverlisteningprompts,Num)
				break
			end
		end
	end
end

local function TriggerAllowed(Plyr: Player , Prompt: ProximityPrompt):boolean|nil -- figures out if trigger was possable
	if Runservice:IsServer() then

		if Prompt.RequiresLineOfSight == false then
			if (Plyr.Character:GetPivot().Position -  Prompt.Parent.Position).Magnitude < Prompt.MaxActivationDistance then
				for _,Tab: ServerListenTemp in Serverlisteningprompts do
					if Tab.promptName == Prompt.Name then
						local suc,err = pcall(function()
							require(Tab.Module):Trigger(Plyr,Prompt)
						end)
						if not suc then
							print(Prompt.Name .. "Module Trigger Error")
							warn(Prompt.Name .. err)
						end
						break
					end
				end
			end
		else
			--TODO: add line of sight logic
		end
		return false
	end
	warn("Trigger allowed checking is server side only")
	return 
end



-- auto init

local triggered = false


if Runservice:IsServer() and not triggered then -- server auto-init
	triggered = true
	
	PromtService.PromptTriggered:Connect(function(Promt,Plyr)
		TriggerAllowed(Plyr,Promt)
	end)
end


return Better_Prompts