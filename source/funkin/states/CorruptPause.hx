package funkin.states;

import funkin.objects.hud.CommonHUD;
import flixel.math.FlxMath;
import funkin.states.options.OptionsSubstate;
import sys.io.File;
import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;

using StringTools;

class CorruptPause extends MusicBeatSubstate {
	var resume:FlxButton;

	var exit:PauseButton;
	var resetButton:PauseButton;
	

	var priiloader:FlxSound;

	inline function stopButtonPresses() {
		for (member in members) {
			if (member is FlxButton) {
				cast(member, FlxButton).status = DISABLED;
			}
		}
	}

    inline function startButtonPresses() {
		for (member in members) {
			if (member is FlxButton) {
				cast(member, FlxButton).status = NORMAL;
			}
		}
	}

	override public function destroy() {
		super.destroy();
		priiloader.destroy();
	}

	override function create() {
		super.create();
		priiloader = new FlxSound().loadEmbedded("assets/music/priiloader.ogg", true, true);
		priiloader.volume = 0;
		priiloader.play(false, FlxG.random.int(0, Std.int(priiloader.length * 0.5)));
		priiloader.fadeIn(50, 0, 0.5);
		FlxG.sound.list.add(priiloader);
		var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(black);
		black.alpha = 0;
		FlxTween.tween(black, {alpha: 0.3}, 0.5);
		exit = new PauseButton(0, 0, '', () -> {
			stopButtonPresses();
			var snd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/pause/wii_sfx_4.ogg").play();
			snd.onComplete = () -> {
				PlayState.validStoryRun = false;
				PlayState.gotoMenus();
			}
		});
		exit.loadGraphic("assets/images/pause/exit.png", true, 372, 129);
		exit.screenCenter(Y);
		exit.x = 132;
		exit.antialiasing = ClientPrefs.globalAntialiasing;
		exit.alpha = 0;
		add(exit);
		FlxTween.tween(exit, {alpha: 1}, 0.5);
		resetButton = new PauseButton(0, 0, '', () -> {
			stopButtonPresses();
			var snd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/pause/wii_sfx_4.ogg").play();
			snd.onComplete = () -> {
				if (FlxG.keys.pressed.SHIFT) {
					Paths.clearStoredMemory();
					Paths.clearUnusedMemory();
				}
				PlayState.instance.restartSong();
			}
		});
		resetButton.loadGraphic("assets/images/pause/reset.png", true, 372, 129);
		resetButton.screenCenter(Y);
		resetButton.x = 793;
		add(resetButton);
		resetButton.alpha = 0;
		resetButton.antialiasing = ClientPrefs.globalAntialiasing;
		FlxTween.tween(resetButton, {alpha: 1}, 0.5);
		resume = new FlxButton(0, -165, '', () -> {
			var game:PlayState = cast(FlxG.state, PlayState);
			var hud:CommonHUD = cast(game.hud, CommonHUD);
			hud.getHealthbar().alpha = 0;
			hud.iconP1.alpha = hud.iconP2.alpha = ClientPrefs.hpOpacity;
			stopButtonPresses();
			priiloader.fadeOut(1, 0);
			var snd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/pause/wii_sfx_4.ogg").play();
			snd.onComplete = () -> {
				if (ClientPrefs.countUnpause) {
					var gameCnt = PlayState.instance == null ? null : PlayState.instance.curCountdown;
					if (gameCnt != null && !gameCnt.finished) // don't make a new countdown if there's already one in progress lol
						return this.close();

					try{
						for (obj in members)
							obj.visible = false;
					}
					catch(e){
						
					}

					// menu.inputsActive = false;

					var c = new funkin.objects.Countdown(this); // https://tenor.com/view/letter-c-darwin-tawog-the-amazing-world-of-gumball-dance-gif-17949158
					c.onComplete = this.close;
					c.start(0.5);
				} else {
					this.close(); // close immediately
				}
			};
		});
		resume.loadGraphic("assets/images/pause/resume.png", true, 1280, 165);
		resume.screenCenter(X);
		resume.antialiasing = ClientPrefs.globalAntialiasing;
		add(resume);
		resume.alpha = 0;
		FlxTween.tween(resume, {y: 0, alpha: 1}, 0.5);
		var bottom:FlxButton = new FlxButton(0, FlxG.height, '', () -> {
			stopButtonPresses();
			var snd:FlxSound = new FlxSound().loadEmbedded("assets/sounds/pause/wii_sfx_4.ogg").play();
			snd.onComplete = () -> {
				this.persistentDraw = false;
				var daSubstate = new OptionsSubstate();
				daSubstate.goBack = function(changedOptions:Array<String>) {
					var canResume:Bool = true;

					for (opt in changedOptions) {
						if (OptionsSubstate.requiresRestart.exists(opt)) {
							canResume = false;
							break;
						}
					}

					PlayState.instance.optionsChanged(changedOptions);
					FlxG.mouse.visible = false;

					closeSubState();

                    startButtonPresses();
                    FlxG.mouse.load(Paths.image("pointer").bitmap);
                    FlxG.mouse.visible = true;

					for (camera in daSubstate.camerasToRemove)
						FlxG.cameras.remove(camera);
				};
				openSubState(daSubstate);
			};
		});
		bottom.loadGraphic("assets/images/pause/bottom.png", true, 1280, 165);
		bottom.screenCenter(X);
		bottom.antialiasing = ClientPrefs.globalAntialiasing;
		add(bottom);
		bottom.alpha = 0;
		FlxTween.tween(bottom, {y: FlxG.height - bottom.height, alpha: 1}, 0.5);
		FlxG.sound.play("assets/sounds/pause/wii_sfx_1.ogg");
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		FlxG.mouse.load(Paths.image("pointer").bitmap);
		FlxG.mouse.visible = true;
		var shader:CustomShader = new CustomShader(getShaderFrag('HSVEffect'));
		shader.setFloat("hue", -0.25);
		for (member in members) {
			member.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
			if (PlayState.SONG.song.toLowerCase() == "reborn" && ClientPrefs.shaders != "None") {
				cast(member, FlxSprite).shader = shader;
			}
			cast(member, FlxSprite).updateHitbox();
		}
	}

	extern inline function getShaderFrag(file:String):String {
		return File.getContent('content/wfcr/shaders/' + file + '.frag');
	}
}
private class PauseButton extends FlxButton {
	var targetScale:Float = 1.0;
	override function update(elapsed:Float) {
		super.update(elapsed);
		if(FlxG.mouse.overlaps(this, this.cameras[0])){
			targetScale = 1.075;
		}
		else{
			targetScale = 1;
		}
		scale.x = scale.y = FlxMath.lerp(scale.x, targetScale, elapsed*12);
	}
}