--written by the_beanz68(ChickenStrips0572)

local listeningpromts = {}
local promtservice = game:GetService("ProximityPromptService")
local module,event = game.ReplicatedStorage.Modules.Better_Promts,nil


while not module:FindFirstChildOfClass("RemoteEvent") do
	task.wait()
end

event = module:FindFirstChildOfClass("RemoteEvent")

event.OnClientEvent:Connect(function(Action:string , Name:string)
	if Action == "Add" then
		table.insert(listeningpromts,Name)
		
	elseif Action == "Remove" then
		for Num,Name:string in listeningpromts do
			if Name == Name then
				table.remove(listeningpromts,Num)
				break
			end
		end
	end
end)

local ShownPromts = {}


promtservice.PromptShown:Connect(function(Promt)
	if not table.find(ShownPromts,Promt) then
		Promt.Triggered:Connect(function()
			event:FireServer(Promt)
		end)
		table.insert(ShownPromts,Promt)
	end	
end)
