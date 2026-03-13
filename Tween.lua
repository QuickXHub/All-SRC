-- setclipboard(tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame))
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local function TweenTo(targetRoot)
    local startPos = hrp.Position
    local direction = (targetRoot - startPos).Unit
    local totaDistance = (targetRoot - startPos).Magnitude

    local stepDistance = 15
    local stepDelay = 0.08

    local steps = math.ceil(totaDistance / stepDistance)

    for i = 1, steps do
        local progress = i / steps
        local newPos = startPos + (direction * (progress * totaDistance))

        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(newPos),0.8)

        task.wait(stepDelay)

        hrp.Velocity = Vector3.new(0,0,0)
    end
    hrp.CFrame = CFrame.new(targetRoot)
end
-- วิธีใช้ ให้พิมพ์TweenTo(Vector3.new(ใส่พิกัด))
TweenTo(Vector3.new())
