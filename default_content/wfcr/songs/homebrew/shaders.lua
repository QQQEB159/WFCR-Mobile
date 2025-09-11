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

    setCameraShaderBlurEffect("game")
    setCameraShaderBlurEffect("hud")
    setBlurEffectProperty("game", "blurX", 20)
    setBlurEffectProperty("game", "blurY", 20)
    setBlurEffectProperty("hud", "blurX", 20)
    setBlurEffectProperty("hud", "blurY", 20)
end

function onEvent(name, value1, value2)
    if string.lower(name) == "greyscale" then
        tweenShaderProperty("gray", "strength", value1, value2)
    end

    if string.lower(name) == "bloommed" then
        setShaderProperty("bloom", "effect", 0.5)
        setShaderProperty("bloom", "strength", 1.3)
        tweenShaderProperty("bloom", "strength", 0, value1)
        tweenShaderProperty("bloom", "effect", 0, value1)
    end

    if string.lower(name) == "chrombeat" then
        setShaderProperty("ca", "strength", 0.012)
        tweenShaderProperty("ca", "strength", 0, 0.5, 'cubeOut')
    end

    if string.lower(name) == "blurevent" then 
        tweenBlurEffect("game", "blurX", value1, value2)
        tweenBlurEffect("hud", "blurX", value1, value2)
        tweenBlurEffect("game", "blurY", value1, value2)
        tweenBlurEffect("hud", "blurY", value1, value2)
    end
end