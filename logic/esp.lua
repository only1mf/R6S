-- esp.lua

local esp = {}

-- Function to enable ESP
function esp.esp_enable()
    -- Check if ESP is already enabled
    if esp.enabled then return end
    esp.enabled = true

    -- Add your ESP logic here
    print("ESP Enabled")

    -- Example: Create ESP for players (you can add your own ESP logic here)
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

    -- Hook into PlayerAdded and CharacterAdded events to add ESP when new players join
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if character:FindFirstChild("Head") then
                -- Add ESP for this player's character
            end
        end)
    end)
end

-- Function to disable ESP
function esp.esp_disable()
    -- Check if ESP is already disabled
    if not esp.enabled then return end
    esp.enabled = false

    -- Remove all ESP elements (such as BillboardGui)
    print("ESP Disabled")
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

-- Initialize the `esp` table and return it
return esp
