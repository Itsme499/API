local SharkyAPI = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

-- Kiemelés (highlight) logika - Automatikus target megadás
function SharkyAPI.highlightTarget(target)
    -- Ha nincs target, akkor a saját karaktert választjuk
    target = target or player.Character

    if not target then
        warn("Target not found!")
        return
    end

    -- Ha már van highlight, töröljük
    local existing = target:FindFirstChild("SharkyHighlight")
    if existing then
        existing:Destroy()
    end

    -- Highlight objektum létrehozása
    local highlight = Instance.new("Highlight")
    highlight.Name = "SharkyHighlight"
    highlight.FillColor = Color3.fromRGB(0, 255, 127)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = target
    highlight.Parent = target
end

-- Kiemelés kapcsolása / kikapcsolása
function SharkyAPI.toggleHighlight(target)
    -- Ha nincs target, akkor a saját karaktert használjuk
    target = target or player.Character
    SharkyAPI.highlightTarget(target)
end

-- Sebesség beállítása (sebesség növelés)
function SharkyAPI.toggleSpeed()
    -- Sebesség növelés logikája itt
    print("Speed boost activated!")  -- Helyettesíthető a saját sebesség növelő kóddal
end

-- API lekapcsolása
function SharkyAPI.disconnect()
    SharkyAPI.stopFly()
    print("❌ SharkyAPI has been disconnected.")
end

return SharkyAPI
