-- ==========================================
-- 🧪 TESTER: SEAMLESS HOP + BRUTAL NUKE LOADING
-- ==========================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

if queue_on_teleport then
    -- 🧳 KODE PENYELUNDUP: VERSI BRUTAL NUKE
    local ScriptPenyelundup = [[
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")

        task.spawn(function()
            task.wait(1)
            game.StarterGui:SetCore("SendNotification", {
                Title = "🤖 Sistem Aktif!",
                Text = "Membasmi Loading Screen...",
                Duration = 5
            })
        end)

        task.spawn(function()
            local Player = Players.LocalPlayer
            local PlayerGui = Player:WaitForChild("PlayerGui")
            
            local timeElapsed = 0
            local connection
            
            -- Mesin pembunuh berjalan setiap frame!
            connection = RunService.RenderStepped:Connect(function(dt)
                timeElapsed = timeElapsed + dt
                
                -- Otomatis mati setelah 15 detik agar tidak bikin lag game
                if timeElapsed > 15 then
                    connection:Disconnect()
                    return
                end
                
                for _, gui in ipairs(PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        for _, desc in ipairs(gui:GetDescendants()) do
                            if desc:IsA("TextLabel") and desc.Text ~= "" then
                                local txt = string.lower(desc.Text)
                                -- Cari kata kunci di layar
                                if string.find(txt, "loading") or string.find(txt, "harvest") then
                                    gui.Enabled = false
                                    gui:Destroy()
                                end
                            end
                        end
                    end
                end
            end)
        end)
        
        -- AREA EKSEKUSI HUB:
        -- loadstring(game:HttpGet("LINK_SCRIPT_KAMU_DISINI"))()
    ]]
    
    queue_on_teleport(ScriptPenyelundup)
end

-- 🚀 TOMBOL HOP
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local testButton = Instance.new("TextButton", screenGui)
testButton.Size = UDim2.new(0, 320, 0, 50)
testButton.Position = UDim2.new(0.5, -160, 0.9, 0)
testButton.Text = "🚀 HOP + BRUTAL NUKE"
testButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.Font = Enum.Font.GothamBold
testButton.TextSize = 16

testButton.MouseButton1Click:Connect(function()
    testButton.Text = "🔍 Mencari Server..."
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    
    task.spawn(function()
        local success, result = pcall(function()
            local api_url = "https://games.roblox.com/v1/games/" .. tostring(PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
            return game:HttpGet(api_url)
        end)
        
        if success and result then
            local data = HttpService:JSONDecode(result)
            local targetServer = nil
            
            for _, server in ipairs(data.data) do
                if type(server) == "table" and server.playing < server.maxPlayers and server.id ~= JobId then
                    targetServer = server.id
                    break
                end
            end
            
            if targetServer then
                testButton.Text = "⚡ MENGHILANG..."
                local invisibleGui = Instance.new("ScreenGui")
                invisibleGui.IgnoreGuiInset = true
                TeleportService:SetTeleportGui(invisibleGui)
                TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
            else
                testButton.Text = "❌ Gagal Dapat Server"
                task.wait(2)
                testButton.Text = "🚀 HOP + BRUTAL NUKE"
            end
        end
    end)
end)
