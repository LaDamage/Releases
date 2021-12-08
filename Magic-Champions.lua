--// Script Loader
repeat wait() until game:IsLoaded()
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
	v:Disable()
end

--// Script Checks
if not syn then
    loadstring(game:HttpGet("https://irisapp.ca/api/Scripts/IrisBetterCompat.lua"))()
end

if game:GetService("CoreGui"):FindFirstChild("OrionLibrary") then 
    game:GetService("CoreGui"):FindFirstChild("OrionLibrary"):Destroy()
end

--// Core Variables
local beat = tick()
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Orion = loadstring(game:HttpGet("https://raw.githubusercontent.com/LaDamage/Orion-Library/main/source.lua"))()

--// Game Variables
local player = game:GetService("Players").LocalPlayer
local WalkSpeed = player.Character.Humanoid.WalkSpeed
local JumpPower = player.Character.Humanoid.JumpPower

local Marketplace = game:GetService("MarketplaceService")
local Get_Game = Marketplace:GetProductInfo(game.PlaceId)

--// Get Functions
function roundNumber(num)
    return tonumber(string.format("%." .. (0) .. "f", num))
end

function OwnsGamepass(userid ,gamepassid)
	local succes, result = pcall(Marketplace.UserOwnsGamePassAsync, Marketplace, userid, gamepassid)
	if not succes then
		result = false
	end
	return result
end

Areas = {}
SelectedArea = "SafeArea"

for i,v in pairs(game:GetService("Workspace").Areas:GetChildren()) do
    if not table.find(Areas, v.Name) then
        table.insert(Areas, v.Name)
    end
end

--// Create UI
local panel = Orion:CreateOrion(Get_Game.Name)

local farming = panel:CreateSection("Farming")
local miscellaneous = panel:CreateSection("Miscellaneous")
local settings = panel:CreateSection("Settings")

--// Farming
farming:Toggle("Farm Strength", function(state)
    getgenv().Strength = state
end)

farming:Toggle("Farm Endurance", function(state)
    getgenv().Endurance = state
end)

farming:Toggle("Farm Wisdom", function(state)
    getgenv().Wisdom = state
end)

farming:Toggle("Farm Speed & Agility", function(state)
    getgenv().SA = state
end)

farming:TextLabel("Other")
farming:Dropdown("Select Area", Areas, function(option)
    --player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Areas[option].Areas.Part.CFrame + Vector3.new(0, 30 ,0)
    if option == "TrainingArea" then
        player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Areas[option].Areas.Part.CFrame + Vector3.new(0, 60 ,0)
    else
        player.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Areas[option].Areas.Part.CFrame
    end
end)

--// Miscellaneous
miscellaneous:TextButton("Redeem", "Redeem All Codes", function()
    local codes = {"RELEASE", "Wizard", "VOLCANO", "TYFOR100LIKES", "10KVISITS", "250LIKESTY", "UPDATE1", "DataFixed"}

    for _, v in pairs(codes) do
        game:GetService("ReplicatedStorage").Server:FireServer("Codes", v)
        wait(2.5)
    end
end)

--// Settings \\--
settings:Slider("WalkSpeed", WalkSpeed, 150, function(value)
    player.Character.Humanoid.WalkSpeed = value
end)

settings:Slider("JumpPower", JumpPower, 250, function(value)
    player.Character.Humanoid.JumpPower = value
end)

settings:KeyBind("Toggle UI", Enum.KeyCode.RightAlt, function()
    game:GetService("CoreGui").OrionLibrary.Enabled = not game:GetService("CoreGui").OrionLibrary.Enabled
end)

settings:TextButton("Destroy", "Destroy the UI", function()
    game:GetService("CoreGui"):FindFirstChild("OrionLibrary"):Destroy()
end)

--// Functions
spawn(function()
    while task.wait(.2) do
        if getgenv().Strength then
            game:GetService("ReplicatedStorage").Server:FireServer("Multiplier", "Strength")
        end
    end
end)

spawn(function()
    while task.wait(.2) do
        if getgenv().Endurance then
            game:GetService("ReplicatedStorage").Server:FireServer("Multiplier", "Endurance")
        end
    end
end)

spawn(function()
    while task.wait(.2) do
        if getgenv().Wisdom then
            game:GetService("ReplicatedStorage").Server:FireServer("Multiplier", "Wisdom")
        end
    end
end)

spawn(function()
    while task.wait(.2) do
        if getgenv().SA then
            game:GetService("ReplicatedStorage").Server:FireServer("Multiplier", "Speed")
            game:GetService("ReplicatedStorage").Server:FireServer("Multiplier", "Agility")
        end
    end
end)
print("Script loaded, took", roundNumber((tick() - beat)*10^3), "ms to load.")
