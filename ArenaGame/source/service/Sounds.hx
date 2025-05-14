package service;

import flixel.FlxG;
import flixel.sound.FlxSound;

class Sounds
{
	static var _sounds:Sounds;

	var _shot:FlxSound;

	function new()
	{
		_shot = FlxG.sound.load(AssetPaths.shot__wav);
        _shot.volume = 10.0;
	}

	public static function init()
	{
		_sounds = new Sounds();
	}

	public static function shot()
	{
		_sounds._shot.play(true);
	}
}
