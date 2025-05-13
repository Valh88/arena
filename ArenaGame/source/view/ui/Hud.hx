package view.ui;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import models.PlayerModel;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Hud extends FlxTypedGroup<FlxSprite>
{
	var _background:FlxSprite;
	var _hpText:FlxText;
	var _countBullet:FlxSprite;
	var _magazine:FlxText;
	var _playerModel:PlayerModel;
	var _fontSize:Int = 15;
	var _startHp:Int;
	var _noBullets:FlxText;

	var _blinkSprite:FlxSprite;
	var _isBlinking:Bool = false;
	var _blinkTimer:Float = 0;
	var _blinkDuration:Float = 0.5;

	public function new(playerModel:PlayerModel)
	{
		super();
		_playerModel = playerModel;
		_background = new FlxSprite().makeGraphic(FlxG.width, 50, FlxColor.BLACK);
		_background.alpha = 0.2;
		add(_background);

		_startHp = _playerModel.hp;
		_hpText = new FlxText(110, 25, 0, "HP: " + _playerModel.hp + "/" + _playerModel.hp, _fontSize);
		add(_hpText);

		_magazine = new FlxText(300, 15, 0,
			_playerModel.weapon.name
			+ " | "
			+ "bullets: "
			+ _playerModel.weapon.countBullets
			+ "\n"
			+ "magazine: "
			+ _playerModel.weapon.maxBulletInMagazine
			+ "/"
			+ _playerModel.weapon.bulletInMagazine,
			_fontSize
			- 4);
		add(_magazine);

		_noBullets = new FlxText(FlxG.width / 2 - 100, FlxG.height / 2 - 100, 0, "No bullets!", _fontSize - 2);
		_noBullets.color = FlxColor.RED;
		_noBullets.visible = false;
		_noBullets.exists = false;
		add(_noBullets);

		_blinkSprite = new FlxSprite();
		add(_blinkSprite);

		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHudHp()
	{
		_hpText.text = "HP: " + _playerModel.hp + "/" + _startHp;
	}

	public function updateHudWeaponBullets()
	{
		_magazine.text = _playerModel.weapon.name + " | " + "bullets: " + _playerModel.weapon.countBullets + "\n" + "magazine: "
			+ _playerModel.weapon.maxBulletInMagazine + "/" + (_playerModel.weapon.bulletInMagazine - 1);
	}

	public function addTextNoBullet(?text:String)
	{
		if (text != null)
		{
			_noBullets.text = text;
		}
		_noBullets.visible = true;
		_noBullets.exists = true;
		_isBlinking = true;
	}

	public function removeTextNoBullet()
	{
		_noBullets.visible = false;
		_noBullets.exists = false;
		_isBlinking = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_isBlinking)
		{
			_blinkTimer += elapsed;

			if (_blinkTimer >= _blinkDuration)
			{
				_blinkTimer -= _blinkDuration;
				_noBullets.alpha = (_noBullets.alpha == 1) ? 0.8 : 1;
			}
		}
	}
}
