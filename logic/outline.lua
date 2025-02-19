local container = Instance.new("Folder", gethui())
local highlightActive = false
local Players = game:GetService("Players")

local highlights = {} -- Table to store active highlights

local function createOutline(character)
    -- Create an outline for the character
    local highlight = Instance.new("Highlight", container)
    highlight.FillColor = BrickColor.new(character.Parent.Name).Color
    highlight.FillTransparency = 0.5 -- Set transparency of the outline
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character

    -- Store the highlight for cleanup when disabled
    table.insert(highlights, highlight)

    -- Destroy the outline when the character is destroyed
    character.Destroying:Connect(function()
        highlight:Destroy()
        -- Remove from the highlights table
        for i, v in ipairs(highlights) do
            if v == highlight then
                table.remove(highlights, i)
                break
            end
        end
    end)

    return highlight
end

-- Function to enable outlines
function outline_enable()
    highlightActive = true
    -- Add outlines for players already in the game
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            createOutline(player.Character)
        end

        -- Listen for new players joining the game
        player.CharacterAdded:Connect(function(character)
            if highlightActive then
                createOutline(character)
            end
        end)
    end
end

-- Function to disable outlines
function outline_disable()
    highlightActive = false
    -- Disable or remove all existing outlines
    for _, highlight in ipairs(highlights) do
        highlight:Destroy()  -- Destroy the highlight instance
    end
    highlights = {}  -- Clear the stored highlights table
end

-- Monitor new players joining the game
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if highlightActive then
            createOutline(character)
        end
    end)
end)
