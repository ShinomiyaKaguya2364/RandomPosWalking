-- Set the range for random positions
local minDistance = 10 -- Minimum distance from the player
local maxDistance = 30 -- Maximum distance from the player

-- Set jump height and power
local jumpHeight = 10
local jumpPower = 50

-- Set the probability of jumping (e.g., 1 in 10 chance)
local jumpProbability = 0.1

local player = game.Players.LocalPlayer -- Get the LocalPlayer
local isMoving = false

-- Function to generate a random position within a specified distance from the player
local function getRandomPosition()
    local distance = math.random(minDistance, maxDistance)
    local angle = math.rad(math.random(0, 360))
    local x = player.Character and player.Character.HumanoidRootPart and player.Character.HumanoidRootPart.Position.X + distance * math.cos(angle) or 0
    local y = player.Character and player.Character.HumanoidRootPart and player.Character.HumanoidRootPart.Position.Y or 0
    local z = player.Character and player.Character.HumanoidRootPart and player.Character.HumanoidRootPart.Position.Z + distance * math.sin(angle) or 0
    return Vector3.new(x, y, z)
end

-- Function to check if there's a reachable higher position
local function canJumpToHigherPosition()
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local direction = humanoidRootPart.CFrame.lookVector
            local rayStart = humanoidRootPart.Position + direction * 5 -- Adjust the distance as needed
            local rayEnd = humanoidRootPart.Position + direction * 10 -- Adjust the distance as needed
            
            local hit, hitPoint = workspace:FindPartOnRayWithIgnoreList(Ray.new(rayStart, rayEnd - rayStart), {player.Character})
            
            if hit then
                local distanceToHit = (hitPoint - humanoidRootPart.Position).Magnitude
                if distanceToHit > 5 and distanceToHit < 10 then
                    local higherPosition = hitPoint + Vector3.new(0, jumpHeight, 0)
                    return higherPosition
                end
            end
        end
    end
    return nil
end

-- Function to make the LocalPlayer jump to a higher position if possible
local function makePlayerJump()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local higherPosition = canJumpToHigherPosition()
            if higherPosition then
                humanoid:MoveTo(higherPosition)
                humanoid:Move(Vector3.new(0, jumpHeight, 0))
                humanoid:Move(Vector3.new(0, -jumpHeight, 0))
                humanoid:Move(Vector3.new(0, jumpHeight, 0))
                humanoid:Move(Vector3.new(0, -jumpHeight, 0))
                humanoid:Move(Vector3.new(0, jumpHeight, 0))
                humanoid:Move(Vector3.new(0, -jumpHeight, 0))
                humanoid:Move(Vector3.new(0, jumpHeight, 0))
                humanoid:Move(Vector3.new(0, -jumpHeight, 0))
                return true -- Player jumped
            end
        end
    end
    return false -- Player couldn't jump
end

-- Function to check if the player has reached their destination
local function hasReachedDestination()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            return humanoid:GetState() == Enum.HumanoidStateType.Seated -- Check if the player is in a seated state (reached the destination)
        end
    end
    return false
end

-- Continuously make the LocalPlayer jump, walk to random positions, or do nothing
task.spawn(pcall, function()while true do
    if not isMoving and math.random() < jumpProbability then
        makePlayerJump() -- Randomly jump
    elseif not isMoving then
        local randomPosition = getRandomPosition()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:MoveTo(randomPosition)
                isMoving = true
            end
        end
    end

    if hasReachedDestination() then
        isMoving = false
    end

    if not isMoving then
        wait(5) -- Wait before generating a new random position or jumping
    end
    wait(0.1) -- Adjust this to control the script's update rate
end
    end)
