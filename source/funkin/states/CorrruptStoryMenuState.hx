package funkin.states;

import cpp.Int8;
import cpp.UInt8;
import flixel.group.FlxSpriteGroup;
import openfl.filters.BitmapFilterQuality;
import funkin.shaders.GlitchEffect;
import openfl.filters.BlurFilter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxRect;
import openfl.display.BitmapData;
import funkin.objects.shaders.FogEffect;
import openfl.filters.ShaderFilter;
import funkin.data.Song;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

using funkin.CoolerStringTools;

typedef WeekData = {
	var songs:Array<Song>;

	var saveString:String;

	@:optional
	var saveStringAlt:String;

	@:optional
	var route1:Array<Song>;

	@:optional
	var route2:Array<Song>;
}

class CorrruptStoryMenuState extends MusicBeatState {
	var bg:FlxSprite;

	public static var buttons:Buttons;
	public static var weeks:Array<String> = ["matt", "akiro", "tommy"];

	var weekData:Map<String, WeekData> = [
		"matt" => {
			songs: [
				new Song('homebrew', 'wfcr'),
				new Song('catalyst', 'wfcr'),
				new Song('alarmiing', 'wfcr'),
				new Song('unbound', 'wfcr')
			],
			saveString: "playedMatt"
		},
		"akiro" => {
			songs: [
				new Song('paradox', 'wfcr'),
				new Song('katana', 'wfcr'), // no not from phighting
			],
			route1: [new Song('eterniity', 'wfcr'), new Song('last-resort', 'wfcr')],
			route2: [new Song('your-personal-hell', 'wfcr'), new Song('deciimation', 'wfcr')],
			saveString: "playedAkiroRoute1",
			saveStringAlt: "playedAkiroRoute2"
		},
		"tommy" => {
			songs: [new Song('hectiic', 'wfcr'), new Song('ones', 'wfcr'), // no not from phighting
			],
			route1: [new Song('zeniith', 'wfcr'), new Song('calamiity', 'wfcr')],
			route2: [new Song('rapture', 'wfcr'), new Song('priimunus', 'wfcr')],
			saveString: "playedTommyRoute1",
			saveStringAlt: "playedTommyRoute2"
		}
	];

	var fogBottom:FogEffect;
	var fogTop:FogEffect;

	override function create() {
		super.create();

		FlxG.mouse.load(Paths.image("pointer").bitmap);
		FlxG.mouse.visible = true;
		MusicBeatState.playMenuMusic(1, false);
		bg = new FlxSprite();
		bg.loadGraphic("assets/images/corrumentu0010.png");
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		buttons = new Buttons();
		add(buttons);
		for (i in 0...3) {
			var graphic:String = weeks[i];
			var button:Button = new Button(graphic, weekData[graphic]);
			button.ID = i;
			button.screenCenter();
			button.y = button.targetY = button.y + (FlxG.height * i);
			buttons.add(button);
		}
		buttons.curSelected = 0;

		fogBottom = new FogEffect();
		fogBottom.color = 0x000000;
		fogTop = new FogEffect();
		fogTop.color = 0xD03432;
		fogTop.offset = Math.PI;
		FlxG.camera.filters = [new ShaderFilter(fogTop.shader), new ShaderFilter(fogBottom.shader)];
	}

	var targetFogDensity:Float = 0.0;

	override function update(elapsed:Float) {
		super.update(elapsed);
		fogBottom.update(elapsed);
		fogTop.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(() -> new MainMenuState());
		}

		if (controls.UI_DOWN_P) {
			buttons.curSelected++;
		} else if (controls.UI_UP_P) {
			buttons.curSelected--;
		}

		if (FlxG.mouse.wheel != 0) {
			if (Math.abs(FlxG.mouse.wheel) >= 1) {
				buttons.curSelected += FlxG.mouse.wheel > 0 ? -1 : 1;
			}
		}

		fogTop.cloudDensity = fogBottom.cloudDensity = FlxMath.lerp(fogBottom.cloudDensity, targetFogDensity, elapsed * 5);
		if (Progress.isWeekUnlocked(weeks[buttons.curSelected])) {
			targetFogDensity = 0;
		} else {
			targetFogDensity = 0.5525;
		}
	}
}

class Button extends FlxTypedSpriteGroup<FlxSprite> {
	public var weekName:String;
	public var targetY:Float = 0;
	public var data:WeekData;

	var weekGraphic:FlxSprite;
	var glitch:GlitchEffect = new GlitchEffect();
	var blur:BlurFilter = new BlurFilter(23, 1, 2);

	public var glitch_cam:FlxCamera;

	var songLines:Array<FlxText> = [];
	var lineSpacing:Int = 13;

	var fadeTween:FlxTween;

	var isAnyButtonHovered:Bool = false;

	var button:FlxButton;
	var button2:FlxButton;

	var glitchTargetAmount:Float = 0.05;
	var blurTargetX:Float = 23;
	var blurTargetY:Float = 0.2;

	var routeSelected = 1;

	override public function new(weekName:String, data:WeekData) {
		super();
		this.weekName = weekName;
		this.data = data;

		weekGraphic = new FlxSprite();
		weekGraphic.loadGraphic('assets/images/story/story$weekName.png');
		weekGraphic.antialiasing = ClientPrefs.globalAntialiasing;
		weekGraphic.screenCenter();
		add(weekGraphic);

		var characterText:FlxText = new FlxText(0, 0, 400, weekName.toUpperCase(), 20, true);
		characterText.setFormat("assets/fonts/droidbold.ttf", 27, FlxColor.WHITE, CENTER);
		characterText.screenCenter();
		characterText.setBorderStyle(SHADOW, FlxColor.BLACK, 3, 3);
		characterText.updateHitbox();
		characterText.y -= 100;
		characterText.x -= 115;
		add(characterText);

		if (ClientPrefs.shaders != "None") {
			glitch_cam = new FlxCamera();
			glitch_cam.bgColor = 0;
			FlxG.cameras.add(glitch_cam, false);

			glitch_cam.filters = [new ShaderFilter(glitch.shader), blur];

			glitch.speed = 0.4;
			glitch.amount = 0.05;
		}

		showLines(data.songs, data.route1);

		inline function playDaShit() {
			var toPlay = data.songs[0];
			var difficulty = "hard";
			Paths.currentModDirectory = toPlay.folder;
			PlayState.SONG = toPlay.getSwagSong(difficulty);
			PlayState.difficulty = toPlay.charts.indexOf(difficulty);
			PlayState.difficultyName = difficulty;
			PlayState.isStoryMode = true;
			PlayState.validStoryRun = true;
		}

		button = new FlxButton(0, 0, "PLAY", () -> {
			if (Progress.isWeekUnlocked(CorrruptStoryMenuState.weeks[CorrruptStoryMenuState.buttons.curSelected])) {
				PlayState.storySaveString = data.saveString;
				playDaShit();
				PlayState.songPlaylist = data.route1 != null ? data.songs.concat(data.route1) : data.songs;
				PlayState.songPlaylistIdx = 0;
				LoadingState.loadAndSwitchState(new PlayState());
				if (glitch_cam != null) {
					glitch_cam.filters = [];
				}
			}
		});
		button.loadGraphic("assets/images/story/button.png", true, 170, 33);
		button.clipRect = new FlxRect(0, 0, 170, 32); // crops the button a little
		button.screenCenter();
		button.label.font = "assets/fonts/droidbold.ttf";
		button.label.color = 0xFFFFFFFF;
		button.label.size = 28;
		button.label.y -= 150;
		button.label.updateHitbox();
		button.y = weekGraphic.y + weekGraphic.height - 128;
		add(button);

		if (data.route2 == null) {
			return;
		}

		button2 = new FlxButton(0, 0, "ROUTE 2", () -> {
			var week:String = CorrruptStoryMenuState.weeks[CorrruptStoryMenuState.buttons.curSelected];
			if (Progress.isWeekUnlocked(week)) {
				var popup:SkipPopup = new SkipPopup();
				popup.onNo = () -> {
					PlayState.storySaveString = data.saveStringAlt;
					playDaShit();
					PlayState.songPlaylist = data.songs.concat(data.route2);
					PlayState.songPlaylistIdx = 0;
					LoadingState.loadAndSwitchState(new PlayState());
					if (glitch_cam != null) {
						glitch_cam.filters = [];
					}
				}
				if (Progress.getCondition('played$week')) {
					FlxG.state.openSubState(popup);
					popup.onYes = () -> {
						PlayState.storySaveString = data.saveStringAlt;
						playDaShit();
						PlayState.SONG = data.route2[0].getSwagSong("hard");
						PlayState.songPlaylist = data.route2;
						PlayState.songPlaylistIdx = 0;
						LoadingState.loadAndSwitchState(new PlayState());
						if (glitch_cam != null) {
							glitch_cam.filters = [];
						}
					}
				} else {
					popup.onNo();
				}
			}
		});
		button2.loadGraphic("assets/images/story/button.png", true, 170, 33);
		button2.clipRect = new FlxRect(0, 0, 170, 32); // crops the button a little
		button2.screenCenter();
		button2.label.font = "assets/fonts/droidbold.ttf";
		button2.label.color = 0xFFFFFFFF;
		button2.label.size = 28;
		button2.label.y -= 150;
		button2.label.updateHitbox();
		button2.y = weekGraphic.y + weekGraphic.height - 128;
		button2.x += 150;
		add(button2);

		button2.onOver.callback = () -> {
			if (Progress.isWeekUnlocked(CorrruptStoryMenuState.weeks[CorrruptStoryMenuState.buttons.curSelected]))
				showLines(data.songs, data.route2);
			routeSelected = 2;
		};

		button.onOver.callback = () -> {
			if (Progress.isWeekUnlocked(CorrruptStoryMenuState.weeks[CorrruptStoryMenuState.buttons.curSelected]))
				showLines(data.songs, data.route1);
			routeSelected = 1;
		};

		button2.onOut.callback = () -> {
			showLines(data.songs, data.route1);
		};

		button.onOut.callback = () -> {
			showLines(data.songs, data.route1);
		};

		button.onUp.callback = () -> {
			var week:String = CorrruptStoryMenuState.weeks[CorrruptStoryMenuState.buttons.curSelected];
			if (Progress.isWeekUnlocked(week)) {
				var popup:SkipPopup = new SkipPopup();
				popup.onNo = () -> {
					PlayState.storySaveString = data.saveString;
					playDaShit();
					PlayState.songPlaylist = data.songs.concat(data.route1);
					PlayState.songPlaylistIdx = 0;
					LoadingState.loadAndSwitchState(new PlayState());
					if (glitch_cam != null) {
						glitch_cam.filters = [];
					}
				}
				if (Progress.getCondition('played$week')) {
					FlxG.state.openSubState(popup);
					popup.onYes = () -> {
						PlayState.storySaveString = data.saveString;
						playDaShit();
						PlayState.SONG = data.route1[0].getSwagSong("hard");
						PlayState.songPlaylist = data.route1;
						PlayState.songPlaylistIdx = 0;
						LoadingState.loadAndSwitchState(new PlayState());
						if (glitch_cam != null) {
							glitch_cam.filters = [];
						}
					}
				} else {
					popup.onNo();
				}
			}
		}

		button.label.text = "ROUTE 1";
		button.x -= 150;
	}

	public function showLines(songs:Array<Song>, routeSongs:Array<Song>) {
		for (line in songLines)
			remove(line);
		songLines.resize(0);

		var combined:Array<String> = [];
		for (song in songs)
			combined.push(song.songId.toUpperCase());
		if (routeSongs != null)
			for (song in routeSongs)
				combined.push(song.songId.toUpperCase());

		var totalheight:Int = (combined.length * 27) + ((combined.length - 1) * lineSpacing);
		var centerY:Int = Std.int((FlxG.height - totalheight) / 2);

		for (i in 0...combined.length) {
			var textLine:FlxText = new FlxText(0, centerY + (i * (27 + lineSpacing)) + 70, 400, combined[i], 20, true);
			textLine.setFormat("assets/fonts/droidbold.ttf", 27, FlxColor.WHITE, CENTER);
			textLine.screenCenter(X);
			textLine.updateHitbox();
			textLine.setBorderStyle(SHADOW, FlxColor.BLACK, 3, 3);
			textLine.alpha = 0.8;

			var found:Bool = false;
			if (ClientPrefs.shaders != "None") {
				if (data.route1 != null) {
					for (song in data.route1) {
						if (song.songId.toUpperCase() == combined[i].toUpperCase()) {
							found = true;
							break;
						}
					}
				}

				if (data.route2 != null) {
					if (!found) {
						for (song in data.route2) {
							if (song.songId.toUpperCase() == combined[i].toUpperCase()) {
								found = true;
								break;
							}
						}
					}
				}
			}

			add(textLine);
			songLines.push(textLine);

			if (button2 != null) {
				if (button.status == FlxButtonState.HIGHLIGHT || button2.status == FlxButtonState.HIGHLIGHT) {
					isAnyButtonHovered = true;
				} else {
					isAnyButtonHovered = false;
				}
			}

			if (found) {
				if (ClientPrefs.shaders != "None")
					textLine.cameras = [glitch_cam];
				if (!isAnyButtonHovered
					&& Progress.isWeekUnlocked(CorrruptStoryMenuState.weeks[CorrruptStoryMenuState.buttons.curSelected])) {
					textLine.text = Random.string(FlxG.random.int(7, 15)).toUpperCase();
				}
			}
		}
	}

	inline public function getTargetY() {
		return (targetY * height) + ((FlxG.height - height) / 2) + targetY * 18;
	}

	var shuffleTimer:Float = 0;
	var shuffleSpeed:Float = 0.4;

	override function update(elapsed:Float) {
		var glitchCamTarget:Float = 0;

		super.update(elapsed);
		glitch.update(elapsed);
		y = FlxMath.lerp(getTargetY(), y, Math.exp(-elapsed * 9.6));

		shuffleTimer += elapsed;

		if (shuffleTimer >= shuffleSpeed) {
			if (routeSelected == 1) {
				showLines(data.songs, data.route1);
			} else {
				showLines(data.songs, data.route2);
			}
			shuffleTimer = 0;
		}

		if (button2 != null && ClientPrefs.shaders != "None") {
			if (button.status == FlxButtonState.HIGHLIGHT || button2.status == FlxButtonState.HIGHLIGHT) {
				isAnyButtonHovered = true;
			} else {
				isAnyButtonHovered = false;
			}

			if (!Progress.isWeekUnlocked(CorrruptStoryMenuState.weeks[CorrruptStoryMenuState.buttons.curSelected])) {
				isAnyButtonHovered = false;
				glitchCamTarget = 0.2;
			} else {
				glitchCamTarget = 1.0;
			}

			var glitchTargetAmount:Float = isAnyButtonHovered ? 0 : 0.05;
			var blurTargetX:Float = isAnyButtonHovered ? 0 : 23;
			var blurTargetY:Float = isAnyButtonHovered ? 0 : 0.2;

			glitch.amount = FlxMath.lerp(glitch.amount, glitchTargetAmount, elapsed * 10);
			blur.blurX = FlxMath.lerp(blur.blurX, blurTargetX, elapsed * 10);
			blur.blurY = FlxMath.lerp(blur.blurY, blurTargetY, elapsed * 10);

			glitch_cam.alpha = FlxMath.lerp(glitch_cam.alpha, glitchCamTarget, elapsed * 10);
		}
	}
}

class Buttons extends FlxTypedSpriteGroup<Button> {
	public var curSelected(default, set):Int = 0;
	public var curItem:Null<Button> = null;

	@:noCompletion
	function set_curSelected(value:Null<Int>):Int {
		var range:Int = members.length;

		if (range > 0) {
			if (value < 0)
				value += range * Std.int(-value / range + 1);
			value %= range;
		} else {
			value = null;
		}

		if (value != null) {
			for (i => item in members) {
				item.targetY = i - value;
			}
		}

		if (value != null && value != curSelected)
			FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		return curSelected = value;
	}
}

class SkipPopup extends MusicBeatSubstate {
	var blur:BlurFilter;
	var popupCam:FlxCamera;

	var text:FlxTypedSpriteGroup<FlxText>;

	public dynamic function onYes() {}

	public dynamic function onNo() {}

	public function onClose() {
		FlxTween.tween(blur, {blurX: 0, blurY: 0}, 0.75, {ease: FlxEase.sineOut});
		FlxTween.tween(popupCam, {alpha: 0}, 0.75, {
			ease: FlxEase.sineOut,
			onComplete: (tween) -> {
				FlxG.cameras.list.remove(popupCam);
				close();
			}
		});
	}

	override function create() {
		super.create();
		blur = new BlurFilter(0, 0, BitmapFilterQuality.LOW);
		for (camera in FlxG.cameras.list) {
			camera.filters.push(blur);
		}
		popupCam = new FlxCamera();
		popupCam.bgColor = FlxColor.BLACK;
		popupCam.bgColor.alphaFloat = 0.25;
		popupCam.alpha = 0;
		FlxG.cameras.add(popupCam, false);

		var alert:FlxText = new FlxText();
		alert.text = "SKIP INTRO?";
		alert.alignment = CENTER;
		alert.font = Paths.font("droidbold.ttf");
		alert.size = 32;
		alert.updateHitbox();
		alert.screenCenter();
		alert.y -= 48 * 3;
		add(alert);

		text = new FlxTypedSpriteGroup<FlxText>();
		add(text);
		for (i => t in ["YES", "NO", "CANCEL"]) {
			var text:FlxText = new FlxText();
			text.text = t;
			text.alignment = CENTER;
			text.font = Paths.font("droidbold.ttf");
			text.size = 32;
			text.updateHitbox();
			text.screenCenter();
			text.y += i * 48;
			text.alpha = 0.5;
			this.text.add(text);
			text.ID = i;
		}

		FlxTween.tween(blur, {blurX: 6, blurY: 6}, 0.75, {ease: FlxEase.sineOut});
		FlxTween.tween(popupCam, {alpha: 1}, 0.75, {ease: FlxEase.sineOut});
		for (member in members) {
			member.cameras = [popupCam];
		}
	}

	var curSelected(default, set):Int8 = 0;

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (controls.UI_UP_P) {
			curSelected--;
		} else if (controls.UI_DOWN_P) {
			curSelected++;
		} else if (controls.ACCEPT) {
			switch (curSelected) {
				case 0:
					onYes();
				case 1:
					onNo();
				default:
					onClose();
			}
		} else if (controls.BACK) {
			onClose();
		}
		for (member in text.members) {
			member.alpha = 0.5;
			if (curSelected == member.ID) {
				member.alpha = 1;
			}
		}
	}

	inline function set_curSelected(c:Int8):Int8 {
		if (c < 0) {
			c = text.members.length - 1;
		} else if (c >= text.members.length) {
			c = 0;
		}
		return this.curSelected = c;
	}
}
