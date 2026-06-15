-- ==========================================
-- 👻 PHANTOM LOADING: JALAN DI LATAR BELAKANG
-- ==========================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

if queue_on_teleport then
    local ScriptPenyelundup = [[
        local Players = game:GetService("Players")
        local Lighting = game:GetService("Lighting")
        local RunService = game:GetService("RunService")

        task.spawn(function()
            local Player = Players.LocalPlayer
            local startTime = tick()
            local connection
            
            -- Biarkan berjalan selama 30 detik (cukup untuk loading asli selesai 100%)
            connection = RunService.RenderStepped:Connect(function()
                if tick() - startTime > 30 then
                    connection:Disconnect()
                    return
                end

                -- 👻 1. HILANGKAN BALOK LOADING DARI PANDANGAN KAMERA
                -- Kita biarkan prosesnya jalan, cuma visualnya kita buat 100% transparan!
                pcall(function()
                    local menu = workspace:FindFirstChild("LoadingScreenMenu")
                    if menu and menu:IsA("BasePart") then
                        menu.Transparency = 1
                        local gui = menu:FindFirstChild("LoadingGui")
                        if gui then gui.Enabled = false end
                    end
                end)

                -- 🧹 2. PAKSA HAPUS BLUR (Karena script asli ngotot ngasih blur)
                pcall(function()
                    for _, effect in ipairs(Lighting:GetChildren()) do
                        if effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") then
                            effect.Enabled = false
                        end
                    end
                end)

                -- 🏃‍♂️ 3. BEBASKAN KAMERA & KARAKTER (Override script asli)
                pcall(function()
                    -- Kembalikan kamera ke mode normal (script asli menguncinya ke 'Scriptable')
                    if workspace.CurrentCamera and workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then
                        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                    end
                    
                    -- Lepaskan rantai kaki karakter
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Anchored = false
                    end
                end)
            end)

            game.StarterGui:SetCore("SendNotification", {
                Title = "👻 Phantom Mode!",
                Text = "Loading disembunyikan. Silakan main!",
                Duration = 5
            })
        end)
    ]]
    
    queue_on_teleport(ScriptPenyelundup)
end

-- 🚀 TOMBOL SEAMLESS HOP
local targetGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HopGui"
screenGui.Parent = targetGui

local testButton = Instance.new("TextButton", screenGui)
testButton.Size = UDim2.new(0, 320, 0, 50)
testButton.Position = UDim2.new(0.5, -160, 0.9, -20)
testButton.Text = "🚀 HOP & PHANTOM LOADING"
testButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
testButton.TextColor3 = Color3.new(1, 1, 1)
testButton.Font = Enum.Font.GothamBold
testButton.TextSize = 16

testButton.MouseButton1Click:Connect(function()
    testButton.Text = "🔍 Mencari Server..."
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
                testButton.Text = "🚀 HOP & PHANTOM LOADING"
            end
        end
    end)
end)
