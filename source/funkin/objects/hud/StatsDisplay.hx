package funkin.objects.hud;

import flixel.math.FlxMath;
import openfl.text.TextFormat;
import flixel.util.FlxStringUtil;
import lime.system.System;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.text.TextField;
import flixel.util.FlxColor;
import external.memory.Memory.*;
import flixel.util.FlxStringUtil.*;

class StatsDisplay extends TextField {
	private var _framesPassed:Int = 0;
	private var _previousTime:Float = 0;
	private var _updateClock:Float = 999999;

	public function new(x:Float = 0, y:Float = 0) {
		super();
		this.x = x;
		this.y = y;

		var textFormat:TextFormat = new TextFormat(null, 12, FlxColor.WHITE);

		width = FlxG.width;

		embedFonts = false;
		textFormat.font = "assets/fonts/droidbold.ttf";
		defaultTextFormat = textFormat;
		defaultTextFormat.color = FlxColor.WHITE;
		selectable = false;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	public function onEnterFrame(e:Event):Void {
		_framesPassed++;
		final deltaTime:Float = Math.max(System.getTimerPrecise() - _previousTime, 0);
		_updateClock += deltaTime;

		_previousTime = System.getTimerPrecise();
		if (_updateClock >= 1000) {
			text = "FPS: "
				+ Std.string((FlxG.drawFramerate > 0) ? FlxMath.minInt(_framesPassed, FlxG.drawFramerate) : _framesPassed)
				+ ' • Memory: ${formatBytes(getCurrentUsage())} / ${formatBytes(getPeakUsage())}';

			_framesPassed = 0;
			_updateClock = 0;
		}
		_previousTime = System.getTimerPrecise();
	}
}
