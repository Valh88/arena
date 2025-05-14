package states;

import view.ui.haxeui.MenuButton;
import flixel.util.FlxColor;
import haxe.ui.core.Screen;
import flixel.FlxG;
import openfl.display.Sprite;
import controllers.GameMenuController;
import controllers.StateController;
import flixel.FlxState;

class GameMenuState extends FlxState
{
	var _stateController:StateController;
	var _gameMenuController:GameMenuController;
	var _openflCursor:Sprite;

	public function new(stateController:StateController)
	{
		super();
		bgColor = FlxColor.LIME;

		_stateController = stateController;
		_gameMenuController = new GameMenuController();
		_gameMenuController.backCallBack = function()
		{
			_stateController.switchState("connect");
		};
		_gameMenuController.serchGameCallback = function()
		{
			_stateController.switchState("go_game");
		};
		_gameMenuController.updateButtonCallback();
		_gameMenuController.updateButtonSearchCallback();

		// var buttonBack = new MenuButton("Back/Disconnect");
		// add(buttonBack);
		changeCursor();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (_openflCursor != null)
		{
			_openflCursor.x = FlxG.mouse.x;
			_openflCursor.y = FlxG.mouse.y;
		}
	}

	public function changeCursor()
	{
		_openflCursor = new Sprite();
		_openflCursor.graphics.beginFill(0xFF0000);
		_openflCursor.graphics.drawRect(0, 0, 10, 10);
		_openflCursor.graphics.endFill();

		FlxG.stage.addChild(_openflCursor);
		FlxG.mouse.visible = false;
	}

	override public function destroy()
	{
		super.destroy();
		FlxG.stage.removeChild(_openflCursor);
		_gameMenuController.destroy();
	}
}
