-- ==========================================
-- 🎯 SNIPER LOADINGGUI (BERDASARKAN DATA DEX)
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

        task.spawn(function()
            -- Kasih notif biar tahu ini versi baru atau bukan
            task.wait(1)
            game.StarterGui:SetCore("SendNotification", {
                Title = "🎯 Sniper Aktif!",
                Text = "Membidik LoadingGui...",
                Duration = 3
            })
        end)

        task.spawn(function()
            local Player = Players.LocalPlayer
            local PlayerGui = Player:WaitForChild("PlayerGui", 10)
            if not PlayerGui then return end
            
            local startTime = tick()
            local connection
            
            -- Hajar selama 15 detik pertama
            connection = RunService.RenderStepped:Connect(function()
                if tick() - startTime > 15 then
                    connection:Disconnect()
                    return
                end
                
                -- 💥 1. HANCURKAN TARGET UTAMA: LoadingGui
                local targetGui = PlayerGui:FindFirstChild("LoadingGui")
                if targetGui then
                    targetGui.Enabled = false
                    targetGui:Destroy()
                end
                
                -- 💥 2. HANCURKAN EFEK BLUR (Kalau ada sisa)
                pcall(function()
                    for _, effect in ipairs(Lighting:GetChildren()) do
                        if effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") then
                            effect.Enabled = false
                            effect:Destroy()
                        end
                    end
                end)
                
                -- 🏃‍♂️ 3. PASTIKAN KARAKTER BISA BERGERAK
                pcall(function()
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Anchored = false
                    end
                end)
            end)
        end)
    ]]
    
    -- Tanam versi baru ke dalam koper
    queue_on_teleport(ScriptPenyelundup)
end

-- 🚀 TOMBOL SEAMLESS HOP (SAMA SEPERTI SEBELUMNYA)
local targetGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HopGui"
screenGui.Parent = targetGui

local testButton = Instance.new("TextButton", screenGui)
testButton.Size = UDim2.new(0, 320, 0, 50)
testButton.Position = UDim2.new(0.5, -160, 0.9, -20)
testButton.Text = "🚀 SEAMLESS HOP & KILL LoadingGui"
testButton.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
testButton.TextColor3 = Color3.new(1, 1, 1)

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
            end
        end
    end)
end)
