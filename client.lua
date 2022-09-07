local CAM_TOGGLE = "F3"
local CAM_HEIGHT = 0.4 -- decimal of screen height, where 1.0 is 100% and 0.0 is 0%


local camActive = false
local camMoving = false
local camHeight = 0.0


local function hideHUDComponents()
    for i = 0, 22 do
        if IsHudComponentActive(i) then
            HideHudComponentThisFrame(i)
        end
    end
end

local function setupHealthArmour(minimap, barType)
    BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
    ScaleformMovieMethodAddParamInt(barType)
    EndScaleformMovieMethod()
end

local function handleCinmetaicAnim() -- [[Handles Displaying Radar, Body Armour and the rects themselves.]]
    camMoving = true

    DisplayRadar(not camActive)
    setupHealthArmour(camActive and 3 or 0)

    if camActive then
        for i = 0, CAM_HEIGHT, 0.01 do
            camHeight = i

            Wait(10)
        end
    else
        for i = CAM_HEIGHT, 0, -0.01 do
            camHeight = i

            Wait(10)
        end
    end

    camMoving = false
end


CreateThread(function()
    RegisterKeyMapping("+cinematic", "Toggle Cinematic View", "KEYBOARD", CAM_TOGGLE)
    RegisterCommand("+cinematic", function()
        if IsPauseMenuActive() then
            return
        end

        if camMoving then
            return
        end

        camActive = not camActive

        CreateThread(handleCinmetaicAnim)

        while camHeight > 0.0 or camActive do
            for i = 0, 1.0, 1.0 do
                DrawRect(0.0, 0.0, 2.0, camHeight, 0, 0, 0, 255)
                DrawRect(0.0, i, 2.0, camHeight, 0, 0, 0, 255)
            end

            hideHUDComponents()

            Wait(0)
        end
    end, false)
end)