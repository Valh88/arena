package;

import controllers.StateController;
import flixel.util.FlxColor;
import view.ui.haxeui.InputLogin.InputLoginPassword;
import flixel.FlxG;
import view.ui.ConnectButton;
import flixel.addons.ui.FlxUIState;
import haxe.ui.core.Screen;
import flixel.FlxState;
import haxe.ui.Toolkit;
import openfl.display.Sprite;

class PlayState extends FlxState
{
	var _stateController:StateController;
	var input:InputLoginPassword;
	var openflCursor:Sprite;

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = true;
		Toolkit.init();
		
		bgColor = FlxColor.LIME;

		_stateController = new StateController();

		input = new InputLoginPassword();
		input.onConnectCallback = () ->
		{
			_stateController.switchState("game_menu");
		}
		input.width = 300;
		input.height = 200;
		input.x = (FlxG.width / 2) - (input.width / 2);
		input.y = (FlxG.height / 2) - (input.height / 2);
		Screen.instance.addComponent(input);

		changeCursor();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (openflCursor != null)
		{
			openflCursor.x = FlxG.mouse.x;
			openflCursor.y = FlxG.mouse.y;
		}
	}

	public function changeCursor()
	{
		openflCursor = new Sprite();
		openflCursor.graphics.beginFill(0xFF0000);
		openflCursor.graphics.drawRect(0, 0, 10, 10);
		openflCursor.graphics.endFill();

		FlxG.stage.addChild(openflCursor);

		FlxG.mouse.visible = false;
	}

	override public function destroy()
	{
		super.destroy();
		Screen.instance.removeComponent(input);
		FlxG.stage.removeChild(openflCursor);
	}
}
