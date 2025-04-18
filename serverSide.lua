-- SharkyAPI.lua

local SharkyAPI = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local flying = false
local flyConnection = nil
local flySpeed = 50

local espEnabled = false
local highlights = {}

local speedBoostEnabled = false
local defaultSpeed = 16  -- Alapértelmezett sebesség
local boostedSpeed = 50  -- Sebesség növelése

-- Csatlakozáskor üzenet
print("✅ API Made by Sharky M3nu")

-- Repülés toggle
function SharkyAPI.toggleFly()
    flying = not flying
    if flying then
        SharkyAPI.startFly()
    else
        SharkyAPI.stopFly()
    end
end

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
            local moveDirection = Vector3.zero

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

            rootPart.Velocity = moveDirection.Magnitude > 0 and moveDirection.Unit * flySpeed or Vector3.zero
        end
    end)
end

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

-- Highlight egy karakterre
function SharkyAPI.highlightTarget(character)
    if not character then return end

    local existing = character:FindFirstChild("SharkyHighlight")
    if existing then
        existing:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "SharkyHighlight"
    highlight.FillColor = Color3.fromRGB(0, 255, 127)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = character

    highlights[#highlights + 1] = highlight
end

-- ESP toggle minden játékosra
function SharkyAPI.toggleHighlight()
    espEnabled = not espEnabled

    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                SharkyAPI.highlightTarget(plr.Character)
            end
        end
    else
        for _, h in ipairs(highlights) do
            if h and h.Parent then
                h:Destroy()
            end
        end
        highlights = {}
    end
end

-- Sebesség növelés (speed boost)
function SharkyAPI.toggleSpeed()
    speedBoostEnabled = not speedBoostEnabled

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if speedBoostEnabled then
                humanoid.WalkSpeed = boostedSpeed  -- Sebesség növelése
                print("Speed boost enabled!")
            else
                humanoid.WalkSpeed = defaultSpeed  -- Visszaállítás alapértelmezett sebességre
                print("Speed boost disabled.")
            end
        end
    end
end

-- API kikapcsolása
function SharkyAPI.disconnect()
    SharkyAPI.stopFly()
    SharkyAPI.toggleHighlight() -- ha ESP aktív, leállítja
    print("❌ SharkyAPI has been disconnected.")
end

return SharkyAPI
