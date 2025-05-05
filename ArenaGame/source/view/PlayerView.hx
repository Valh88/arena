package view;

import flixel.util.FlxTimer;
import nape.geom.Vec2;
import nape.shape.Circle;
import nape.dynamics.InteractionFilter;
import flixel.addons.nape.FlxNapeSpace;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.callbacks.CbType;
import nape.phys.Body;
import models.PlayerModel;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PlayerView extends FlxSpriteGroup
{
	public static var PLAYER_CBTYPE:CbType = new CbType();

	var _mainPlayer:Bool;

	public var playerModel:PlayerModel;

	var _speed:Float = 600;
	var _targetVelocity:FlxPoint = FlxPoint.get();
	var _lerpFactor:Float = 0.3;
	var _lerpFactorOnline = 0.2;
	var _body:FlxSprite;
	var _weapon:FlxSprite;
	var _weaponLength:Float = 30;
	var _bodyRadius:Float = 20;

	var _targetWeaponAngle:Float = 0;
	var _weaponRotationLerpFactor:Float = 0.1;

	var _moveToTarget:FlxPoint;
	var _moveToThreshold:Float = 5;

	var _physicsBody:Body;

	var _canShoot:Bool = true;
	var _shootCooldown:Float = 0.2;

	public function new(playerModel:PlayerModel, ?mainPlayer:Bool = false)
	{
		super();
		// FlxG.mouse.useSystemCursor = true;
		this.playerModel = playerModel;
		_mainPlayer = mainPlayer;
		x = playerModel.x;
		y = playerModel.y;
		_targetWeaponAngle = playerModel.weapon.angle;

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

		_createPhysicsBody();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var halfWidth = width * 0.5;
		var halfHeight = height * 0.5;
		if (_physicsBody.position.x < FlxG.worldBounds.x + halfWidth)
			_physicsBody.position.x = FlxG.worldBounds.x + halfWidth;
		if (_physicsBody.position.y < FlxG.worldBounds.y + halfHeight)
			_physicsBody.position.y = FlxG.worldBounds.y + halfHeight;
		if (_physicsBody.position.x > FlxG.worldBounds.right - halfWidth)
			_physicsBody.position.x = FlxG.worldBounds.right - halfWidth;
		if (_physicsBody.position.y > FlxG.worldBounds.bottom - halfHeight)
			_physicsBody.position.y = FlxG.worldBounds.bottom - halfHeight;

		if (_mainPlayer)
		{
			x = playerModel.x;
			y = playerModel.y;

			playerModel.x = _physicsBody.position.x - _bodyRadius;
			playerModel.y = _physicsBody.position.y - _bodyRadius;
			playerModel.weapon.angle = _targetWeaponAngle;
			_updateMovement();
		} else
		{
			_targetWeaponAngle = playerModel.weapon.angle;

			var targetX = playerModel.x;
			var targetY = playerModel.y;

			x = FlxMath.lerp(x, targetX, _lerpFactorOnline);
			y = FlxMath.lerp(y, targetY, _lerpFactorOnline);

			_physicsBody.position.setxy(x + _bodyRadius, y + _bodyRadius);
			updateMoveToTarget();
		}
		updateWeaponRotation();
		applySmoothMovement(elapsed);
		applySmoothWeaponRotation(elapsed);

		if (_mainPlayer && FlxG.mouse.pressed)
		{
			shoot();
		}
	}

	function _updateMovement():Void
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
	}

	function applySmoothMovement(elapsed:Float):Void
	{
		if (_mainPlayer)
		{
			var velocityDiff = new Vec2(_targetVelocity.x - _physicsBody.velocity.x, _targetVelocity.y - _physicsBody.velocity.y);

			var force = velocityDiff.mul(_physicsBody.mass * 5.0);
			_physicsBody.force = force;
		}
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
		tip.x = x + _bodyRadius + Math.cos(angleRad) * (_weaponLength);
		tip.y = y + _bodyRadius + Math.sin(angleRad) * (_weaponLength);
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
				_targetVelocity.set(0, 0);
				_moveToTarget = null;
			}
		}
	}

	public function shoot():Void
	{
		if (!_canShoot || !_mainPlayer)
			return;

		var weaponTip = getWeaponTip();
		var bullet = new BulletView(weaponTip.x, weaponTip.y, _weapon.angle, playerModel.playerId);

		_canShoot = false;
		new FlxTimer().start(_shootCooldown, function(timer:FlxTimer)
		{
			_canShoot = true;
		});
	}

	function _createPhysicsBody()
	{
		_physicsBody = new Body(BodyType.DYNAMIC);
		_physicsBody.position.setxy(x + _bodyRadius, y + _bodyRadius);
		_physicsBody.shapes.add(new Circle(_bodyRadius));
		_physicsBody.space = FlxNapeSpace.space;
		_physicsBody.cbTypes.add(PLAYER_CBTYPE);
		var playerFilter = new InteractionFilter();
		playerFilter.collisionGroup = 2;
		_physicsBody.shapes.at(0).filter = playerFilter;
		_physicsBody.userData.player = this;
	}

	override public function destroy():Void
	{
		super.destroy();
		_targetVelocity.put();
	}
}
