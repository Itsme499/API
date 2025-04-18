-- SharkyAPI.lua

local SharkyAPI = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local flying = false
local flyConnection = nil
local flySpeed = 50

-- Csatlakozáskor üzenet
print("✅ API Made by Sharky M3nu")

-- Repülés bekapcsolása / kikapcsolása
function SharkyAPI.toggleFly()
    flying = not flying

    if flying then
        SharkyAPI.startFly()
    else
        SharkyAPI.stopFly()
    end
end

-- Repülés elindítása
function SharkyAPI.startFly()
    if flyConnection then return end

    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    humanoid.PlatformStand = true

    flyConnection = RunService.Heartbeat:Connect(function()
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection += camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection -= camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection -= camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection += camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection += Vector3.new(0, -1, 0)
            end

            if moveDirection.Magnitude > 0 then
                rootPart.Velocity = moveDirection.Unit * flySpeed
            else
                rootPart.Velocity = Vector3.zero
            end
        end
    end)
end

-- Repülés leállítása
function SharkyAPI.stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- API lekapcsolása (fiktív, de mutatom a logikát)
function SharkyAPI.disconnect()
    SharkyAPI.stopFly()
    print("❌ SharkyAPI has been disconnected.")
end

return SharkyAPI
