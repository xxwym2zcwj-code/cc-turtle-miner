-- mineRoom.lua
-- Turtle gräbt einen rechteckigen Raum und legt Items in eine Chest unter sich

local width = tonumber(arg[1]) or 5
local height = tonumber(arg[2]) or 4
local depth = tonumber(arg[3]) or 5

-- Prüfen, ob Turtle genug Fuel hat
local function refuelIfNeeded()
    if turtle.getFuelLevel() == "unlimited" then return end
    if turtle.getFuelLevel() < 20 then
        for s=1,16 do
            turtle.select(s)
            if turtle.refuel(1) then return end
        end
    end
end

-- Items in Chest unter der Turtle ablegen
local function unloadIfFull()
    if turtle.getItemCount(16) > 0 then
        local success, data = turtle.inspectDown()
        if success and data.name:find("chest") then
            for s=1,16 do
                turtle.select(s)
                turtle.dropDown()
            end
        else
            print("Inventar voll, keine Chest gefunden!")
        end
    end
end

-- Funktion: Grabe Block vor, oben, unten
local function digSafe()
    if turtle.detectUp() then turtle.digUp() end
    while turtle.detect() do turtle.dig() end
    if turtle.detectDown() then turtle.digDown() end
end

-- Funktion: Sicheres Vorwärts
local function forwardSafe()
    while not turtle.forward() do
        if turtle.detect() then turtle.dig() else sleep(0.5) end
    end
end

-- Haupt-Raum-Abbau
for y=1,height do
    for z=1,depth do
        for x=1,width-1 do
            digSafe()
            forwardSafe()
            refuelIfNeeded()
            unloadIfFull()
        end
        digSafe()
        refuelIfNeeded()
        unloadIfFull()
        -- Am Ende einer Reihe: nur drehen, wenn nicht letzte Zeile
        if z < depth then
            if z % 2 == 1 then
                turtle.turnRight()
                digSafe()
                forwardSafe()
                turtle.turnRight()
            else
                turtle.turnLeft()
                digSafe()
                forwardSafe()
                turtle.turnLeft()
            end
        end
    end
    if y < height then
        if turtle.detectUp() then turtle.digUp() end
        turtle.up()
    end
end

print("Fertig! Raum abgegraben.")
