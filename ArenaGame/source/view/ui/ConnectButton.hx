package view.ui;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class ConnectButton extends FlxButton
{
	public function new()
	{
		var buttonWidth = 50;
		var buttonHeight = 50;
		var x = (FlxG.width - buttonWidth) / 2;
		var y = (FlxG.height - buttonHeight) / 2;
		super(x, y, "Connect", () ->
		{
			onClick();
		});
		label.setFormat(null, 16, FlxColor.WHITE, CENTER);
		makeGraphic(buttonWidth, buttonHeight, FlxColor.BLUE);
		text = "Connect";
	}

	public function onClick()
	{
		onUp.callback = () -> trace("123");
	}
}
