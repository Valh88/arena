package view;

import models.PlayerModel;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PlayerView extends FlxSpriteGroup
{
	var _mainPlayer:Bool;
	var _playerModel:PlayerModel;
	var _speed:Float = 600;
	var _targetVelocity:FlxPoint = FlxPoint.get();
	var _lerpFactor:Float = 0.3;
	var _body:FlxSprite;
	var _weapon:FlxSprite;
	var _weaponLength:Float = 30;
	var _bodyRadius:Float = 20;

	var _targetWeaponAngle:Float = 0;
	var _weaponRotationLerpFactor:Float = 0.1;

	var _moveToTarget:FlxPoint;
	var _moveToThreshold:Float = 5;

	public function new(playerModel:PlayerModel, ?mainPlayer:Bool = false)
	{
		super();
		_playerModel = playerModel;
		_mainPlayer = mainPlayer;
		x = FlxG.width / 2 - _bodyRadius;
		y = FlxG.height / 2 - _bodyRadius;

		_body = new FlxSprite(0, 0);
		_body.makeGraphic(Std.int(_bodyRadius * 2), Std.int(_bodyRadius * 2), FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawCircle(_body, _bodyRadius, _bodyRadius, _bodyRadius, FlxColor.BLUE);
		add(_body);

		_weapon = new FlxSprite(_bodyRadius - _weaponLength / 4, _bodyRadius);
		_weapon.makeGraphic(Std.int(_weaponLength) + 10, 5, FlxColor.BROWN);
		_weapon.origin.set(_weaponLength / 4, 2.5);
		FlxSpriteUtil.drawRect(_weapon, _weaponLength - 10, 0, 20, 5, FlxColor.GRAY);
		add(_weapon);

		drag.set(_speed * 8, _speed * 8);
		maxVelocity.set(_speed, _speed);

		if (_mainPlayer)
		{
			FlxG.camera.follow(this, LOCKON, 1);
			FlxG.camera.followLead.set(0, 0);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (_mainPlayer)
		{
			updateMovement();
		} else
		{
			updateMoveToTarget();
		}
		updateWeaponRotation();
		applySmoothMovement(elapsed);
		applySmoothWeaponRotation(elapsed);
	}

	function updateMovement():Void
	{
		_targetVelocity.set(0, 0);

		if (FlxG.keys.anyPressed([UP, W]))
			_targetVelocity.y = -_speed;
		if (FlxG.keys.anyPressed([DOWN, S]))
			_targetVelocity.y = _speed;
		if (FlxG.keys.anyPressed([LEFT, A]))
			_targetVelocity.x = -_speed;
		if (FlxG.keys.anyPressed([RIGHT, D]))
			_targetVelocity.x = _speed;

		if (_targetVelocity.x != 0 && _targetVelocity.y != 0)
		{
			_targetVelocity.scale(0.7071);
		}

		if (_moveToTarget != null)
		{
			updateMoveToTarget();
		}
	}

	function applySmoothMovement(elapsed:Float):Void
	{
		velocity.x = FlxMath.lerp(velocity.x, _targetVelocity.x, _lerpFactor);
		velocity.y = FlxMath.lerp(velocity.y, _targetVelocity.y, _lerpFactor);

		x = FlxMath.bound(x, FlxG.worldBounds.x, FlxG.worldBounds.width - width);
		y = FlxMath.bound(y, FlxG.worldBounds.y, FlxG.worldBounds.height - height);
	}

	function updateWeaponRotation():Void
	{
		if (_mainPlayer)
		{
			var mousePos = FlxG.mouse.getWorldPosition(FlxG.camera);
			var dx = mousePos.x - (x + _bodyRadius);
			var dy = mousePos.y - (y + _bodyRadius);

			_targetWeaponAngle = Math.atan2(dy, dx) * 180 / Math.PI;
		}
		if (velocity.length > 0)
		{
			_weapon.offset.y = Math.sin(FlxG.game.ticks * 0.1) * 2;
		} else
		{
			_weapon.offset.y = 0;
		}
	}

	function applySmoothWeaponRotation(elapsed:Float):Void
	{
		_weapon.angle = FlxMath.lerp(_weapon.angle, _targetWeaponAngle, _weaponRotationLerpFactor);

		if (Math.abs(_weapon.angle - _targetWeaponAngle) > 180)
		{
			if (_targetWeaponAngle < _weapon.angle)
			{
				_weapon.angle = FlxMath.lerp(_weapon.angle - 360, _targetWeaponAngle, _weaponRotationLerpFactor);
			} else
			{
				_weapon.angle = FlxMath.lerp(_weapon.angle + 360, _targetWeaponAngle, _weaponRotationLerpFactor);
			}
		}
	}

	public function getWeaponTip():FlxPoint
	{
		var angleRad = _weapon.angle * FlxAngle.TO_RAD;
		var tip = FlxPoint.get();
		tip.x = x + _bodyRadius + Math.cos(angleRad) * (_weaponLength * 0.75);
		tip.y = y + _bodyRadius + Math.sin(angleRad) * (_weaponLength * 0.75);
		return tip;
	}

	public function moveToPoint(targetX:Float, targetY:Float, ?angle:Float):Void
	{
		if (_moveToTarget == null)
		{
			_moveToTarget = FlxPoint.get();
		}
		_moveToTarget.set(targetX, targetY);
		if (angle != null)
		{
			_targetWeaponAngle = angle;
		}
	}

	/**
	 * Прекращает движение к точке
	 */
	public function stopMovingToPoint():Void
	{
		_moveToTarget = null;
		_targetVelocity.set(0, 0);
	}

	function updateMoveToTarget():Void
	{
		if (_moveToTarget != null)
		{
			var dx = _moveToTarget.x - (x + _bodyRadius);
			var dy = _moveToTarget.y - (y + _bodyRadius);
			var distance = Math.sqrt(dx * dx + dy * dy);

			if (distance > _moveToThreshold)
			{
				_targetVelocity.set(_speed * dx / distance, _speed * dy / distance);
			} else
			{
				// Достигли цели
				_targetVelocity.set(0, 0);
				_moveToTarget = null; // Сбрасываем точку назначения
			}
		}
	}

	override public function destroy():Void
	{
		super.destroy();
		_targetVelocity.put();
	}
}
