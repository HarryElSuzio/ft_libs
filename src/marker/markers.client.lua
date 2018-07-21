--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

local markers = {}
local activeMarkers = {}
local currentMarkers = {}


--
-- Add Marker to activeMarkers table
--
function EnableMarker(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then

        for _, name in pairs(args[1]) do
            if markers[name] then
                activeMarkers[name] = true
            end
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        if markers[name] then
            activeMarkers[name] = true
        end

    end

end

--
-- Remove Marker to activeMarkers table
--
function DisableMarker(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table"  then

        for _, name in pairs(args[1]) do
            activeMarkers[name] = nil
            currentMarkers[name] = nil
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        activeMarkers[name] = nil
        currentMarkers[name] = nil

    end

end

--
-- Add or Remove Marker to activeMarkers table
--
function SwitchMarker(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then

        for name, status in pairs(args[1]) do
            if markers[name] ~= nil then
                if status == true then
                    EnableMarker(name)
                elseif status == false then
                    DisableMarker(name)
                end
            end
            Citizen.Wait(10)
        end

    elseif count == 2 then

        local name = args[1]
        local status = args[2]
        if markers[name] ~= nil then
            if status == true then
                EnableMarker(name)
            else
                DisableMarker(name)
            end
        end

    end

end

--
-- Add Marker in the markers table
--
function AddMarker(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then

        for name, value in pairs(args[1]) do
            markers[name] = marker.new(value)
            if value.enable == nil or value.enable == true then
                EnableMarker(name)
            end
            Citizen.Wait(10)
        end

    elseif count == 2 then

        local name = args[1]
        local value = args[2]
        markers[name] = marker.new(value)
        if value.enable == nil or value.enable == true then
            EnableMarker(name)
        end

    end

end

--
-- Remove Marker in the markers table
--
function RemoveMarker(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then

        for _, name in ipairs(args[1]) do
            DisableMarker(name)
            markers[name] = nil
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        DisableMarker(name)
        markers[name] = nil

    end

end

--
-- Get Current Marker
--
function CurrentMarker()

    return currentMarkers

end

--
-- Add check for global frame
--
function MarkerFrame()

    Citizen.CreateThread(function()

        while true do

            local playerPed = GetPlayerPed(-1)
            local playerLocalisation = GetEntityCoords(playerPed)
            for name, value in pairs(activeMarkers) do

                local target = markers[name]
                if target then
                    if GetDistanceBetweenCoords(target.x, target.y, target.z, playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, true) <= target.showDistance then
                        target:Show()
                        if target.text ~= nil then
                            Show3DText({
                                x = target.x,
                                y = target.y,
                                z = target.z + target.textOffset,
                                text = target.text,
                            })
                        end
                        currentMarkers[name] = true
                    elseif currentMarkers[name] ~= nil then
                        currentMarkers[name] = nil
                    end
                end

            end

            Citizen.Wait(5)
        end

    end)

end
