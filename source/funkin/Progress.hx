package funkin;

import flixel.util.FlxSave;

class Progress {
	public static var progressSave:FlxSave = new FlxSave();

	public static var saves:Map<String, FlxSave> = [];

	public static final bindPath:String = "wfcr";

	public static final conditions:Array<String> = [
		"playedMatt",
		"playedAkiro",
		"playedAkiroRoute1",
		"playedAkiroRoute2",
		"playedTommy",
		"playedTommyRoute1",
		"playedTommyRoute2",
		"storyComplete"
	];

	public static final songsToCondition:Map<String, String> = [
		"homebrew" => "playedMatt",
		"catalyst" => "playedMatt",
		"alarmiing" => "playedMatt",
		"unbound" => "playedMatt",
		"paradox" => "playedAkiro",
		"katana" => "playedAkiro",
		"eterniity" => "playedAkiroRoute1",
		"last-resort" => "playedAkiroRoute1",
		"your-personal-hell" => "playedAkiroRoute2",
		"deciimation" => "playedAkiroRoute2",
		"hectiic" => "playedTommy",
		"ones" => "playedTommy",
		"zeniith" => "playedTommyRoute1",
		"calamiity" => "playedTommyRoute1",
		"rapture" => "playedTommyRoute2",
		"priimunus" => "playedTommyRoute2",
		"tiramisu" => "storyComplete",
		"terminus" => "storyComplete",
		"nostalgia" => "storyComplete",
		"final-timeout" => "storyComplete",
		"genesis" => "storyComplete",
		"haxchi" => "storyComplete",
		"reborn" => "storyComplete",
		"reliic" => "storyComplete",
		"purgatorii" => "storyComplete",
		"hatarii" => "storyComplete",
		"wretched" => "storyComplete",
		"ballin" => "storyComplete",
		"bounce" => "storyComplete",
		"test" => "playedMatt",
	];

	public static function getCondition(condition:String):Bool {
		switch (condition.toLowerCase()) {
			case "playedakiro":
				return getData("playedAkiroRoute1") || getData("playedAkiroRoute2");
			case "playedtommy":
				return getData("playedTommyRoute1") || getData("playedTommyRoute2");
			case "storycomplete":
				return getData("playedAkiroRoute1") && getData("playedAkiroRoute2") && getData("playedTommyRoute1") && getData("playedTommyRoute2") && getCondition("playedMatt");
		}
		return getData(condition);
	}

	public static inline function isSongUnlocked(song:String):Bool {
		return songsToCondition.exists(song) && getCondition(songsToCondition.get(song));
	}

	public static function isWeekUnlocked(week:String):Bool {
		switch (week.toLowerCase()) {
			case "matt":
				return true; // unlocked by default
			case "akiro":
				return getData("playedMatt");
			case "tommy":
				return getData("playedAkiroRoute1") || getData("playedAkiroRoute2");
		}
		return false;
	}

	public inline static function init() {
		createSaveFullPath("progress", bindPath + "-progress");
	}

	public static function createSaveFullPath(key:String, bindName:String) {
		var save = new FlxSave();
		save.bind(bindName, bindPath);

		saves.set(key, save);
	}

	public static function getData(dataKey:String):Dynamic {
		if (saves.exists("progress"))
			return Reflect.getProperty(Reflect.getProperty(saves.get("progress"), "data"), dataKey);

		return null;
	}

	public extern inline static function setData(value:Dynamic, dataKey:String) {
		if (saves.exists("progress")) {
			Reflect.setProperty(Reflect.getProperty(saves.get("progress"), "data"), dataKey, value);

			saves.get("progress").flush();
		}
	}
}
