-- ==========================================
-- 🧪 TESTER: SEAMLESS HOP + BRUTAL NUKE LOADING (FIX UI MUNCUL)
-- ==========================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

if queue_on_teleport then
    local ScriptPenyelundup = [[
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local Lighting = game:GetService("Lighting")
        local Workspace = game:GetService("Workspace")

        task.spawn(function()
            task.wait(1)
            game.StarterGui:SetCore("SendNotification", {
                Title = "🤖 Sistem Aktif!",
                Text = "Menghancurkan loading...",
                Duration = 5
            })
        end)

        task.spawn(function()
            local Player = Players.LocalPlayer
            local PlayerGui = Player:WaitForChild("PlayerGui")
            local timeElapsed = 0
            local connection
            
            connection = RunService.RenderStepped:Connect(function(dt)
                timeElapsed = timeElapsed + dt
                if timeElapsed > 10 then
                    connection:Disconnect()
                    return
                end
                
                -- Hapus Efek Buram
                for _, effect in ipairs(Lighting:GetChildren()) do
                    if effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") then
                        effect:Destroy()
                    end
                end
                if Workspace.CurrentCamera then
                    for _, effect in ipairs(Workspace.CurrentCamera:GetChildren()) do
                        if effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") then
                            effect:Destroy()
                        end
                    end
                end
                
                -- Hancurkan UI Loading
                for _, gui in ipairs(PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        local name = string.lower(gui.Name)
                        if string.find(name, "load") or string.find(name, "intro") or string.find(name, "transition") then
                            gui.Enabled = false
                            gui:Destroy()
                        else
                            for _, frame in ipairs(gui:GetChildren()) do
                                if frame:IsA("Frame") and frame.Size.X.Scale >= 0.9 and frame.Size.Y.Scale >= 0.9 then
                                    gui.Enabled = false
                                    gui:Destroy()
                                    break
                                end
                            end
                        end
                    end
                end
                
                -- Lepaskan Karakter
                pcall(function()
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Anchored = false
                    end
                end)
            end)
        end)
    ]]
    queue_on_teleport(ScriptPenyelundup)
end

-- 🚀 TOMBOL HOP (DIJAMIN MUNCUL SEKARANG)
-- Kita pasang di PlayerGui, bukan CoreGui
local targetGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestHopGUI"
screenGui.ResetOnSpawn = false -- Biar gak hilang kalau karakter mati
screenGui.Parent = targetGui

local testButton = Instance.new("TextButton", screenGui)
testButton.Size = UDim2.new(0, 320, 0, 50)
testButton.Position = UDim2.new(0.5, -160, 0.9, -20) -- Naik sedikit biar gak nabrak UI game
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
