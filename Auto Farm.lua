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
    if level >= 1 and level <= 99 then
        monList = {"Thief1","Thief2","Thief3","Thief4","Thief5"}
        questId = "QuestNPC1"

    elseif level >= 100 and level <= 249 then
        monList = {"ThiefBoss"}
        questId = "QuestNPC2"

    elseif level >= 250 and level <= 499 then
        monList = {"Monkey1","Monkey2","Monkey3","Monkey4","Monkey5"}
        questId = "QuestNPC3"

    elseif level >= 500 and level <= 749 then
        monList = {"MonkeyBoss"}
        questId = "QuestNPC4"

    elseif level >= 750 and level <= 999 then
        monList = {"DesertBandit1","DesertBandit2","DesertBandit3","DesertBandit4","DesertBandit5"}
        questId = "QuestNPC5"

    elseif level >= 1000 and level <= 1499 then
        monList = {"DesertBoss"}
        questId = "QuestNPC6"

    elseif level >= 1500 and level <= 1999 then
        monList = {"FrostRogue1","FrostRogue2","FrostRogue3","FrostRogue4","FrostRogue5"}
        questId = "QuestNPC7"

    elseif level >= 2000 and level <= 2999 then
        monList = {"SnowBoss"}
        questId = "QuestNPC8"

    elseif level >= 3000 and level <= 3999 then
        monList = {"Sorcerer1","Sorcerer2","Sorcerer3","Sorcerer4","Sorcerer5"}
        questId = "QuestNPC9"

    elseif level >= 4000 and level <= 4999 then
        monList = {"PandaMiniBoss"}
        questId = "QuestNPC10"

    elseif level >= 5000 and level <= 6249 then
        monList = {"Hollow1","Hollow2","Hollow3","Hollow4","Hollow5"}
        questId = "QuestNPC11"

    elseif level >= 6250 and level <= 7000 then
        monList = {"StrongSorcerer1","StrongSorcerer2","StrongSorcerer3","StrongSorcerer4","StrongSorcerer5"}
        questId = "QuestNPC12"

    elseif level >= 7000 and level <= 7999 then
        monList = {"Curse1","Curse2","Curse3","Curse4","Curse5"}
        questId = "QuestNPC13"

    elseif level >= 8000 and level <= 8999 then
        monList = {"Slime1","Slime2","Slime3","Slime4","Slime5"}
        questId = "QuestNPC14"

    elseif level >= 9000 and level <= 9999 then
        monList = {"AcademyTeacher1","AcademyTeacher2","AcademyTeacher3","AcademyTeacher4","AcademyTeacher5"}
        questId = "QuestNPC15"

    elseif level >= 10000 and level <= 100000 then
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

local function GetWeapon()
    local list = {}

    for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(list,v.Name)
        end
    end

    return list
end

local SelectWeapon = nil
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

local Dropdown = Tab:Dropdown({
    Title = "Select Weapon",
    Values = GetWeapon(),
    Mulit = false,
    Callback = function(value) 
        SelectWeapon = value
    end
})

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


local function EquipWeapon()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not SelectWeapon then return end

    if SelectWeapon then
    local tool = player.Backpack:FindFirstChild(SelectWeapon)
    if tool and not char:FindFirstChild(SelectWeapon) then
        tool.Parent = char
        end
    end
end

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
        EquipWeapon()
        Hit:FireServer()
        end
    end
end)

