local ESP_ENABLED = false
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Drawing = require(game:GetService("ReplicatedStorage"):WaitForChild("Drawing"))

-- Set up drawing objects
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Radius = 200 -- Example radius for the FOV

-- Function to enable ESP
function esp_enable()
    ESP_ENABLED = true
    RenderSteppedConnection = RunService.RenderStepped:Connect(function()
        -- Update FOV Circle position based on mouse location
        FOVCircle.Position = UserInputService:GetMouseLocation()
        
        -- Loop through all players
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local RootPart = v.Character.HumanoidRootPart
                local Vector, onScreen = Camera:WorldToViewportPoint(RootPart.Position)

                -- If ESP is enabled and player is on screen, draw the box
                if ESP_ENABLED and onScreen then
                    local Box = Drawing.new("Square")
                    Box.Size = Vector2.new(1000 / Vector.Z, 2000 / Vector.Z) -- Full body ESP
                    Box.Position = Vector2.new(Vector.X - Box.Size.X / 2, Vector.Y - Box.Size.Y / 2)
                    Box.Color = v.TeamColor.Color == LocalPlayer.TeamColor.Color and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    Box.Visible = true
                    
                    -- Optional: Wait before removing the box, adjust if needed
                    task.wait()
                    Box:Remove()
                end
            end
        end
    end)
end

-- Function to disable ESP
function esp_disable()
    ESP_ENABLED = false
    if RenderSteppedConnection then
        RenderSteppedConnection:Disconnect()
    end
end

-- Monitor new players joining the game
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if ESP_ENABLED then
            -- Here you could also call create outline or other visual logic if needed
        end
    end)
end)
