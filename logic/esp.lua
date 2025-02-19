-- esp.lua

local esp_enabled = false

-- Function to enable ESP
function esp_enable()
    if esp_enabled then return end
    esp_enabled = true

    -- Example of adding ESP: Add labels or indicators here
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local label = Instance.new("BillboardGui")
            label.Adornee = player.Character.Head
            label.Size = UDim2.new(0, 100, 0, 50)
            label.StudsOffset = Vector3.new(0, 2, 0)
            label.Parent = player.Character.Head

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = player.Name
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.BackgroundTransparency = 1
            textLabel.Parent = label
        end
    end

    -- You could also hook into events to handle player joins or character respawn
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if character:FindFirstChild("Head") then
                -- Add ESP for this player's character
            end
        end)
    end)
end

-- Function to disable ESP
function esp_disable()
    if not esp_enabled then return end
    esp_enabled = false

    -- Remove all ESP elements (such as BillboardGui)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            for _, child in pairs(head:GetChildren()) do
                if child:IsA("BillboardGui") then
                    child:Destroy() -- Remove the ESP
                end
            end
        end
    end
end
