local esp = {}

local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local FOVCircle = Instance.new("Frame")
FOVCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FOVCircle.BorderSizePixel = 0
FOVCircle.Size = UDim2.new(0, 200, 0, 200)  -- Example radius for the FOV
FOVCircle.Visible = false  -- Hidden initially
FOVCircle.Parent = game.Players.LocalPlayer.PlayerGui -- Set to player’s GUI

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
        FOVCircle.Position = UDim2.new(0, UserInputService:GetMouseLocation().X - FOVCircle.Size.X.Offset / 2,
                                       0, UserInputService:GetMouseLocation().Y - FOVCircle.Size.Y.Offset / 2)

        -- Loop through all players
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local RootPart = v.Character.HumanoidRootPart
                local Vector, onScreen = Camera:WorldToViewportPoint(RootPart.Position)

                -- If ESP is enabled and player is on screen, draw the box
                if esp.enabled and onScreen then
                    local box = Instance.new("Frame")
                    box.Size = UDim2.new(0, 1000 / Vector.Z, 0, 2000 / Vector.Z) -- Full body ESP
                    box.Position = UDim2.new(0, Vector.X - box.Size.X.Offset / 2, 0, Vector.Y - box.Size.Y.Offset / 2)
                    box.BackgroundColor3 = v.TeamColor.Color == LocalPlayer.TeamColor.Color and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    box.BorderSizePixel = 0
                    box.Visible = true
                    box.Parent = game.Players.LocalPlayer.PlayerGui -- Set to player’s GUI

                    -- Optional: Wait before removing the box, adjust if needed
                    task.wait()
                    box:Destroy() -- Remove box after a short delay
                end
            end
        end
    end)

    -- Hook into PlayerAdded and CharacterAdded events to add ESP when new players join
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if character:FindFirstChild("Head") then
                -- Add ESP logic for new players here
            end
        end)
    end)
end

-- Function to disable ESP
function esp.esp_disable()
    -- Check if ESP is already disabled
    if not esp.enabled then return end
    esp.enabled = false

    -- Remove all ESP elements (such as Frames)
    print("ESP Disabled")

    -- Disconnect the render loop
    if esp.RenderSteppedConnection then
        esp.RenderSteppedConnection:Disconnect()
    end

    -- Remove any ESP elements from the player's GUI
    for _, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
end

-- Initialize the `esp` table and return it
return esp
