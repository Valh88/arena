package controllers;

import states.GoGameState;
import flixel.FlxG;
import states.GameMenuState;
import flixel.FlxState;

class StateController
{
	// var _currentState:FlxState;
	public function new()
	{
		// _currentState = state;
	}

	public function switchState(key:String)
	{
		switch (key)
		{
			case "connect":
				FlxG.switchState(() -> new PlayState());
			case "game_menu":
				FlxG.switchState(() -> new GameMenuState(this));
			case "go_game":
				FlxG.switchState(() -> new GoGameState(this));
			case _:
				trace("no state");
		}
	}
}
