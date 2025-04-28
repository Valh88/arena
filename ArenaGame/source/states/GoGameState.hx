package states;

import flixel.group.FlxGroup;
import controllers.GoGameController;
import view.PlayerView;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import controllers.StateController;
import flixel.FlxState;

class GoGameState extends FlxState
{
	var _stateController:StateController;
	var _goGameController:GoGameController;
	var _mainPlayerView:PlayerView;
	var _players:FlxGroup;

	public function new(stateController:StateController)
	{
		super();
		_stateController = stateController;
		_goGameController = new GoGameController();
	}

	override public function create():Void
	{
		super.create();

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

		_mainPlayerView = new PlayerView(_goGameController.mainPlayer, true);
		add(_mainPlayerView);

		_players = new FlxGroup();
		_addPlayers();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
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
}
