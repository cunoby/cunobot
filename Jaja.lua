    local ScriptPenyelundup = [[
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local Lighting = game:GetService("Lighting")
        local Workspace = game:GetService("Workspace")

        task.spawn(function()
            task.wait(1)
            game.StarterGui:SetCore("SendNotification", {
                Title = "🤖 Sistem Aktif!",
                Text = "Tsar Bomba diluncurkan! Menghancurkan loading...",
                Duration = 5
            })
        end)

        task.spawn(function()
            local Player = Players.LocalPlayer
            local PlayerGui = Player:WaitForChild("PlayerGui")
            
            local timeElapsed = 0
            local connection
            
            -- Serangan berjalan 60x per detik!
            connection = RunService.RenderStepped:Connect(function(dt)
                timeElapsed = timeElapsed + dt
                
                -- Matikan otomatis setelah 10 detik agar game kembali normal
                if timeElapsed > 10 then
                    connection:Disconnect()
                    return
                end
                
                -- 💥 1. HAPUS SEMUA EFEK BLUR / BURAM
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
                
                -- 💥 2. HANCURKAN UI LOADING TANPA PANDANG BULU
                for _, gui in ipairs(PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        local name = string.lower(gui.Name)
                        -- Hajar kalau namanya ada unsur loading
                        if string.find(name, "load") or string.find(name, "intro") or string.find(name, "transition") then
                            gui.Enabled = false
                            gui:Destroy()
                        else
                            -- Kalau disamarkan, hajar Frame yang ukurannya menutupi layar penuh!
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
                
                -- 🏃‍♂️ 3. PAKSA KARAKTER BISA BERGERAK (ANTI-FREEZE)
                pcall(function()
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Anchored = false
                    end
                    local controls = require(Player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
                    controls:Enable()
                end)
            end)
        end)
    ]]
