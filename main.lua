--// Hitbox 90x90 Red + ON/OFF + Respawn
--// GUI nhỏ gọn & drag được

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,120,0,40)
Frame.Position = UDim2.new(0.05,0,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1,0,1,0)
ToggleBtn.Text = "Hitbox: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 18
ToggleBtn.Parent = Frame

-- Variables
local enabled = false
local connections = {}

-- Hàm chỉnh hitbox
local function applyHitbox(char)
    for _,v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            if enabled then
                hrp.Size = Vector3.new(90,90,90)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Really red")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2,2,1)
                hrp.Transparency = 1
                hrp.Material = Enum.Material.Plastic
            end
        end
    end
end

-- Toggle
ToggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    ToggleBtn.Text = enabled and "Hitbox: ON" or "Hitbox: OFF"
    applyHitbox(LocalPlayer.Character)

    if enabled then
        connections["loop"] = RunService.Heartbeat:Connect(function()
            applyHitbox(LocalPlayer.Character)
        end)
    else
        if connections["loop"] then
            connections["loop"]:Disconnect()
            connections["loop"] = nil
            applyHitbox(LocalPlayer.Character)
        end
    end
end)

-- Respawn support
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    if enabled then
        applyHitbox(LocalPlayer.Character)
    end
end)
