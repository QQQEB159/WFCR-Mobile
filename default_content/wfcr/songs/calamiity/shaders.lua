function onCreatePost()
    initShader("gray", "GreyscaleEffect")
    setCameraShader("game", "gray")
    setCameraShader("hud", "gray")
    setShaderProperty("gray", "strength", 0)

    initShader("bloom", "BloomEffect")
    setCameraShader("game", "bloom")
    setCameraShader("hud", "bloom")
    setShaderProperty("bloom", "effect", 0)
    setShaderProperty("bloom", "strength", 0)
    setShaderProperty("bloom", "contrast", 1)
    setShaderProperty("bloom", "brightness", 0)

    initShader("mosaic", "MosaicEffect")
    setCameraShader("game", "mosaic")
    setCameraShader("hud", "mosaic")
    setShaderProperty("mosaic", "strength", 0)

    initShader("mirror", "MirrorRepeatEffect")
    setCameraShader("game", "mirror")
    setShaderProperty("mirror", "angle", 0)
    setShaderProperty("mirror", "x", 0)
    setShaderProperty("mirror", "y", 0)
    setShaderProperty("mirror", "zoom", 1)

    initShader("bars", "BlackBars")
    setCameraShader("game", "bars")
    setShaderProperty("bars", "size", 0)

    initShader("barrel", "BarrelBlurEffect")
    setCameraShader("game", "barrel")
    setShaderProperty("barrel", "angle", 0)
    setShaderProperty("barrel", "x", 0)
    setShaderProperty("barrel", "y", 0)
    setShaderProperty("barrel", "zoom", 1)
    setShaderProperty("barrel", "iTime", 0)
    setShaderProperty("barrel", "barrel", 0)
    setShaderProperty("barrel", "doChroma", true)

    initShader("fisheye", "EyeFishEffect")
    setCameraShader("game", "fisheye")
    setShaderProperty("fisheye", "power", 0)

    initShader("blur", "BlurEffect")
    setCameraShader("game", "blur")
    setCameraShader("hud", "blur")
    setShaderProperty("blur", "strength", 0)
    setShaderProperty("blur", "strengthY", 0)
end

local iTime = 0.0
function onUpdate(elapsed)
    iTime = iTime + elapsed
    setShaderProperty("barrel", "iTime", iTime)
end

function onEvent(name, value1, value2)
    if string.lower(name) == "greyscale" then
        tweenShaderProperty("gray", "strength", value1, value2)
    end

    if string.lower(name) == "bloomlow" then
        setShaderProperty("bloom", "effect", 0.18)
        setShaderProperty("bloom", "strength", 1)
        tweenShaderProperty("bloom", "strength", 0, value1)
        tweenShaderProperty("bloom", "effect", 0, value1)
    end

    if string.lower(name) == "bloomhigh" then
        setShaderProperty("bloom", "effect",  0.8)
        setShaderProperty("bloom", "strength", 1.6)
        tweenShaderProperty("bloom", "strength", 0, value1)
        tweenShaderProperty("bloom", "effect", 0, value1)
    end

    if string.lower(name) == "mirrorzoom" then
        tweenShaderProperty("mirror", "zoom", value1, value2, 'cubeOut')
    end

    if string.lower(name) == "mirrorbeat" then
        setShaderProperty("mirror", "zoom", 0.8)
        tweenShaderProperty("mirror", "zoom", 1, 0.6, 'cubeOut')
    end

    if string.lower(name) == "pincushevent" then
        if value1 == '0' then
            tweenShaderProperty("fisheye", "power", value1, time, 'cubeIn')
        elseif value1 == 'in' then
            tweenShaderProperty("fisheye", "power", 0.3, time, 'cubeIn')
        else
            tweenShaderProperty("fisheye", "power", value1, time, 'cubeOut')
        end
    end

    if string.lower(name) == "mirrorscreenmovexbackin" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		move = tonumber(value1) --converts Zoom to number
        curMovePos = getShaderPropertyFloat("mirror", "x")
        if move == 0 then
            tweenShaderProperty("mirror", "x", 0, time, "QuartIn")
        else
            tweenShaderProperty("mirror", "x", curMovePos + move, time, "QuartIn")
        end
    end

    if string.lower(name) == "mirroranglebackin" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		move = tonumber(value1) --converts Zoom to number
        curMovePos = getShaderPropertyFloat("mirror", "angle")
        if move > 0 then
            tweenShaderProperty("mirror", "angle", move - 25, time, "cubeIn", 0, function ()
                tweenShaderProperty("mirror", "angle", move, time, "cubeOut")
            end)
        else
            tweenShaderProperty("mirror", "angle", move + 25, time, "cubeIn", 0, function ()
                tweenShaderProperty("mirror", "angle", move, time, "cubeOut")
            end)
        end
    end

    if string.lower(name) == "barrelblur" then
        tweenShaderProperty("barrel", "barrel", value1, value2, 'cubeOut')
    end

    if string.lower(name) == "bblurbeat" then
        setShaderProperty("barrel", "barrel", tonumber(value1))
        tweenShaderProperty("barrel", "barrel", 0, 0.4, 'cubeOut')
        cameraShake('camGame', 0.005, 0.15)
    end

    
    if string.lower(name) == "blackbarsout" then
        tweenShaderProperty("bars", "size", value1, value2, 'expoOut')
    end

    if string.lower(name) == "blackbarsin" then
        tweenShaderProperty("bars", "size", value1, value2, 'expoIn')
    end



    if string.lower(name) == "blurbeat" then
        setShaderProperty("blur", "strength", 4.5)
        setShaderProperty("blur", "strengthY", 4.5)
        tweenShaderProperty("blur", "strength", 0, 0.4, 'cubeOut')
        tweenShaderProperty("blur", "strengthY", 0, 0.4, 'cubeOut')

        setShaderProperty("barrel", "zoom", 0.85)
        tweenShaderProperty("barrel", "zoom", 1, 0.4, 'cubeOut')

        setShaderProperty("mirror", "zoom", 0.6)
        tweenShaderProperty("mirror", "zoom", 1, 0.5, 'cubeOut')
    end

    if string.lower(name) == "blureffect" then
        tweenShaderProperty("blur", "strength", value1, value2, 'cubeOut')
        tweenShaderProperty("blur", "strengthY", value1, value2, 'cubeOut')
    end

    if string.lower(name) == "mirror-bumpxy" then
        if value1 == 'r' then
            setShaderProperty('mirror', 'x', 0.5)
            tweenShaderProperty("mirror", "x", 0, stepCrochet * 0.001 * 4, 'backOut')
        elseif value1 == 'l' then
            setShaderProperty('mirror', 'x', -0.5)
            tweenShaderProperty("mirror", "x", 0, stepCrochet * 0.001 * 4, 'backOut')
        elseif value1 == 'up' then
            setShaderProperty('mirror', 'y', -0.5)
            tweenShaderProperty("mirror", "y", 0, stepCrochet * 0.001 * 4, 'backOut')
        elseif value1 == 'd' then
            setShaderProperty('mirror', 'y', 0.5)
            tweenShaderProperty("mirror", "y", 0, stepCrochet * 0.001 * 4, 'backOut')
        end
    end

    if string.lower(name) == "mosaiceffect" then 
        tweenShaderProperty("mosaic", "strength", value1, value2, 'cubeOut')
    end
end