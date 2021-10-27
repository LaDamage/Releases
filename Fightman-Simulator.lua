--// Iris's Compatibility Script \\--
if not syn then
    loadstring(game:HttpGet("https://irisapp.ca/api/Scripts/IrisBetterCompat.lua"))()
end

--// Anti AFK \\--
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    v:Disable()
end

--// UI Detection \\--
if game:GetService("CoreGui"):FindFirstChild("ScreenGui") then 
    game:GetService("CoreGui"):FindFirstChild("ScreenGui"):Destroy()
end

--// Setup Variables \\--
local plr = game:GetService("Players").LocalPlayer
local WalkSpeed = plr.Character.Humanoid.WalkSpeed
local JumpPower = plr.Character.Humanoid.JumpPower
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local GlovesModule = require(game:GetService("ReplicatedStorage").Modules.Gloves)
local TrainEvent = game:GetService("ReplicatedStorage").Functions.Gloves
local EggEvent = game:GetService("ReplicatedStorage").Functions.OpenEgg
local Power = plr.leaderstats.Power.Value

local Orion = loadstring(game:HttpGet("https://raw.githubusercontent.com/LaDamage/Orion/main/source.lua"))()

--// UI Setup \\--
Eggs = {}
Gloves = {}

getgenv().SelectedEgg = "Basic"
getgenv().SelectedGlove = "Basic"

getgenv().speed = 16

for i,v in pairs(game:GetService("Workspace").Eggs:GetChildren()) do
    if not table.find(Eggs, v.Name) then
        table.insert(Eggs, v.Name)
    end
end
for i,v in pairs(game:GetService("Workspace").Gloves:GetChildren()) do
    if not table.find(Gloves, v.Name) then
        table.insert(Gloves, v.Name)
    end
end

local main = Orion:CreateOrion("Orion | Fightman Simulator")

local farming = main:CreateSection("Farming")
local pets = main:CreateSection("Pets")
local misc = main:CreateSection("Miscellaneous")
local settings = main:CreateSection("Settings")

farming:Dropdown("Select Glove", Gloves, function(option)
    getgenv().SelectedGlove = option
end)

farming:Toggle("Auto Farm Energy", function(state)
    getgenv().energy = state
end)

farming:TextLabel("Other")
farming:Slider("Walk Faster", 8, 32, function(value)
    getgenv().speed = value
end)
farming:Toggle("Faster Training", function(state)
    getgenv().train = state
end)

pets:Dropdown("Select Egg", Eggs, function(option)
    getgenv().SelectedEgg = option
end)

pets:Toggle("Auto Open Eggs x1", function(state)
    getgenv().egg1 = state
end)
pets:Toggle("Auto Open Eggs x3", function(state)
    getgenv().egg3 = state
end)

misc:TextButton("Toggle", "Toggle Error Pop-Ups", function()
    plr.PlayerGui.MainUI.Error.Visible = not plr.PlayerGui.MainUI.Error.Visible
end)

misc:TextButton("Redeem", "Redeem All Codes", function()
    for _, code in pairs(plr.Codes:GetChildren()) do
        if code.Value == false then
            game:GetService("ReplicatedStorage").Functions.Codes:InvokeServer(code.Name)
        end
    end
end)

--// Settings Tab Setup \\--
settings:Slider("WalkSpeed", WalkSpeed, 150, function(value)
    plr.Character.Humanoid.WalkSpeed = value
end)

settings:Slider("JumpPower", JumpPower, 250, function(value)
    plr.Character.Humanoid.JumpPower = value
end)

settings:KeyBind("Toggle UI", Enum.KeyCode.RightControl, function()
    game:GetService("CoreGui").ScreenGui.Enabled = not game:GetService("CoreGui").ScreenGui.Enabled
end)

settings:TextButton("Destroy", "Destroy the UI", function()
    game:GetService("CoreGui"):FindFirstChild("ScreenGui"):Destroy()
end)

--// Functions \\--
while task.wait() do
    spawn(function()
        if getgenv().energy then
            local MaxEquip = Power/GlovesModule[getgenv().SelectedGlove].Req
            for i,v in pairs(game:GetService("Workspace").Gloves:GetChildren()) do
                if v.Name == getgenv().SelectedGlove then
                    if plr.PlayerGui.MainUI.EquippedGlove.Visible == true then
                        plr.Character.HumanoidRootPart.CFrame = v.UIAnchor.CFrame * CFrame.new(55,0,0)
                        wait(.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
                        wait(.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                    else
                        plr.Character.HumanoidRootPart.CFrame = v.UIAnchor.CFrame
                        wait(.1)
                        for i = 1, MaxEquip do 
                            wait()
                            fireproximityprompt(v.UIAnchor.GlovePrompt, 1)
                        end
                    end
                end
            end
        end
    end)

    spawn(function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().speed
    end)

    spawn(function()
        if getgenv().train then
            TrainEvent:InvokeServer("Train")
        end
    end)

    spawn(function()
        if getgenv().egg1 then
            EggEvent:InvokeServer(getgenv().SelectedEgg, "Single")
        end
    end)

    spawn(function()
        if getgenv().egg3 then
            EggEvent:InvokeServer(getgenv().SelectedEgg, "Triple")
        end
    end)
end
