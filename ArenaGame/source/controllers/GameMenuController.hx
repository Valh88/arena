package controllers;

import haxe.Constraints.Function;
import haxe.ui.core.Screen;
import view.ui.haxeui.MenuButton;

class GameMenuController
{
	public var backCallBack:Function;
	public var serchGameCallback:Function;

	var _buttonBack:MenuButton;
	var _buttonSearchGame:MenuButton;

	public function new()
	{
		_buttonBack = new MenuButton("Back/Disconnect");
		_buttonBack.toLeft();
		updateButtonCallback();
		Screen.instance.addComponent(_buttonBack);

		_buttonSearchGame = new MenuButton("Search game");
		_buttonSearchGame.toRight();
		Screen.instance.addComponent(_buttonSearchGame);
	}

	public function updateButtonCallback()
	{
		if (_buttonBack != null && backCallBack != null)
		{
			_buttonBack.callback = backCallBack;
		}
	}

	public function updateButtonSearchCallback()
	{
		if (_buttonSearchGame != null && serchGameCallback != null)
		{
			_buttonSearchGame.callback = serchGameCallback;
		}
	}

	public function destroy()
	{
		Screen.instance.removeComponent(_buttonBack);
		Screen.instance.removeComponent(_buttonSearchGame);
	}
}
