local esp = {}

local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Drawing = require(game:GetService("ReplicatedStorage"):WaitForChild("Drawing"))

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Radius = 200 -- Example radius for the FOV

-- Function to enable ESP
function esp.esp_enable()
    -- Check if ESP is already enabled
    if esp.enabled then return end
    esp.enabled = true

    -- Example: Create ESP for players (you can add your own ESP logic here)
    print("ESP Enabled")

    -- Start the render loop
    esp.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
        -- Update FOV Circle position based on mouse location
        FOVCircle.Position = UserInputService:GetMouseLocation()

        -- Loop through all players
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local RootPart = v.Character.HumanoidRootPart
                local Vector, onScreen = Camera:WorldToViewportPoint(RootPart.Position)

                -- If ESP is enabled and player is on screen, draw the box
                if esp.enabled and onScreen then
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

    -- Hook into PlayerAdded and CharacterAdded events to add ESP when new players join
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if character:FindFirstChild("Head") then
                -- You can add custom logic to display ESP for this character
            end
        end)
    end)
end

-- Function to disable ESP
function esp.esp_disable()
    -- Check if ESP is already disabled
    if not esp.enabled then return end
    esp.enabled = false

    -- Remove all ESP elements (such as drawing objects)
    print("ESP Disabled")

    -- Disconnect the render loop
    if esp.RenderSteppedConnection then
        esp.RenderSteppedConnection:Disconnect()
    end
end

-- Initialize the `esp` table and return it
return esp
