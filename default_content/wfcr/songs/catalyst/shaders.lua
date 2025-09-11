function onCreatePost()
    initShader("gray", "GreyscaleEffect")


    setCameraShader("game", "gray")


    setCameraShader("hud", "gray")


    setShaderProperty("gray", "strength", 0)





    initShader("ca", "ChromAbEffect")


    setCameraShader("game", "ca")


    setCameraShader("hud", "ca")


    setShaderProperty("ca", "strength", 0)





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





    initShader("colorOverride", "ColorOverrideEffect")


    setCameraShader("game", "colorOverride")


    setShaderProperty("colorOverride", "red", 0)


    setShaderProperty("colorOverride", "green", 0)


    setShaderProperty("colorOverride", "blue", 0)





    initShader("mirror", "MirrorRepeatEffect")


    setCameraShader("game", "mirror")


    setShaderProperty("mirror", "angle", 0)


    setShaderProperty("mirror", "x", 0)


    setShaderProperty("mirror", "y", 0)


    setShaderProperty("mirror", "zoom", 1)





    initShader("barrel", "BarrelBlurEffect")


    setCameraShader("game", "barrel")


    setShaderProperty("barrel", "angle", 0)


    setShaderProperty("barrel", "x", 0)


    setShaderProperty("barrel", "y", 0)


    setShaderProperty("barrel", "zoom", 1)


    setShaderProperty("barrel", "iTime", 0)


    setShaderProperty("barrel", "barrel", 0)


    setShaderProperty("barrel", "doChroma", true)





    initShader("sobel", "SobelEffect")


    setCameraShader("game", "sobel")


    setShaderProperty("sobel", "strength", 0)


    setShaderProperty("sobel", "intensity", 0)





    initShader("blur", "BlurEffect")


    setCameraShader("game", "blur")


    setShaderProperty("blur", "strength", 0)


    setShaderProperty("blur", "strengthY", 0)





    initShader("vignette", "VignetteEffect")


    setShaderProperty("vignette", "strength", 0)


    setShaderProperty("vignette", "size", 0)


    setShaderProperty("vignette", "red", 0)


    setShaderProperty("vignette", "green", 0)


    setShaderProperty("vignette", "blue", 0)
end

local iTime = 0.0


local perlinX = 0.0


local perlinY = 0.0


local perlinZ = 0.0


local perlinSpeed = 1


local perlinXRange = 0


local perlinYRange = 0


local perlinZRange = 0


function onUpdate(elapsed)
    iTime = iTime + elapsed


    perlinX = perlinX + elapsed * math.random() * perlinSpeed


    perlinY = perlinY + elapsed * math.random() * perlinSpeed


    perlinZ = perlinZ + elapsed * math.random() * perlinSpeed


    setShaderProperty("barrel", "iTime", iTime)


    setShaderProperty("barrel", "x", (((math.cos(perlinX) * perlinXRange)) / 2.0))


    setShaderProperty("barrel", "y", (((math.sin(perlinY) * perlinYRange)) / 2.0))


    setShaderProperty("barrel", "angle", (((math.cos(perlinZ) * perlinZRange)) / 2.0))
end

function onEvent(name, value1, value2)
    if value2 == "" then
        value2 = 1
    end


    if string.lower(name) == "bloomlow" then
        setShaderProperty("bloom", "effect", 0.18)


        setShaderProperty("bloom", "strength", 1)


        tweenShaderProperty("bloom", "strength", 0, stepCrochet * 0.001 * value1)


        tweenShaderProperty("bloom", "effect", 0, stepCrochet * 0.001 * value1)
    elseif string.lower(name) == "greyscale" then
        tweenShaderProperty("gray", "strength", value1, value2)
    elseif string.lower(name) == "bloomlow" then
        setShaderProperty("bloom", "effect", 0.18)


        setShaderProperty("bloom", "strength", 1)


        tweenShaderProperty("bloom", "strength", 0, value1)


        tweenShaderProperty("bloom", "effect", 0, value1)
    elseif string.lower(name) == "mirrorzoom" then
        tweenShaderProperty("mirror", "zoom", value1, stepCrochet * 0.001 * value2, 'cubeOut')
    elseif string.lower(name) == "mirrorzoomin" then
        tweenShaderProperty("mirror", "zoom", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')
    elseif string.lower(name) == "mirrorscreenmovexin" then
        tweenShaderProperty("mirror", "x", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')
    elseif string.lower(name) == "mirrorscreenmoveyin" then
        tweenShaderProperty("mirror", "y", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')
    elseif string.lower(name) == "mirrorscreenmovexbump" then
        setShaderProperty("mirror", "x", tonumber(value1))


        tweenShaderProperty("mirror", "x", 0, stepCrochet * 0.001 * tonumber(value2), 'cubeOut')
    elseif string.lower(name) == "mirrorangle" then
        setShaderProperty("mirror", "angle", tonumber(value1))


        tweenShaderProperty("mirror", "angle", 0, stepCrochet * 0.001 * value2, 'cubeOut')
    elseif string.lower(name) == "mirrorangleout" then
        tweenShaderProperty("mirror", "angle", value1, stepCrochet * 0.001 * value2, 'cubeOut')
    elseif string.lower(name) == "mirroranglein" then
        tweenShaderProperty("mirror", "angle", value1, stepCrochet * 0.001 * value2, 'cubeIn')
    elseif string.lower(name) == "mirrorbeat" then
        setShaderProperty("mirror", "zoom", 0.8)


        tweenShaderProperty("mirror", "zoom", 1, 0.6, 'cubeOut')
    elseif string.lower(name) == "mirrorzoombump" then
        setShaderProperty("mirror", "zoom", tonumber(value1))


        tweenShaderProperty("mirror", "zoom", 1, stepCrochet * 0.001 * tonumber(value2), 'cubeOut')
    elseif string.lower(name) == "mirrorscreenmovexbackin" then
        steps = tonumber(value2);


        time = stepCrochet * 0.001 * steps --converts Duration to number


        move = tonumber(value1) --converts Zoom to number


        curMovePos = getShaderPropertyFloat("mirror", "x")


        if move == 0 then
            tweenShaderProperty("mirror", "x", 0, time, "QuartIn")
        else
            tweenShaderProperty("mirror", "x", curMovePos + move, time, "QuartIn")
        end
    elseif string.lower(name) == "mirrorscreenmovex" then
        tweenShaderProperty("mirror", "x", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeOut')
    elseif string.lower(name) == "barrelblur" then
        setShaderProperty("barrel", "barrel", tonumber(value1))


        tweenShaderProperty("barrel", "barrel", 0, stepCrochet * 0.001 * value2, 'cubeIn')
    elseif string.lower(name) == "barrelblurin" then
        tweenShaderProperty("barrel", "barrel", tonumber(value1), stepCrochet * 0.001 * value2, 'cubeOut')
    elseif string.lower(name) == "bblurbeat" then
        setShaderProperty("barrel", "barrel", tonumber(value1))


        tweenShaderProperty("barrel", "barrel", 0, 0.4, 'cubeOut')


        cameraShake('camGame', 0.005, 0.15)
    elseif string.lower(name) == "blurbeatnozoom" then
        setShaderProperty("blur", "strength", 4.5)


        setShaderProperty("blur", "strengthY", 4.5)


        tweenShaderProperty("blur", "strength", 0, 0.4, 'cubeOut')


        tweenShaderProperty("blur", "strengthY", 0, 0.4, 'cubeOut')
    elseif string.lower(name) == "blureffect" then
        tweenShaderProperty("blur", "strength", value1, stepCrochet * 0.001 * value2)


        tweenShaderProperty("blur", "strengthY", value1, stepCrochet * 0.001 * value2)
    elseif string.lower(name) == "chrombeat" then
        setShaderProperty("ca", "strength", 0.012)


        tweenShaderProperty("ca", "strength", 0, 0.5, 'cubeOut')
    elseif string.lower(name) == "mosaiceffect" then
        tweenShaderProperty("mosaic", "strength", value1, value2, 'cubeOut')
    elseif string.lower(name) == "fadescreeninbump" then
        setShaderProperty("colorOverride", "red", 0)


        setShaderProperty("colorOverride", "green", 0)


        setShaderProperty("colorOverride", "blue", 0)


        tweenShaderProperty("colorOverride", "red", 1, stepCrochet * 0.001 * value1)


        tweenShaderProperty("colorOverride", "green", 1, stepCrochet * 0.001 * value1)


        tweenShaderProperty("colorOverride", "blue", 1, stepCrochet * 0.001 * value1)
    elseif string.lower(name) == "vignette" then
        tweenShaderProperty("vignette", "strength", value1, stepCrochet * 0.001 * value2)


        tweenShaderProperty("vignette", "size", value1, stepCrochet * 0.001 * value2)
    elseif string.lower(name) == 'perlinrandommove' then
        if value1 == 'hard-slow' then
            perlinSpeed = 8


            perlinXRange = 0.085


            perlinYRange = 0.085


            perlinZRange = 7
        end





        if value1 == 'hard-fast' then
            perlinSpeed = 14


            perlinXRange = 0.085


            perlinYRange = 0.085


            perlinZRange = 7
        end





        if value1 == 'medium' then
            perlinSpeed = 7


            perlinXRange = 0.045


            perlinYRange = 0.045


            perlinZRange = 5
        end





        if value1 == 'easy' then
            perlinSpeed = 6


            perlinXRange = 0.025


            perlinYRange = 0.025


            perlinZRange = 4
        end





        if value1 == 'off' then
            perlinSpeed = 0


            perlinXRange = 0


            perlinYRange = 0


            perlinZRange = 0
        end
    elseif string.lower(name) == "sobelflash" then
        setShaderProperty("sobel", "strength", 0.9)


        setShaderProperty("sobel", "intensity", 2)


        tweenShaderProperty("sobel", "strength", 0, stepCrochet * 0.001 * tonumber(value1), 'cubeOut')


        tweenShaderProperty("sobel", "intensity", 0, stepCrochet * 0.001 * tonumber(value1), 'cubeOut')
    end
end
