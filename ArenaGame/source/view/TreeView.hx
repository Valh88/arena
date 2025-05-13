package view;

import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class TreeView extends FlxSpriteGroup
{
	private var _trunk:FlxSprite;
	private var _crown:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		_trunk = new FlxSprite(42, 0);
		_trunk.makeGraphic(20, 100, FlxColor.BROWN);
		add(_trunk);

		_crown = new FlxSprite(0, -50);
		_crown.makeGraphic(100, 100, FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawCircle(_crown, 50, 50, 50, FlxColor.GREEN);
		add(_crown);
	}
}
