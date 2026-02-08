package funkin;

import funkin.scripts.Globals;
import funkin.states.MusicBeatState;
import flixel.util.typeLimit.NextState;
import flixel.input.keyboard.FlxKey;
#if CRASH_HANDLER
import haxe.CallStack;
import openfl.events.UncaughtErrorEvent;
#if SAVE_CRASH_LOGS
import sys.io.File;
#end
#if sys
import lime.system.System;
#end
#if (windows && cpp)
import funkin.api.Windows;
#end
#end
#if SCRIPTABLE_STATES
import funkin.states.scripting.HScriptOverridenState;
#end

class FNFGame extends FlxGame {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	public static var fullscreenKeys:Array<FlxKey> = [FlxKey.F11];
	public static var specialKeysEnabled(default, set):Bool;

	@:noCompletion inline public static function set_specialKeysEnabled(val) {
		if (val) {
			FlxG.sound.muteKeys = muteKeys;
			FlxG.sound.volumeDownKeys = volumeDownKeys;
			FlxG.sound.volumeUpKeys = volumeUpKeys;
		} else {
			FlxG.sound.muteKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.volumeUpKeys = [];
		}

		return specialKeysEnabled = val;
	}

	public function new(gameWidth = 0, gameHeight = 0, ?initialState:InitialState, updateFramerate = 60, drawFramerate = 60, skipSplash = false,
			?startFullscreen:Bool) {
		@:privateAccess FlxG.initSave();
		startFullscreen = startFullscreen ?? FlxG.save.data.fullscreen;

		super(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen);
		_customSoundTray = flixel.system.ui.DefaultFlxSoundTray;

		FlxG.sound.volume = FlxG.save.data.volume;
		FlxG.mouse.visible = false;

		////
		FlxG.signals.gameResized.add((w, h) -> resetSpriteCache());
		FlxG.signals.focusGained.add(resetSpriteCache);

		////
		#if (windows || linux) // No idea if this also applies to any other targets
		FlxG.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (e) -> {
			// Prevent Flixel from listening to key inputs when switching fullscreen mode
			if (e.keyCode == FlxKey.ENTER && e.altKey)
				e.stopImmediatePropagation();

			// Also add F11 to switch fullscreen mode
			if (specialKeysEnabled && fullscreenKeys.contains(e.keyCode))
				FlxG.fullscreen = !FlxG.fullscreen;
		}, false, 100);

		FlxG.stage.addEventListener(openfl.events.FullScreenEvent.FULL_SCREEN, (e) -> FlxG.save.data.fullscreen = e.fullScreen);
		#end
	}

	override function update():Void {
		super.update();

		if (FlxG.keys.justPressed.F5)
			if (FlxG.keys.pressed.SHIFT)
				FlxG.switchState(new funkin.states.MainMenuState());
			else
				MusicBeatState.resetState();
	}

	override function switchState():Void {
		#if SCRIPTABLE_STATES
		if (_nextState is MusicBeatState) {
			var ogState:MusicBeatState = cast _nextState;
			var nuState = HScriptOverridenState.requestOverride(ogState);

			if (nuState != null) {
				ogState.destroy();
				_nextState = nuState;
			}
		}
		#end

		Globals.variables.clear();
		super.switchState();
	}

	// shader coords fix
	private function resetSpriteCache() {
		for (cam in FlxG.cameras.list) {
			if (cam != null && cam.filters != null)
				Main.resetSpriteCache(cam.flashSprite);
		}
		Main.resetSpriteCache(this);
	}
}
