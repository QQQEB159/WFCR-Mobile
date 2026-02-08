package;

import haxe.CallStack;
import hxopus.Opus;
import lime.graphics.Image;
import openfl.Lib;
import flixel.FlxSprite;
import lime.system.CFFI;
import openfl.utils.Assets;
import haxe.Log;
import haxe.PosInfos;
import flixel.FlxG;
import flixel.FlxState;
import funkin.objects.hud.StatsDisplay;
import openfl.display.Sprite;
import lime.app.Application;
import openfl.display.Bitmap;
import funkin.*;
import funkin.api.Github;
import funkin.macros.Sowy;
import funkin.data.SemanticVersion;
import funkin.objects.Bread;
import openfl.utils._internal.Log as OpenFLLog;

#if sys
import sys.FileSystem;
import sys.io.Process;
import haxe.io.BytesOutput;
#end

#if mobile
import mobile.CopyState;
#end

using StringTools;

final class Version
{
	public static final engineVersion:String = '1.1.1'; // Used for autoupdating n stuff
	public static final betaVersion:String = '0'; // beta version, set it to 0 if not on a beta version, otherwise do it based on semantic versioning (alpha.1, beta.1, rc.1, etc)
	public static final isBeta:Bool = betaVersion != '0';

	public static final buildCode:String = Sowy.getBuildDate();
	public static final githubRepo:RepoInfo = Github.getCompiledRepoInfo();
	
	public static final semanticVersion:SemanticVersion = isBeta ? '$engineVersion-$betaVersion' : engineVersion;
	public static final displayedVersion:String = 'v$semanticVersion';
}

@:cppFileCode('
	#include <iostream>
	#if HX_WINDOWS
	#include <windows.h>
	#include <dwmapi.h>

	#pragma comment(lib, "Dwmapi")
	#endif
')
class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var adjustGameSize:Bool = true; // If true, the game size is adjusted to fit within the screen resolution
	var initialState:Class<FlxState> = StartupState; // The FlxState the game starts with.
	var nextState:Class<FlxState> = funkin.states.TitleState; 
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Null<Bool> = null; // Whether to start the game in fullscreen on desktop targets

	public static final UserAgent:String = 'WFCR/${Version.engineVersion}'; // used for http requests. if you end up forking the engine and making your own then make sure to change this!!
	
	//// You can pretty much ignore everything from here on - your code should go in your states.

	public static var showDebugTraces:Bool = #if (debug || SHOW_DEBUG_TRACES) true #else false #end;
	public static var downloadBetas:Bool = Version.isBeta;
	public static var outOfDate:Bool = false;
	public static var recentRelease:Release;

	////
	public static var fpsVar:StatsDisplay;
	public static var bread:Bread;

	#if ALLOW_DEPRECATION
	@:noCompletion @:deprecated("volumeChangedEvent is deprecated, use FlxG.sound.onVolumeChange, instead") 
	public static var volumeChangedEvent(get, never):flixel.util.FlxSignal.FlxTypedSignal<Float -> Void>;
	@:noCompletion inline static function get_volumeChangedEvent() return FlxG.sound.onVolumeChange;
	#end

	public static function main():Void
	{
		Lib.current.addChild(new Main());
		#if cpp
		cpp.NativeGc.enable(true);
		#elseif hl
		hl.Gc.enable(true);
		#end
	}
	
	////
	public function new() {
		Log.trace = (v:Dynamic, ?infos:PosInfos) -> untyped __cpp__("std::cout << {0}", '${Log.formatOutput(v, infos)}\n');
		OpenFLLog.throwErrors = false;
		
		#if windows
		var title:String = FlxG.stage.window.title;
		untyped __cpp__('
			int darkMode = 1;
			HWND window = FindWindowA(NULL, {0}.c_str());
			if (window == NULL) window = FindWindowExA(GetActiveWindow(), NULL, NULL, {0}.c_str());
			if (window != NULL && S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) {
				DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
			}
		', title);
		#end
		#if html5
		untyped __js__("sadfkjhasdfjklhasdf");
		#end

		#if mobile
		#if android
		StorageUtil.requestPermissions();
		#end
		Sys.setCwd(StorageUtil.getStorageDirectory());
		#end

		CrashHandler.init();
		
		super();

		////
		#if sys
		var args = Sys.args();
		trace(args);
		for (arg in args) {
			switch(arg) {
				case "traceSowy":
					trace("sowy");

				case "troll":
					#if tgt
					initialState = funkin.tgt.SinnerState;
					#end

				case "songselect":
					nextState = funkin.states.SongSelectState;

				case "debug":
					funkin.states.PlayState.chartingMode = true;
					Main.showDebugTraces = true;

				case "showdebugtraces":
					Main.showDebugTraces = true;
			}
		}
		#end

		#if sys
		if (FileSystem.exists("gameSize.txt")) {
			adjustGameSize = false;
			var d = sys.io.File.getContent("gameSize.txt").split(" ");
			gameWidth = Std.parseInt(d[0]);
			gameHeight = Std.parseInt(d[1]);
		}
		#end

		#if desktop
		final screenWidth = Application.current.window.width;
		final screenHeight = Application.current.window.height;

		if (adjustGameSize) {
			//// Readjust the game size for smaller screens
			if (!(screenWidth > gameWidth || screenHeight > gameWidth)) {
				var ratioX:Float = screenWidth / gameWidth;
				var ratioY:Float = screenHeight / gameHeight;
				
				var zoom = Math.min(ratioX, ratioY);
				gameWidth = Math.ceil(screenWidth / zoom);
				gameHeight = Math.ceil(screenHeight / zoom);
			}
		}

		//// Adjust window size for larger screens
		var scaleModifier:Int = Math.floor((screenWidth > screenHeight) ? (screenHeight / gameHeight) : (screenWidth / gameWidth));
		if (scaleModifier < 1) scaleModifier = 1;

		resizeWindow(gameWidth * scaleModifier, gameHeight * scaleModifier);
		centerWindow();
		#end

		////		
		StartupState.nextState = nextState;

		var game = new FNFGame(gameWidth, gameHeight, #if (mobile && MODS_ALLOWED) !CopyState.checkExistingFiles() ? CopyState : #end initialState, framerate, framerate, skipSplash, startFullscreen);
		addChild(game);

		FlxG.sound.volume = FlxG.save.data.volume;
		FlxG.mouse.load(Paths.image("pointer").bitmap);
		FlxG.mouse.visible = true;

		fpsVar = new StatsDisplay(10, 3);
		fpsVar.visible = false;
		addChild(fpsVar);

		#if BREAD_ALLOWED
		bread = new Bread();
		bread.visible = false;
		addChild(bread);
		#end

		#if linux
		Lib.current.stage.window.setIcon(Image.fromFile("icon.png"));
		#end
		
		#if mobile
		lime.system.System.allowScreenTimeout = ClientPrefs.screensaver;
		#if android
		FlxG.android.preventDefaultKeys = [BACK]; 
		#end
		#end
	}

	public static function getTime():Float {
		#if flash
		return flash.Lib.getTimer();
		#elseif ((js && !nodejs) || electron)
		return js.Browser.window.performance.now();
		#elseif sys
		return Sys.time() * 1000;
		#elseif (lime_cffi && !macro)
		@:privateAccess
		return cast lime._internal.backend.native.NativeCFFI.lime_system_get_timer();
		#elseif cpp
		return untyped __global__.__time_stamp() * 1000;
		#else
		return 0;
		#end
	}

	public static function resizeWindow(width:Int, height:Int)
		Application.current.window.resize(width, height);

	public static function centerWindow() {
		Application.current.window.move(
			Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2),
			Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2)
		);
	}

	public static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	public static function callstackToString(callstack:Array<StackItem>):String {
		var str:String = "";
		for (stackItem in callstack) {
			switch (stackItem) {
				case FilePos(s, file, line, column):
					str += '$file:$line\n';
				default:
			}
		}
		return str;
	}

	#if sys
	// https://github.com/openfl/hxp/blob/master/src/hxp/System.hx
	public static function runProcess(command:String, ?args:Array<String>):Null<String> {
		var process = new Process(command, args);
		var buffer = new BytesOutput();
		var waiting = true;

		while (waiting) {
			try {
				var current = process.stdout.readAll(1024);
				buffer.write(current);

				if (current.length == 0)
					waiting = false;
			} catch (e) {
				waiting = false;
			}
		}

		var result = process.exitCode();
		var output = buffer.getBytes().toString();
		var retVal:Null<String> = output;

		if (output == "") {
			var error = process.stderr.readAll().toString();
			process.close();

			if (result != 0 || error != "")
				retVal = null;
		} else {
			process.close();
		}
		
		return retVal;
	}
	#end
}
