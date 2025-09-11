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
    setShaderProperty("barrel", "barrel", 0)
    setShaderProperty("barrel", "doChroma", true)

    initShader("colorOverride", "ColorOverrideEffect")
    setCameraShader("game", "colorOverride")
    setShaderProperty("colorOverride", "red", 0)
    setShaderProperty("colorOverride", "green", 0)
    setShaderProperty("colorOverride", "blue", 0)
end

function onEvent(name, value1, value2)
    name = string.lower(name)
    if value1 == "" then
        value1 = 1
    end
    if value2 == "" then
        value2 = 1
    end
    if name == "bloomlow" then
        setShaderProperty("bloom", "effect", 0.18)
        setShaderProperty("bloom", "strength", 1.0)
        tweenShaderProperty("bloom", "strength", 0, stepCrochet * 0.001 * tonumber(value1))
        tweenShaderProperty("bloom", "effect", 0, stepCrochet * 0.001 * tonumber(value1))
    elseif name == "greyscale" then
        tweenShaderProperty("gray", "strength", value1, value2)

    elseif name == "mirrorzoom" then
        tweenShaderProperty("mirror", "zoom", value1, stepCrochet * 0.001 * value2, 'cubeOut')

    elseif name == "mirrorzoomin" then
        tweenShaderProperty("mirror", "zoom", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')
    
    elseif name == "mirrorscreenmovexin" then
        tweenShaderProperty("mirror", "x", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')

    elseif name == "mirrorscreenmoveyin" then
        tweenShaderProperty("mirror", "y", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')

    elseif name == "mirrorscreenmoveybackin" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		move = tonumber(value1) --converts Zoom to number
        curMovePos = getShaderPropertyFloat("mirror", "y")
        if move == 0 then
            tweenShaderProperty("mirror", "y", 0, time, "QuartIn")
        else
            tweenShaderProperty("mirror", "y", curMovePos + move, time, "QuartIn")
        end
    
    elseif name == "mirroranglebackin" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps
		angle = tonumber(value1) --converts Zoom to number

		--tweenstuffs
		varNum = getShaderPropertyFloat('mirror', 'angle')
		if varNum > 0 then
			tweenShaderProperty('mirror', 'angle', angle - 25, time, 'cubeIn', 0, function() 
                tweenShaderProperty('mirror', 'angle', angle, time, 'cubeIn')
            end)
		else
            tweenShaderProperty('mirror', 'angle', angle + 25, time, 'cubeIn', 0, function() 
                tweenShaderProperty('mirror', 'angle', angle, time, 'cubeIn')
            end)
		end
    elseif name == "mirrorscreenmovexbump" then
        setShaderProperty("mirror", "x", tonumber(value1))
        tweenShaderProperty("mirror", "x", 0, stepCrochet * 0.001 * tonumber(value2), 'cubeOut')

    elseif name == "mirrorangle" then
        setShaderProperty("mirror", "angle", tonumber(value1))
        tweenShaderProperty("mirror", "angle", 0, stepCrochet * 0.001 * value2, 'cubeOut')
        
    elseif name == "mirrorangleout" then
        tweenShaderProperty("mirror", "angle", value1, stepCrochet * 0.001 * value2, 'cubeOut')

    elseif name == "mirroranglein" then
        tweenShaderProperty("mirror", "angle", value1, stepCrochet * 0.001 * value2, 'cubeIn')

    elseif name == "mirrorbeat" then
        setShaderProperty("mirror", "zoom", 0.8)
        tweenShaderProperty("mirror", "zoom", 1, 0.6, 'cubeOut')

    elseif name == "mirrorzoombump" then
        setShaderProperty("mirror", "zoom", tonumber(value1))
        tweenShaderProperty("mirror", "zoom", 1, stepCrochet * 0.001 * tonumber(value2), 'cubeOut')

    elseif name == "mirrorscreenmovexbackin" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		move = tonumber(value1) --converts Zoom to number
        curMovePos = getShaderPropertyFloat("mirror", "x")
        if move == 0 then
            tweenShaderProperty("mirror", "x", 0, time, "QuartIn")
        else
            tweenShaderProperty("mirror", "x", curMovePos + move, time, "QuartIn")
        end
    
    elseif name == "mirrorscreenmovex" then
        tweenShaderProperty("mirror", "x", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeOut')

    elseif name == "barrelblur" then
        setShaderProperty("barrel", "barrel", tonumber(value1))
        tweenShaderProperty("barrel", "barrel", 0, stepCrochet * 0.001 * value2, 'cubeIn')

    elseif name == "barrelblurin" then
        tweenShaderProperty("barrel", "barrel", tonumber(value1), stepCrochet * 0.001 * value2, 'cubeOut')

    elseif name == "bblurbeat" then
        setShaderProperty("barrel", "barrel", tonumber(value1))
        tweenShaderProperty("barrel", "barrel", 0, 0.4, 'cubeOut')
        cameraShake('camGame', 0.005, 0.15)

    elseif name == "blurbeat" then
        setShaderProperty("blur", "strength", 4.5)
        setShaderProperty("blur", "strengthY", 4.5)
        tweenShaderProperty("blur", "strength", 0, 0.4, 'cubeOut')
        tweenShaderProperty("blur", "strengthY", 0, 0.4, 'cubeOut')

        setShaderProperty("mirror", "zoom", 0.65)
        tweenShaderProperty("mirror", "zoom", 1, stepCrochet * 0.001 * 4, 'cubeOut')

    elseif name == "blureffect" then
        tweenShaderProperty("blur", "strength", value1, stepCrochet * 0.001 * value2)
        tweenShaderProperty("blur", "strengthY", value1, stepCrochet * 0.001 * value2)
    elseif name == "chrombeat" then
        setShaderProperty("ca", "strength", 0.012)
        tweenShaderProperty("ca", "strength", 0, 0.5, 'cubeOut')
    elseif name == "mosaiceffect" then 
        tweenShaderProperty("mosaic", "strength", value1, value2, 'cubeOut')
    elseif name == "fadescreenin" then
        tweenShaderProperty("colorOverride", "red", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "green", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "blue", 1, stepCrochet * 0.001 * value1, value2)
    elseif name == "fadescreenin" then
        tweenShaderProperty("colorOverride", "red", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "green", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "blue", 1, stepCrochet * 0.001 * value1, value2)
    elseif name == "fadescreenout" then
        tweenShaderProperty("colorOverride", "red", 0, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "green", 0, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "blue", 0, stepCrochet * 0.001 * value1, value2)
    elseif name == "fadescreeninbump" then
        setShaderProperty("colorOverride", "red", 0)
        setShaderProperty("colorOverride", "green", 0)
        setShaderProperty("colorOverride", "blue", 0)
        tweenShaderProperty("colorOverride", "red", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "green", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "blue", 1, stepCrochet * 0.001 * value1, value2)
    elseif name == "mosaiceffectbump" then
        setShaderProperty("mosaic", "strength", value1)
        tweenShaderProperty("mosaic", "strength", 0, stepCrochet * 0.001 * value2, 'linear')
    elseif name == "chromabeffect" then 
        setShaderProperty("ca", "strength", 0.006)
        tweenShaderProperty("ca", "strength", 0, stepCrochet * 0.001 * 4, 'cubeOut')
    else
        --print(name)
    end
end