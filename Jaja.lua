-- ==========================================
-- 🧪 TESTER: SEAMLESS HOP + BRUTAL NUKE + ANTI ERROR 772
-- ==========================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

-- 🛡️ SISTEM ANTI POP-UP ERROR ROBLOX
-- Kalau gagal teleport, otomatis tutup pesannya biar gak nyepam
TeleportService.TeleportInitFailed:Connect(function()
    print("Teleport gagal! Menutup pesan error...")
    -- Menghapus UI Error Bawaan Roblox
    local coreGui = game:GetService("CoreGui")
    local robloxPrompt = coreGui:FindFirstChild("RobloxPromptGui")
    if robloxPrompt then
        robloxPrompt:Destroy()
    end
end)

if queue_on_teleport then
    local ScriptPenyelundup = [[
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local Lighting = game:GetService("Lighting")
        local Workspace = game:GetService("Workspace")

        task.spawn(function()
            task.wait(1)
            game.StarterGui:SetCore("SendNotification", {
                Title = "🤖 Mendarat Mulus!",
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

-- 🚀 TOMBOL HOP
local targetGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestHopGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = targetGui

local testButton = Instance.new("TextButton", screenGui)
testButton.Size = UDim2.new(0, 320, 0, 50)
testButton.Position = UDim2.new(0.5, -160, 0.9, -20)
testButton.Text = "🚀 HOP (ANTI ERROR 772)"
testButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.Font = Enum.Font.GothamBold
testButton.TextSize = 16

testButton.MouseButton1Click:Connect(function()
    testButton.Text = "🔍 Mencari Target Aman..."
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    
    task.spawn(function()
        local success, result = pcall(function()
            -- Sortir Desc biar dapet server yang isinya lumayan tapi belum penuh
            local api_url = "https://games.roblox.com/v1/games/" .. tostring(PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100"
            return game:HttpGet(api_url)
        end)
        
        if success and result then
            local data = HttpService:JSONDecode(result)
            local availableServers = {}
            
            for _, server in ipairs(data.data) do
                -- 🛡️ SYARAT KETAT: Harus sisa minimal 2 slot kosong, dan ada pemainnya (bukan server mati)
                if type(server) == "table" and server.playing < (server.maxPlayers - 1) and server.playing > 0 and server.id ~= JobId then
                    table.insert(availableServers, server.id)
                end
            end
            
            if #availableServers > 0 then
                -- 🎲 ACAK PILIHAN SERVER! Biar gak tabrakan sama cheater lain
                local targetServer = availableServers[math.random(1, #availableServers)]
                
                testButton.Text = "⚡ MENGHILANG..."
                local invisibleGui = Instance.new("ScreenGui")
                invisibleGui.IgnoreGuiInset = true
                TeleportService:SetTeleportGui(invisibleGui)
                TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
            else
                testButton.Text = "❌ Semua Server Penuh/Kosong"
                task.wait(2)
                testButton.Text = "🚀 HOP (ANTI ERROR 772)"
            end
        else
            testButton.Text = "❌ Gagal Ambil Data"
            task.wait(2)
            testButton.Text = "🚀 HOP (ANTI ERROR 772)"
        end
    end)
end)
