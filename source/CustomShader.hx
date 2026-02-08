package;

import funkin.ClientPrefs;
import openfl.filters.ShaderFilter;
import funkin.states.PlayState;
import flixel.addons.display.FlxRuntimeShader;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

/**
 * Basically just FlxRuntimeShader but it has tween support
 */
class CustomShader extends FlxRuntimeShader {
	/**
	 * Tweens a shader to a value
	 * @param property The property to tween
	 * @param to The value of the property to end up at
	 * @param duration How long it will take
	 * @param ease What ease should be used
	 * @param startDelay The delay to start
	 * @param onComplete When to do when the tween is done
	 */
	public function tween(property:String, to:Float, duration:Float = 1, ease:EaseFunction, ?startDelay:Float = 0.0, ?onComplete:Dynamic) {
		FlxTween.num(getFloat(property), to, duration, {
			ease: ease,
			onComplete: function(twn) {
				if (onComplete != null)
					onComplete();
			},
			startDelay: startDelay,
		}, (value) -> {
			setFloat(property, value);
		});
	}

	public static function initShader(id:String, file:String, ?glslVersion:Int = 100) {
		#if debug
		trace("found shader at: " + Paths.shaderFragment(file));
		#end
		var funnyCustomShader:CustomShader = new CustomShader(sys.io.File.getContent(#if mobile Sys.getCwd() + #end 'content/wfcr/shaders/${file}.frag'), null);
		PlayState.instance.modchartShaders.set(id, funnyCustomShader);
	}

	public static function setCameraShader(camera:String, id:String) {
		var cam = PlayState.instance.modchartCameras.get(camera);
		var funnyCustomShader:CustomShader = PlayState.instance.modchartShaders.get(id);
		if(cam == null){
			throw 'camera $camera is null!';
		}
		if(funnyCustomShader == null){
			throw 'shader $id is null!';
		}
		if (cam != null && funnyCustomShader != null) {
			if(filterShaders(id)){
				cam.shaders.push(new ShaderFilter(funnyCustomShader));
				cam.shaderNames.push(id);
				cam.cam.filters = cam.shaders;
			}
		}
	}
	// filters out shaders based on options
	private static function filterShaders(name:String):Bool{
		if(ClientPrefs.shaders == "None"){
			return false;
		}

		// probably a way to do this with a switch case but idk how that syntax works in this case
		for(n in ["color", "bloom"]){
			if(name.toLowerCase().contains(n) && !ClientPrefs.flashing){
				return false;
			}
		}
		for(n in  ["vhs", "glitch", "mirror", "barrel", "fish",]){
			if(name.toLowerCase().contains(n) && ClientPrefs.shaders != "All"){
				return false;
			}
		}
		return true;
	}

	public static function setShaderProperty(id:String, property:String, value:Dynamic) {
		var funnyCustomShader:CustomShader = PlayState.instance.modchartShaders.get(id);
		if(funnyCustomShader == null){
			throw 'shader $id does not exist!';
		}
		if (value is Float) {
			funnyCustomShader.setFloat(property, Std.parseFloat(value));
		} else if (value is Bool) {
			funnyCustomShader.setBool(property, value);
		} else if (value is Array) {
			if (value[0] is Float) {
				funnyCustomShader.setFloatArray(property, value);
			} else if (value[0] is Bool) {
				funnyCustomShader.setBoolArray(property, value);
			} else {
				funnyCustomShader.setIntArray(property, value);
			}
		} else {
			funnyCustomShader.setInt(property, Std.parseInt(value));
		}
	}
}
