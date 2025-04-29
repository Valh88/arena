package view.ui.haxeui;

import flixel.FlxG;
import haxe.Constraints.Function;
import haxe.ui.util.Color;
import haxe.ui.containers.Box;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.macros.ComponentMacros.build("assets/haxeui/menu_button.xml"))
class MenuButton extends Box
{
	public var callback:Function;

	public function new(text:String)
	{
		super();
		this.label.text = text;
		this.text = text;
		width = 200;
		height = 50;
		backgroundColor = Color.fromString("plum");
		style.color = Color.fromString("white");
		callback = function()
		{
			trace("Default callback");
		};
		registerEvent(MouseEvent.CLICK, function(e:MouseEvent)
		{
			if (callback != null)
			{
				callback();
			}
		});
	}

	public function toLeft()
	{
		this.x = 20;
		this.y = FlxG.height - this.height - 20;
	}

	public function toRight()
	{
		this.x = FlxG.width - 120 - 20;
		this.y = FlxG.height - this.height - 20;
	}
}
