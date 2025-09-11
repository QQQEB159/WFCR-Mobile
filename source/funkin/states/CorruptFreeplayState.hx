package funkin.states;

import sys.FileSystem;
import flixel.util.FlxSave.FlxSharedObject;
import funkin.data.Highscore;
import funkin.Conductor;
import funkin.data.Song;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;
import funkin.shaders.GlitchEffect;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.filters.ShaderFilter;

using funkin.CoolerStringTools;

class CorruptFreeplayState extends MusicBeatState {
	var buttons:ButtonGroup;

	var comets:FlxEmitter;

	var scoreText:FlxText;

	private var songs:Array<String> = [
		// Matt
		'homebrew',
		'catalyst',
		'alarmiing',
		'unbound',
		// Akiro
		'paradox',
		'katana', // phighting reference
		// Akiro route 1
		'eterniity',
		'last-resort',
		// Akiro route 2
		'your-personal-hell',
		'deciimation',
		// Tommy
		'hectiic',
		'ones',
		// Tommy route 1
		'zeniith',
		'calamiity',
		// Tommy route 2
		'rapture',
		'priimunus',
		// Freeplay
		'tiramisu',
		'terminus',
		'final-timeout',
		'genesis',
		'haxchi',
		'reborn',
		'reliic',
		'purgatorii',
		'hatarii',
		'wretched',
		'ballin',
		'bounce'
	];

	public var ports:Map<String, FreeplayPortrait> = new Map<String, FreeplayPortrait>();

	public var portName:Map<String, String> = [
		"homebrew" => "matt",
		"catalyst" => "matt",
		"alarmiing" => "matt",
		"tiramisu" => "matt",
		"terminus" => "matt",
		"nostalgia" => "matt",
		"final-timeout" => "matt",
		"unbound" => "matt2",
		"haxchi" => "matt2",
		"genesis" => "matt2",
		"reborn" => "matt2",
		"paradox" => "akiro",
		"katana" => "akiro",
		"eterniity" => "akiro",
		"your-personal-hell" => "akiro",
		"purgatorii" => "akiro",
		"hectiic" => "tommy",
		"ones" => "tommy",
		"ragnarok" => "tommy",
		"zeniith" => "tommy",
		"rapture" => "tommy",
		"reliic" => "tommy",
		"last-resort" => "tommyakiro",
		"deciimation" => "tommyakiro",
		"calamiity" => "tommyakiro",
		"priimunus" => "tommyakiro",
		"hatarii" => "mattakrio",
		"wretched" => "matttommy",
		"ballin" => "matttommy",
		"bounce" => "bounce"
	];

	private var portsList:Array<String> = [
		'matt',
		'matt2',
		'akiro',
		'tommy',
		'bounce',
		'tommyakiro',
		'matttommy',
		'mattakrio'
	];

	var glitch:GlitchEffect = new GlitchEffect();

	var down:FlxSprite = new FlxSprite();
	var up:FlxSprite = new FlxSprite();

	var scoreCard:FlxSprite = new FlxSprite();

	var hue:CustomShader = new CustomShader(sys.io.File.getContent('content/wfcr/shaders/' + 'HSVEffect' + '.frag'));

	static var actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing(default, set):Int = 0;

	override public function create() {
		super.create();
		hue.setFloat("hue", 0);
		MusicBeatState.playMenuMusic(1, false);
		FlxG.mouse.load(Paths.image("pointer").bitmap);
		FlxG.mouse.visible = true;
		#if DISCORD_ALLOWED
		funkin.api.Discord.DiscordClient.changePresence('In the menus');
		#end

		@:privateAccess
		if(FileSystem.exists(FlxSharedObject.getPath("ShadowMario/WiiFunkin", "funkin"))){
			songs.insert(songs.indexOf("final-timeout"), "nostalgia");
		}

		var bg:FlxSprite = new FlxSprite().loadGraphic("assets/images/freeplay/corrofreeplay0004.png");
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		var thing:FlxSprite = new FlxSprite().loadGraphic("assets/images/freeplay/corrofreeplay0003.png");
		thing.screenCenter();
		thing.antialiasing = ClientPrefs.globalAntialiasing;
		add(thing);
		var beamlol:FlxSprite = new FlxSprite().loadGraphic("assets/images/freeplay/corrofreeplay0002.png");
		beamlol.screenCenter();
		beamlol.antialiasing = ClientPrefs.globalAntialiasing;
		add(beamlol);
		if (!ClientPrefs.lowQuality) {
			comets = new FlxEmitter(0, FlxG.height);
			for (i in 0...150) {
				comets.add(cast(new FlxParticle().loadGraphic("assets/images/freeplay/comet.png"), FlxParticle));
			}
			comets.width = FlxG.width;
			comets.launchMode = CIRCLE;
			comets.launchAngle.set(73, 73);
			comets.speed.set(-1000);
			comets.lifespan.set(0);
			comets.start(false, 2);
			add(comets);
		}

		buttons = new ButtonGroup();
		buttons.screenCenter(Y);
		for (i in 0...songs.length) {
			var button:FreeplayButton = new FreeplayButton(songs[i]);
			button.x = 83;
			button.ID = i;
			button.offset.y = -18.5;
			buttons.add(button);
		}
		buttons.curSelected = actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing;

		for (image in portsList) {
			var port:FreeplayPortrait = new FreeplayPortrait(image);
			add(port);
			ports.set(image, port);
		}

		add(buttons);

		down.loadGraphic("assets/images/freeplay/down.png");
		down.antialiasing = ClientPrefs.globalAntialiasing;
		down.x = 13;
		down.screenCenter(Y);
		down.y += 52;
		if (!ClientPrefs.lowQuality) {
			add(down);
		}

		up.loadGraphic("assets/images/freeplay/up.png");
		up.antialiasing = ClientPrefs.globalAntialiasing;
		up.x = 13;
		up.screenCenter(Y);
		up.y -= 52;
		if (!ClientPrefs.lowQuality) {
			add(up);
		}

		// YEAH IM REUSING THE CREDITS TAB FUCK YOU
		scoreCard = new FlxSprite();
		scoreCard.loadGraphic(Paths.image("corruption_tab"));
		scoreCard.antialiasing = ClientPrefs.globalAntialiasing;
		scoreCard.flipX = true;
		scoreCard.x = FlxG.width - scoreCard.width;
		scoreCard.scale.y = 1 / 2;
		scoreCard.updateHitbox();
		add(scoreCard);

		scoreText = new FlxText(0, 25, 0, 'PERSONAL BEST: 0');
		scoreText.setFormat(Paths.font("droidbold.ttf"), 28, 0xFFFFFFFF, LEFT);
		scoreText.x = FlxG.width - scoreText.width;
		scoreText.y = (scoreCard.height / 2 - scoreText.height / 2) + 6;
		add(scoreText);

		refreshScore();

		if (ClientPrefs.shaders != "None") {
			FlxG.camera.filters = [new ShaderFilter(hue), new ShaderFilter(glitch.shader)];
		}

		glitch.speed = 0.35;
		glitch.amount = 0.0;
	}

	override function stepHit() {
		super.stepHit();

		buttons.forEachAlive((button) -> {
			if (!Progress.isSongUnlocked(button.songName)) {
				button.text.text = button.text.text.shuffle();
			}
		});
	}

	function refreshScore() {
		var record = Highscore.getRecord(songs[actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing].toLowerCase(), "hard");

		targetRating = Highscore.getRatingRecord(record) * 100;
		if (ClientPrefs.showWifeScore)
			targetHighscore = record.accuracyScore * 100;
		else
			targetHighscore = record.score;
	}

	var targetHighscore:Float = 0.0;
	var lerpHighscore:Float = 0.0;

	var targetRating:Float = 0.0;
	var lerpRating:Float = 0.0;

	override function draw() {
		lerpHighscore = CoolUtil.coolLerp(lerpHighscore, targetHighscore, FlxG.elapsed * 12);
		lerpRating = CoolUtil.coolLerp(lerpRating, targetRating, FlxG.elapsed * 8);

		var score = Math.round(lerpHighscore);
		var rating = formatRating(lerpRating);

		scoreText.text = 'PERSONAL BEST: $score ($rating%)';
		scoreText.x = FlxG.width - scoreText.width;

		super.draw();
	}

	private static function formatRating(val:Float):String {
		var str = Std.string(Math.floor(val * 100.0) / 100.0);
		var dot = str.indexOf('.');

		if (dot == -1)
			return str + '.00';

		dot += 3;
		while (str.length < dot)
			str += '0';

		return str;
	}

	var targetGlitch:Float = 0;
	var targetHue:Float = 0;

	override function update(elapsed:Float) {
		super.update(elapsed);
		glitch.update(elapsed);
		hue.setFloat("hue", FlxMath.lerp(hue.getFloat("hue"), targetHue, elapsed * 4));
		glitch.amount = FlxMath.lerp(glitch.amount, targetGlitch, elapsed * 4);
		if (controls.UI_UP_P || (FlxG.mouse.justPressed && FlxG.mouse.overlaps(up))) {
			buttons.curSelected--;
			actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing--;
			up.y -= 16;
			refreshScore();
		}
		if (controls.UI_DOWN_P || (FlxG.mouse.justPressed && FlxG.mouse.overlaps(down))) {
			buttons.curSelected++;
			actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing++;
			down.y += 16;
			refreshScore();
		}

		var wheel:Int = -Math.floor(FlxG.mouse.wheel);
		if (wheel != 0) {
			buttons.curSelected += wheel;
			actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing += wheel;
			if (wheel >= 1) {
				down.y += 16;
			} else if (wheel < 1) {
				up.y -= 16;
			}
			refreshScore();
		}

		up.y = FlxMath.lerp(up.y, ((FlxG.height - up.height) / 2) - 52, elapsed * 9.6);
		down.y = FlxMath.lerp(down.y, ((FlxG.height - down.height) / 2) + 52, elapsed * 9.6);
		if(actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing >= buttons.members.length){
			actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing = buttons.members.length - 1;
		} 
		if (Progress.isSongUnlocked(buttons.members[actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing].songName)
			&& (controls.ACCEPT
				|| (FlxG.mouse.justPressed
					&& FlxG.mouse.overlaps(buttons.members[actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing])))) {
			Song.loadSong(new Song(songs[actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing].toLowerCase(), 'wfcr'));
			LoadingState.loadAndSwitchState(new PlayState());
		}
		if (controls.BACK) {
			FlxG.switchState(new MainMenuState());
		}
		for (port in ports) {
			if (portName.get(songs[actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing].toLowerCase()) == port.name.toLowerCase()) {
				if (!Progress.isSongUnlocked(buttons.members[actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing].songName)) {
					port.color = FlxColor.BLACK;
				} else {
					port.color = FlxColor.WHITE;
				}
				port.targetAlpha = 1;
				if (Progress.isSongUnlocked("bounce") && port.name.toLowerCase() == "bounce") {
					targetGlitch = 0.035;
				} else if (Progress.isSongUnlocked("bounce")
					&& songs[actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing].toLowerCase() == "reborn") {
					targetHue = -0.25;
				} else {
					targetGlitch = 0;
					targetHue = 0;
				}
			} else {
				port.targetAlpha = 0;
			}
		}

		if (FlxG.sound.music != null) {
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	@:noCompletion
	static inline function set_actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing(v:Int):Int {
		var max:Int = cast(FlxG.state, CorruptFreeplayState).buttons.length - 1;
		if (v < 0) {
			v = max;
		}
		if (v > max) {
			v = 0;
		}
		return actualCurSelectedBecauseFuckYouIDontFeelLikeRewritingThisWholeThing = v;
	}

}

class FreeplayPortrait extends FlxSprite {
	public var targetAlpha:Float = 0;

	public var name:String;

	private var _doEasterEgg:Bool = false;

	public function new(name:String) {
		super();
		loadGraphic(Paths.image('freeplay/port/$name'));
		this.name = name;
		alpha = 0;
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		alpha = FlxMath.lerp(alpha, targetAlpha, elapsed * 5);
	}

	public function doEasterEgg(e:Bool){
		if(_doEasterEgg){
			loadGraphic("assets/images/freeplay/port/akiro.png");
			_doEasterEgg = false;
		}
		if(e){
			loadGraphic("assets/images/freeplay/port/akirowo.png");
			_doEasterEgg = true;
		}
	}
}

class ButtonGroup extends FlxTypedSpriteGroup<FreeplayButton> {
	override public function new() {
		super();
	}

	public var curSelected(default, set):Int;
	public var curItem:Null<FreeplayButton> = null;

	function set_curSelected(value:Null<Int>) {
		var range:Int = members.length;

		if (range > 0) {
			if (value < 0)
				value += range * Std.int(-value / range + 1);
			value %= range;
		} else {
			value = null;
		}

		var prevItem = curItem;
		if (prevItem != null) {
			prevItem.alpha = 0.6;
		}

		curItem = members[value];
		if (curItem != null) {
			curItem.alpha = 1.0;
		}

		if (value != null) {
			for (i => item in members) {
				item.targetY = i - value;
				item.targetAlpha = FlxMath.bound(1 - (value - i) / 3, 0, 1);
				if (i > value)
					item.targetAlpha = FlxMath.bound(Math.abs((value - i + 4) - 1) / 3, 0, 1);
			}
		}

		if (value != null && value != curSelected)
			FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		cast(FlxG.state, CorruptFreeplayState).ports.get("akiro")?.doEasterEgg(FlxG.random.bool((1/300)*100));

		return curSelected = value;
	}
}

class FreeplayButton extends FlxSpriteGroup {
	public var box:FlxSprite;
	public var text:FlxText;

	public var targetY:Float = 0;
	public var targetAlpha:Float = 1;

	public var songName(default, null):String;

	override public function new(song:String) {
		super();
		songName = song.toLowerCase();
		alpha = 0.6;
		box = new FlxSprite().loadGraphic("assets/images/freeplay/corrofreeplay0001.png");
		box.antialiasing = ClientPrefs.globalAntialiasing;
		add(box);
		text = new FlxText();
		text.text = song.toUpperCase();
		text.setFormat("assets/fonts/droidbold.ttf", 48, FlxColor.WHITE, CENTER);
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.x = (box.width - text.width) / 2;
		text.y = (box.height - text.height) / 2;
		add(text);
	}

	inline public function getTargetY() {
		return -18 + (targetY * box.height) + ((FlxG.height - box.height) / 2) + targetY * 18;
	}

	override function update(elapsed:Float) {
		y = FlxMath.lerp(getTargetY(), y, Math.exp(-elapsed * 9.6));
		alpha = FlxMath.lerp(alpha, targetAlpha, elapsed * 9.6);
		scale.x = scale.y = FlxMath.bound(alpha * 1.1, 0.55, 1);
		super.update(elapsed);
	}
}
