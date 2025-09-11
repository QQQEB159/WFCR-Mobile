package funkin.states;

import funkin.data.Song;
import flixel.effects.particles.FlxParticle;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxSprite;
import funkin.states.PlayState;
#if DISCORD_ALLOWED
import funkin.api.Discord.DiscordClient;
#end

class MainMenuState extends MusicBeatState {
	var bg:FlxSprite;
	var logo:FlxSprite;
	var bubbles:FlxEmitter;
	var buttonGroup:FlxSpriteGroup;
	final buttonText:Array<String> = ["Story Mode", "Freeplay", "Credits", "Options"];
	// probably a better way to do this but ae d 40
	final buttonFuncs:Array<() -> Void> = [
		function() {
			/*PlayState.songPlaylist = [
					{songName: 'homebrew', folder: 'wfcr'},
					{songName: 'catalyst', folder: 'wfcr'},
					{songName: 'alarmiing', folder: 'wfcr'},
					{songName: 'unbound', folder: 'wfcr'}
				];
				Song.loadSong({songName: PlayState.songPlaylist[0].songName.toLowerCase(), folder: 'wfcr'}, "hard", 2);
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
				PlayState.isStoryMode = true;
				LoadingState.loadAndSwitchState(new PlayState()); */
			FlxG.switchState(new funkin.states.CorrruptStoryMenuState());
		},
		function() {
			FlxG.switchState(new funkin.states.CorruptFreeplayState());
		},
		function() {
			FlxG.switchState(new funkin.states.CreditsState());
		},
		function() {
			FlxG.switchState(new funkin.states.options.OptionsState());
		},
	];

	override function create() {
		super.create();
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		bg = new FlxSprite();
		bg.loadGraphic(Paths.image("corrumentu0010"));
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		if (!ClientPrefs.lowQuality) {
			bubbles = new FlxEmitter(0, FlxG.height + 100, 300);
			for (i in 0...150) {
				for (j in 1...6) {
					var p:FlxParticle = new FlxParticle();
					p.loadGraphic(Paths.image("abubble" + j));
					bubbles.add(p);
				}
			}
			bubbles.width = FlxG.width;
			bubbles.launchMode = SQUARE;
			bubbles.velocity.set(-15, -80, 15, -120);
			bubbles.lifespan.set(0);
			add(bubbles);
			bubbles.start(false, 0.25);
		}
		logo = new FlxSprite(34, 595);
		logo.loadGraphic(Paths.image("corrumentu0001"));
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		add(logo);
		buttonGroup = new FlxSpriteGroup();
		add(buttonGroup);
		for (i in 0...buttonText.length) {
			var button:FlxButton = new FlxButton(0, 137 + (137 * i), buttonText[i], buttonFuncs[i]);
			button.loadGraphic(Paths.image("button"), true, 504, 65);
			button.label.setFormat(Paths.font("droidbold.ttf"), 30, FlxColor.WHITE, "center");
			button.label.fieldHeight = 65;
			button.label.offset.set(0, -65 / (4 * 1.5));
			button.ID = i;
			button.screenCenter(X);
			buttonGroup.add(button);
			button.scrollFactor.set(0, 0);
			button.antialiasing = ClientPrefs.globalAntialiasing;
			button.label.antialiasing = ClientPrefs.globalAntialiasing;
			button.updateHitbox();
		}
		FlxG.mouse.load(Paths.image("pointer").bitmap);
		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if(controls.BACK){
			FlxG.switchState(new TitleState());
		}
	}
}
