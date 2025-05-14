package states;

import service.Sounds;
import view.TreeView;
import view.ui.Hud;
import view.BulletView;
import flixel.FlxBasic;
import models.PlayerModel;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionListener;
import flixel.util.FlxColor;
import nape.callbacks.CbType;
import flixel.FlxSprite;
import nape.dynamics.InteractionFilter;
import nape.shape.Polygon;
import nape.phys.BodyType;
import nape.phys.Body;
import flixel.addons.nape.FlxNapeSpace;
import flixel.group.FlxGroup;
import controllers.GoGameController;
import view.PlayerView;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import controllers.StateController;
import flixel.FlxState;

class GoGameState extends FlxState
{
	public static var OBSTACLE_CBTYPE:CbType = new CbType();

	var _stateController:StateController;
	var _goGameController:GoGameController;
	var _mainPlayerView:PlayerView;
	var _players:FlxGroup;
	var _obstacles:FlxGroup;

	public function new(stateController:StateController)
	{
		super();
		_stateController = stateController;
		_goGameController = new GoGameController();
	}

	override public function create():Void
	{
		super.create();
		Sounds.init();
		FlxNapeSpace.init();
		FlxNapeSpace.drawDebug = true;
		FlxG.autoPause = false;
		final levelMinX = 0;
		final levelMaxX = 2000;
		final levelMinY = 0;
		final levelMaxY = 2000;
		final levelWidth = levelMaxX - levelMinX;
		final levelHeight = levelMaxY - levelMinY;

		FlxG.camera.setScrollBounds(levelMinX, levelMaxX, levelMinY, levelMaxY);
		FlxG.worldBounds.set(levelMinX, levelMinY, levelWidth, levelHeight);
		FlxG.mouse.visible = true;

		var bg = new FlxBackdrop("assets/images/grass_green.png");
		add(bg);

		_goGameController.addViewAnotherPlayer = this.addOrUpdatePlayer;
		_goGameController.spawnBulletFromPlayer = this.spawnBulletFromPlayer;
		_goGameController.deletePlayerView = this.deletePlayer;
		
		_mainPlayerView = new PlayerView(_goGameController.mainPlayer, true);
		add(_mainPlayerView);

		_players = new FlxGroup();
		_addPlayers();

		_obstacles = new FlxGroup();
		_createObstacle(300, 200, 100, 30);
		_createObstacle(200, 300, 30, 100);
		_createObstacle(500, 600, 80, 80);
		_createObstacle(1200, 400, 400, 100);
		_createObstacle(700, 1500, 80, 150);
		_createObstacle(1500, 350, 100, 30);
		_createObstacle(800, 300, 80, 80);
		_createObstacle(700, 1350, 100, 30);
		add(_obstacles);

		_setupCollisionsObstanclePlayers();

		var tree = new TreeView(FlxG.width / 2 - 10, FlxG.height / 2 - 50);
		add(tree);
		
		var hud = new Hud(_goGameController.mainPlayer);
		add(hud);
		_goGameController.hud = hud;

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_goGameController.update(elapsed);
	}

	public function addOrUpdatePlayer(model:PlayerModel)
	{
		var found = false;
		_players.forEach(function(player:FlxBasic)
		{
			var pl:PlayerView = cast player;
			if (model.playerId == pl.playerModel.playerId)
			{
				pl.playerModel.x = model.x;
				pl.playerModel.y - model.y;
				pl.playerModel.weapon.angle = model.weapon.angle;
				found = true;
			}
		});
		if (!found)
		{
			var view = new PlayerView(model);
			_players.add(view);
		}
	}

	public function deletePlayer(model:PlayerModel) 
	{
		var found = false;
		_players.forEach(function(player:FlxBasic)
		{
			var pl:PlayerView = cast player;
			if (model.playerId == pl.playerModel.playerId)
			{
				_players.remove(player);
				found = true;
			}
		});
	}

	function _addPlayers()
	{
		if (_goGameController.players != null)
		{
			for (player in _goGameController.players)
			{
				var newPlayer = new PlayerView(player);
				_players.add(newPlayer);
			}

			add(_players);
		}
	}

	public function spawnBulletFromPlayer(data:Dynamic)
	{
		if (data.playerId != _mainPlayerView.playerModel.playerId)
		{
			var bullet = new BulletView(data.x, data.y, data.angle, data.playerId);
		}
	}

	function _createObstacle(x:Float, y:Float, width:Float, height:Float):Void
	{
		var body = new Body(BodyType.STATIC);
		body.position.setxy(x, y);

		var shape = new Polygon(Polygon.rect(0, 0, width, height));

		var obstacleFilter = new InteractionFilter();
		obstacleFilter.collisionGroup = 1;
		// obstacleFilter.collisionMask = ~0x0004; // Игнорируем прицел

		shape.filter = obstacleFilter;
		body.shapes.add(shape);
		body.cbTypes.add(OBSTACLE_CBTYPE);
		body.space = FlxNapeSpace.space;
		var obstacle = new FlxSprite(x, y);
		obstacle.makeGraphic(Std.int(width), Std.int(height), FlxColor.BROWN);
		body.userData.opstacle = obstacle;
		_obstacles.add(obstacle);
	}

	function _setupCollisionsObstanclePlayers()
	{
		var playerObstaclesListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, OBSTACLE_CBTYPE, PlayerView.PLAYER_CBTYPE,
			_onPlayerObstacles);
		FlxNapeSpace.space.listeners.add(playerObstaclesListener);
	}

	function _onPlayerObstacles(cb:InteractionCallback)
	{
		var b:Body = cb.int1.castBody;
		// trace(b);
	}
}
