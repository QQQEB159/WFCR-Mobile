package funkin.states;

import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class FlashingLights extends MusicBeatState {
    	public static var leftState:Bool = false;

	var warnText:FlxText;
	var timeLeftText:FlxText;
	var timeLeft:Int = 5;

	override function create()
	{
		super.create();

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights and shaders\n
			Head to the options to turn them off!\n
			You've been warned!",
			32);
		warnText.setFormat(Paths.font("droidbold.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		warnText.color = FlxColor.RED;
		add(warnText);

		timeLeftText = new FlxText(0, 600, FlxG.width,);
		timeLeftText.setFormat(Paths.font("droidbold.ttf"), 32, FlxColor.WHITE, CENTER);
		timeLeftText.color = FlxColor.RED;
		add(timeLeftText);
		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				timeLeft--;
			}, 5);
	}

	override function update(elapsed:Float)
	{
		if(timeLeft == 0){
			timeLeftText.text = "Continue...";
			FlxTween.color(warnText, 0.25, warnText.color, 0xFFFFFFFF);
			FlxTween.color(timeLeftText, 0.25, timeLeftText.color, 0xFFFFFFFF);
		}
		else
			timeLeftText.text = Std.string(timeLeft);
		if(!leftState) {
			var back:Bool = controls.BACK;
			if ((controls.ACCEPT || back) && timeLeftText.text == "Continue..." ) {
				leftState = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
                            Progress.setData(true, "seenWarning");
							FlxG.switchState(() -> new TitleState());
						}
					});
					FlxTween.tween(timeLeftText, {alpha: 0}, 1);
			}
		}
		super.update(elapsed);
	}
}