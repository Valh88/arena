package view;

import nape.dynamics.InteractionFilter;
import nape.callbacks.InteractionType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import states.GoGameState;
import flixel.util.FlxSpriteUtil;
import nape.callbacks.CbType;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.geom.Vec2;

class BulletView extends FlxSprite
{
	public static var BULLET_CBTYPE:CbType = new CbType();

	var _physicsBody:Body;

	var _speed:Float = 800;

	public function new(x:Float, y:Float, angle:Float)
	{
		super(x, y);

		// Графика пули (красный квадрат 5x5)
		makeGraphic(5, 5, FlxColor.BLACK);
		FlxSpriteUtil.drawCircle(this, x, y, 2.5, FlxColor.BLACK);

		_physicsBody = new Body(BodyType.DYNAMIC);
		_physicsBody.position.setxy(x, y);
		_physicsBody.shapes.add(new Circle(2.5));
		_physicsBody.cbTypes.add(BULLET_CBTYPE);
		_physicsBody.velocity = Vec2.fromPolar(_speed, angle * Math.PI / 180);
		_physicsBody.space = FlxNapeSpace.space;
		_physicsBody.userData.bullet = this;

		var bulletFilter = new InteractionFilter();
		bulletFilter.collisionGroup = 3;
		_physicsBody.shapes.at(0).filter = bulletFilter;
		FlxG.state.add(this);
		FlxG.watch.add(this, "x", "Bullet X");
		FlxG.watch.add(this, "y", "Bullet Y");

		_setupCollisionsBulletObstancles();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		x = _physicsBody.position.x - width / 2;
		y = _physicsBody.position.y - height / 2;

		if (!isOnScreen())
		{
			kill();
		}
	}

	override public function kill():Void
	{
		if (_physicsBody != null && _physicsBody.space != null)
		{
			_physicsBody.space = null;
		}
		super.kill();
	}

	function _setupCollisionsBulletObstancles()
	{
		var bulletObstaclesListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, BULLET_CBTYPE, GoGameState.OBSTACLE_CBTYPE,
			_onBulletObstancles);
		FlxNapeSpace.space.listeners.add(bulletObstaclesListener);
	}

	function _onBulletObstancles(cb:InteractionCallback)
	{
		var b:Body = cb.int1.castBody;
		b.userData.bullet.kill();
	}
}
