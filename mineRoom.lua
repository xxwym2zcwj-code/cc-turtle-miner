-- mineRoom.lua
-- Mining Turtle gräbt einen Raum mit variabler Größe
-- Nutzungsbeispiel: mineRoom 5 4 7
-- Turtle muss auf dem Boden stehen, Chest direkt unter ihr für automatisches Auslagern

local width = tonumber(arg[1]) or 5
local height = tonumber(arg[2]) or 4
local depth = tonumber(arg[3]) or 5

local function refuelIfNeeded()
    if turtle.getFuelLevel() == "unlimited" then return end
    if turtle.getFuelLevel() < 20 then
        for s=1,16 do
            turtle.select(s)
            if turtle.refuel(0) then turtle.refuel(1) end
        end
    end
end

local function unloadIfFull()
    if turtle.getItemCount(16) == 0 then return end
    local success, data = turtle.inspectDown()
    if success and data.name:find("chest") then
        for s=1,16 do
            turtle.select(s)
            turtle.dropDown()
        end
        turtle.select(1)
    end
end

local function digUpForwardDown()
    if turtle.detectUp() then turtle.digUp() end
    while turtle.detect() do turtle.dig() end
    if turtle.detectDown() then turtle.digDown() end
end

local function moveForwardSafe()
    while not turtle.forward() do
        if turtle.detect() then turtle.dig() else sleep(0.5) end
    end
end

-- Haupt-Raum-Abbau
for y=1,height do
    for z=1,depth do
        for x=1,width-1 do
            digUpForwardDown()
            moveForwardSafe()
            refuelIfNeeded()
            unloadIfFull()
        end
        digUpForwardDown() -- letzte Position in Reihe
        refuelIfNeeded()
        unloadIfFull()
        -- Am Ende der Reihe: Turtle umdrehen, nächste Reihe starten
        if z < depth then
            if z % 2 == 1 then
                turtle.turnRight()
                digUpForwardDown()
                moveForwardSafe()
                turtle.turnRight()
            else
                turtle.turnLeft()
                digUpForwardDown()
                moveForwardSafe()
                turtle.turnLeft()
            end
        end
    end
    -- Höhe wechseln: Turtle nach oben
    if y < height then
        if turtle.detectUp() then turtle.digUp() end
        turtle.up()
    end
end

print("Fertig! Raum abgegraben.")
