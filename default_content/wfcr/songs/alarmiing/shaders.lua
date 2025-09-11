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

    initShader("mirror", "MirrorRepeatEffect")
    setCameraShader("game", "mirror")
    setShaderProperty("mirror", "angle", 0)
    setShaderProperty("mirror", "x", 0)
    setShaderProperty("mirror", "y", 0)
    setShaderProperty("mirror", "zoom", 1)



    initShader("blur", "BlurEffect")
    setCameraShader("game", "blur")
    setShaderProperty("blur", "strength", 0)
    setShaderProperty("blur", "strengthY", 0)

    
    initShader("fisheye", "fisheye")
    setCameraShader("game", "fisheye")
    setShaderProperty("fisheye", "power", 0)

    initShader("demonBlur", "demon_blur")
    setCameraShader("game", "demonBlur")
    setCameraShader("hud", "demonBlur")
    setShaderProperty("demonBlur", "u_size", 1)
    setShaderProperty("demonBlur", "u_alpha", 1.25)
    
    initShader("colorOverride", "ColorOverrideEffect")
    setCameraShader("game", "colorOverride")
    setShaderProperty("colorOverride", "red", 0)
    setShaderProperty("colorOverride", "green", 0)
    setShaderProperty("colorOverride", "blue", 0)
end

local iTime = 0.0
function onUpdate(elapsed)
    iTime = iTime + elapsed
end

function onEvent(name, value1, value2)
    if value1 == "" then
        value1 = 1
    end
    if value2 == "" then
        value2 = 1
    end
    if string.lower(name) == "bloomlow" then
        setShaderProperty("bloom", "effect", 0.18)
        setShaderProperty("bloom", "strength", 1)
        tweenShaderProperty("bloom", "strength", 0, stepCrochet * 0.001 * tonumber(value1))
        tweenShaderProperty("bloom", "effect", 0, stepCrochet * 0.001 * tonumber(value1))
    elseif string.lower(name) == "greyscale" then
        tweenShaderProperty("gray", "strength", value1, value2)
    elseif string.lower(name) == "bloomlow" then
        setShaderProperty("bloom", "effect", 0.18)
        setShaderProperty("bloom", "strength", 1)
        tweenShaderProperty("bloom", "strength", 0, value1)
        tweenShaderProperty("bloom", "effect", 0, value1)
    elseif string.lower(name) == "demonblur" then
        tweenShaderProperty("demonBlur", "u_alpha", value1, stepCrochet * 0.001 * value2)

    elseif string.lower(name) == "mirrorzoom" then
        tweenShaderProperty("mirror", "zoom", value1, stepCrochet * 0.001 * value2, 'cubeOut')

    elseif string.lower(name) == "mirrorzoomin" then
        tweenShaderProperty("mirror", "zoom", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')
    
    elseif string.lower(name) == "mirrorscreenmovexin" then
        tweenShaderProperty("mirror", "x", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')

    elseif string.lower(name) == "mirrorscreenmoveyin" then
        tweenShaderProperty("mirror", "y", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')

    elseif string.lower(name) == "mirrorscreenmoveybackin" then
        steps = tonumber(value2);
        time = stepCrochet * 0.001 * steps --converts Duration to number
		move = tonumber(value1) --converts Zoom to number
        curMovePos = getShaderPropertyFloat("mirror", "y")
        if move == 0 then
            tweenShaderProperty("mirror", "y", 0, time, "QuartIn")
        else
            tweenShaderProperty("mirror", "y", curMovePos + move, time, "QuartIn")
        end
    
    elseif string.lower(name) == "mirroranglebackin" then
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

    elseif string.lower(name) == "blurbeat" then
        setShaderProperty("blur", "strength", 4.5)
        setShaderProperty("blur", "strengthY", 4.5)
        tweenShaderProperty("blur", "strength", 0, 0.4, 'cubeOut')
        tweenShaderProperty("blur", "strengthY", 0, 0.4, 'cubeOut')

        setShaderProperty("mirror", "zoom", 0.65)
        tweenShaderProperty("mirror", "zoom", 1, stepCrochet * 0.001 * 4, 'cubeOut')

    elseif string.lower(name) == "blureffect" then
        tweenShaderProperty("blur", "strength", value1, stepCrochet * 0.001 * value2)
        tweenShaderProperty("blur", "strengthY", value1, stepCrochet * 0.001 * value2)
    elseif string.lower(name) == "chrombeat" then
        setShaderProperty("ca", "strength", 0.012)
        tweenShaderProperty("ca", "strength", 0, 0.5, 'cubeOut')
    elseif string.lower(name) == "mosaiceffect" then 
        tweenShaderProperty("mosaic", "strength", value1, value2, 'cubeOut')
    elseif string.lower(name) == "fadescreenin" then
        tweenShaderProperty("colorOverride", "red", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "green", 1, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "blue", 1, stepCrochet * 0.001 * value1, value2)
    elseif string.lower(name) == "fadescreenout" then
        tweenShaderProperty("colorOverride", "red", 0, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "green", 0, stepCrochet * 0.001 * value1, value2)
        tweenShaderProperty("colorOverride", "blue", 0, stepCrochet * 0.001 * value1, value2)
    elseif  string.lower(name) == "fisheye" then
        tweenShaderProperty("fisheye", "power", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeOut')
    elseif  string.lower(name) == "fisheyein" then
        tweenShaderProperty("fisheye", "power", tonumber(value1), stepCrochet * 0.001 * tonumber(value2), 'cubeIn')
    end
end