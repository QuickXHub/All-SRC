local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    return char, hum, root
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents")
local QuestAccept = RemoteEvent:WaitForChild("QuestAccept")
local CombatSystem = ReplicatedStorage:WaitForChild("CombatSystem")
local Remotes = CombatSystem:WaitForChild("Remotes")
local Hit = Remotes:WaitForChild("RequestHit")
local NPCs = workspace:WaitForChild("NPCs")

local function getQuestAndMon()
    local level = player.Data.Level.Value

    local monList
    local questId 
    if level >= 5000 and level <= 10000 then
        monList = {"Thief1","Thief2","Thief3","Thief4","Thief5"}
        questId = "QuestNPC1"
end

    if not monList then
        return nil
    end

    local QuestUI = player.PlayerGui:FindFirstChild("QuestUI")
    local QuestFrame = QuestUI and QuestUI:FindFirstChild("Quest")
    
    if not (QuestFrame and QuestFrame.Visible) then
        QuestAccept:FireServer(questId)
    end

    return monList[math.random(1, #monList)], questId
end

-- local function GetWeapon()
--     local list = {}

--     for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
--         if v:IsA("Tool") then
--             table.insert(list,v.Name)
--         end
--     end

--     return list
-- end

-- local SelectWeapon = nil
getgenv().AutoFarm = false

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Quick X Hub",
    Icon = "chevrons-down", 
    Author = "By : QXH",
})

local Tab = Window:Tab({
    Title = "General",
    Icon = "code-xml", 
    Locked = false,
})
 
-- local Dropdown = Tab:Dropdown({
--     Title = "Select Weapon",
--     Values = GetWeapon(),                  อันนีั้เป็น Ep.2
--     Mulit = false,
--     Callback = function(value) 
--         SelectWeapon = value
--     end
-- })

local Toggle = Tab:Toggle({
    Title = "Auto Farm Level",
    Desc = "Test",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) 
       getgenv().AutoFarm = state
    end
})


-- local function EquipWeapon()
--     local player = game.Players.LocalPlayer
--     local char = player.Character
--     if not SelectWeapon then return end

--     if SelectWeapon then
--     local tool = player.Backpack:FindFirstChild(SelectWeapon)
--     if tool and not char:FindFirstChild(SelectWeapon) then
--         tool.Parent = char
--         end
--     end
-- end

task.spawn(function()
    while task.wait(0.2) do
        if not getgenv().AutoFarm then
            EquipWeapon()
            continue
        end

        if not character or not character.Parent or humanoid.Health <= 0 then
            character, humanoid, root = getCharacter()
        end

    local monName = getQuestAndMon()
    if not monName then 
        continue 
    end

    local target 
    for _, npc in pairs(NPCs:GetChildren()) do
        if npc.Name == monName then
            local hum = npc:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health > 0 then
                target = npc
                break
            end
        end
    end

    if not target then
        task.wait(0.25)
        continue
    end

    local targetRoot = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
    if not targetRoot then 
        continue 
    end

    while getgenv().AutoFarm and task.wait(0.12) do
        local hum = target:FindFirstChildWhichIsA("Humanoid")

        if not hum or hum.Health <= 0 then
            break
        end

        root.CFrame = targetRoot.CFrame * CFrame.new(0,0,5.9)
        -- EquipWeapon()
        Hit:FireServer()
        end
    end
end)

