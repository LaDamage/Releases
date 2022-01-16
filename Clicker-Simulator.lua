--// Script Loader
repeat wait() until game:IsLoaded()
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
	v:Disable()
end

--// Core Variables
local PepsiLib = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = PepsiLib.subs.Wait
local beat = tick()

--// Get Functions
function roundNumber(num)
    return tonumber(string.format("%." .. (0) .. "f", num))
end

function TeleportTo(placeCFrame)
    local player = game.Players.LocalPlayer
    if player.Character then
        player.Character.HumanoidRootPart.CFrame=placeCFrame
    end
 end
 function TeleportWorld(Zones)
    if game:GetService("Workspace").Zones:FindFirstChild(Zones) then
        TeleportTo(game:GetService("Workspace").Zones[Zones].teleport.CFrame)
    end
 end

--// Get Tables
Eggs = {}
Worlds = {}

SelectedEgg = "Basic"
SelectedWorld = "Sky"

for i,v in pairs(game:GetService("Workspace").Eggs:GetChildren()) do
    if not table.find(Eggs, v.Name) then
        table.insert(Eggs, v.Name)
    end
end
for i,v in pairs(game:GetService("Workspace").Zones:GetChildren()) do
    if not table.find(Worlds, v.Name) then
        table.insert(Worlds, v.Name)
    end
end

--// Create UI
local PepsisWorld = PepsiLib:CreateWindow({
    Name = "Clicker Simulator",
    Themeable = {
        Info = "Scripts by CollateralDamage"
    }
})
local GeneralTab = PepsisWorld:CreateTab({
    Name = "General"
})

local FarmingSection = GeneralTab:CreateSection({
    Name = "Farming"
})
FarmingSection:AddToggle({
    Name = "Auto Click",
    Callback = function(state)
        getgenv().Click = state
    end
})
FarmingSection:AddToggle({
    Name = "Auto Claim Gifts",
    Callback = function(state)
        getgenv().ClaimGifts = state
    end
})
FarmingSection:AddToggle({
    Name = "Auto Collect Chests",
    Callback = function(state)
        getgenv().Chest = state
    end
})
FarmingSection:AddToggle({
    Name = "Auto Spin Free Daily",
    Callback = function(state)
        getgenv().SpinDaily = state
    end
})

local EggSection = GeneralTab:CreateSection({
    Name = "Egg Opening"
})
EggSection:AddDropdown({
    Name = "Egg",
    List = Eggs,
    Callback = function(option)
    SelectedEgg = option
        print(value)
    end
})
EggSection:AddToggle({
    Name = "Auto Open Eggs",
    Callback = function(state)
        getgenv().OpenEgg = state
    end
})

local PetSection = GeneralTab:CreateSection({
    Name = "Pet Management"
})

PetSection:AddToggle({
    Name = "Auto Equip Best",
    Callback = function(state)
        getgenv().EquipBest = state
    end
})
PetSection:AddToggle({
    Name = "Auto Craft All",
    Callback = function(state)
        getgenv().CraftAll = state
    end
})

local GamepassSection = GeneralTab:CreateSection({
    Name = "Gamepasses",
    Side = "Right"
})
GamepassSection:AddButton({
    Name = "Unlock Fast Auto Clicker",
    Callback = function()
        game:GetService("Players").LocalPlayer.Data.gamepasses.Value = game:GetService("Players").LocalPlayer.Data.gamepasses.Value..";autoclicker;"
    end
})
GamepassSection:AddButton({
    Name = "Unlock Auto Rebirth",
    Callback = function()
        game:GetService("Players").LocalPlayer.PlayerGui.mainUI.rebirthBackground.Background.Background.auto.Visible = true
        game:GetService("Players").LocalPlayer.Data.gamepasses.Value = game:GetService("Players").LocalPlayer.Data.gamepasses.Value..";autorebirth;"
    end
})
GamepassSection:AddButton({
    Name = "Unlock More Inventory Space",
    Callback = function()
        game:GetService("Players").LocalPlayer.Data.gamepasses.Value = game:GetService("Players").LocalPlayer.Data.gamepasses.Value..";500extrapets;;100extrapets;;30extrapets;"
        game:GetService("Players").LocalPlayer.Data.gamepasses.Value = game:GetService("Players").LocalPlayer.Data.gamepasses.Value..";lucky;;superlucky;"
    end
})
local PlayerSection = GeneralTab:CreateSection({
    Name = "Player Management",
    Side = "Right"
})
PlayerSection:AddDropdown({
    Name = "Zone to teleport",
    List = Worlds,
    Callback = function(option)
        SelectedWorld = option
        print(SelectedWorld)
    end
})
PlayerSection:AddButton({
    Name = "Teleport",
    Callback = function()
        if SelectedWorld then
            TeleportWorld(SelectedWorld)
        end
    end
})
PlayerSection:AddSlider({
    Name = "WalkSpeed",
    Value = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed,
    Min = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed,
    Max = 150,
    Callback = function(amount)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = amount
    end
})
PlayerSection:AddSlider({
    Name = "JumpPower",
    Value = game.Players.LocalPlayer.Character.Humanoid.JumpPower,
    Min = game.Players.LocalPlayer.Character.Humanoid.JumpPower,
    Max = 150,
    Callback = function(amount)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = amount
    end
})

spawn(function()
    while task.wait(.1) do
        if getgenv().Click then
            for i,v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.mainUI.clickerButton.MouseButton1Click)) do
                v:Fire()
            end
        end
    end
end)
spawn(function()
    while task.wait(0.5) do
        if getgenv().ClaimGifts then
            if game:GetService("Players").LocalPlayer.PlayerGui.randomGiftUI.randomGiftBackground.Visible == true then
                game:GetService("ReplicatedStorage").Events.Client.collectGifts:FireServer()
                for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.randomGiftUI.randomGiftBackground.Background.confirm.MouseButton1Click)) do
                    v:Fire()
                end
            end
        end
    end
end)
spawn(function()
    while task.wait(0.5) do
        if getgenv().Chest then
            game:GetService("ReplicatedStorage").Events.Client.claimChestReward:InvokeServer("Clicks")
            game:GetService("ReplicatedStorage").Events.Client.claimChestReward:InvokeServer("Rebirths")
        end
    end
end)
spawn(function()
    while task.wait(0.5) do
        if getgenv().SpinDaily then
            if game:GetService("Players").LocalPlayer.Data.freeSpinTimeLeft.Value == 0 then
                game:GetService("ReplicatedStorage").Events.Client.spinWheel:InvokeServer()
            end
        end
    end
end)
spawn(function()
    while task.wait() do
        if getgenv().OpenEgg then
            game:GetService("ReplicatedStorage").Events.Client.purchaseEgg:InvokeServer(workspace.Eggs[SelectedEgg], false, false)
        end
    end
end)
spawn(function()
    while task.wait() do
        if getgenv().EquipBest then
            if game:GetService("Players").LordHeawin.PlayerGui.framesUI.petsBackground.Background.background.tools.equipBest.BackgroundColor3 == Color3.fromRGB(64, 125, 255) then
                game:GetService("ReplicatedStorage").Events.Client.petsTools.equipBest:FireServer()
            end
        end
    end
end)
spawn(function()
    while task.wait(10) do
        if getgenv().CraftAll then
            game:GetService("ReplicatedStorage").Events.Client.petsTools.massCombine:FireServer()
        end
    end
end)
print("Script loaded, took", roundNumber((tick() - beat)*10^3), "ms to load.")
