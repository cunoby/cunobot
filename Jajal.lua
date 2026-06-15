-- ==========================================
-- 👑 ULTIMATE BYPASS: THE SHADOW OVERRIDE
-- ==========================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

if queue_on_teleport then
    local ScriptPenyelundup = [[
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Lighting = game:GetService("Lighting")
        local ProximityPromptService = game:GetService("ProximityPromptService")
        local Player = Players.LocalPlayer

        -- BIND TO RENDER STEP (Prioritas Tertinggi 300)
        -- Akan mengalahkan script asli game yang hanya pakai RenderStepped biasa
        RunService:BindToRenderStep("ShadowOverride", 300, function()
            
            -- 1. CEK STATUS: Kalau loading asli sudah 100% dan mematikan diri, kita juga berhenti
            if Player:GetAttribute("LoadingScreenDone") then
                RunService:UnbindFromRenderStep("ShadowOverride")
                return
            end

            -- 2. LAWAN KAMERA KUNCI (Defeat setCam)
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end

            -- 3. LEMPAR LOADING MENU KE LANGIT (Biar gak nutupin layar)
            pcall(function()
                local menu = workspace:FindFirstChild("LoadingScreenMenu")
                if menu and workspace.CurrentCamera then
                    menu.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 1000, 0)
                end
            end)

            -- 4. BEBASKAN KARAKTER (Defeat anchorCharacter)
            pcall(function()
                local char = Player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.Anchored = false
                end
            end)

            -- 5. HAPUS EFEK BLUR (Defeat startTransparentBGfx)
            pcall(function()
                for _, effect in ipairs(Lighting:GetChildren()) do
                    if effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") then
                        effect.Size = 0
                        effect.Enabled = false
                    end
                end
            end)

            -- 6. PAKSA NYALAKAN PROMPT (Biar bot Auto Steal-mu langsung bisa nyuri)
            ProximityPromptService.Enabled = true
        end)
    ]]
    
    queue_on_teleport(ScriptPenyelundup)
end

-- 🚀 TOMBOL SEAMLESS HOP (Menggunakan gethui() agar tidak dihilangkan oleh game)
local container = (gethui and gethui()) or game:GetService("CoreGui")
if not pcall(function() local _ = container.Name end) then
    container = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HopGui_AntiHide"
screenGui.Parent = container

local testButton = Instance.new("TextButton", screenGui)
testButton.Size = UDim2.new(0, 320, 0, 50)
testButton.Position = UDim2.new(0.5, -160, 0.9, -20)
testButton.Text = "🚀 HOP & THE SHADOW OVERRIDE"
testButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
testButton.TextColor3 = Color3.new(1, 1, 1)
testButton.Font = Enum.Font.GothamBold
testButton.TextSize = 16

-- Tambahkan efek visual garis tepi biar keren
local stroke = Instance.new("UIStroke", testButton)
stroke.Color = Color3.fromRGB(0, 255, 100)
stroke.Thickness = 2

testButton.MouseButton1Click:Connect(function()
    testButton.Text = "🔍 Melacak Server..."
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    
    task.spawn(function()
        local s, r = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100") end)
        if s and r then
            local data = HttpService:JSONDecode(r)
            local servers = {}
            for _, srv in ipairs(data.data) do
                if srv.playing < (srv.maxPlayers - 2) and srv.id ~= JobId then
                    table.insert(servers, srv.id)
                end
            end
            if #servers > 0 then
                testButton.Text = "⚡ MENGHILANG..."
                TeleportService:SetTeleportGui(Instance.new("ScreenGui"))
                TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
            else
                testButton.Text = "❌ Server Penuh! Tunggu..."
                task.wait(3)
                testButton.Text = "🚀 HOP & THE SHADOW OVERRIDE"
            end
        end
    end)
end)
