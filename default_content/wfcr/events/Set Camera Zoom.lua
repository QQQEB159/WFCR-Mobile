function onEvent(name, argument1, argument2, strumTime)
    if string.lower(name) == "set camera zoom" then
        local camZoom = tonumber(argument1)
        local hudZoom = tonumber(argument2)

        if camZoom == nil then
            camZoom = getProperty("defaultCamZoom")
        end

        if hudZoom == nil then
            hudZoom = getProperty("defaultHudCamZoom")
        end

        setProperty("defaultCamZoom", camZoom)
        setProperty("defaultHudCamZoom", hudZoom)

        if not getProperty("camZooming") then
            setProperty("camGame.zoom", camZoom)
            setProperty("camHUD.zoom", hudZoom)
        end
    end
end