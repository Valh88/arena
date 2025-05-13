package controllers;

import view.ui.Hud;
import openfl.events.DataEvent;
import service.SyncTime;
import view.BulletView;
import view.PlayerView;
import haxe.Constraints.Function;
import service.DataNet;
import models.PlayerModel;
import models.WeaponModel;
import service.TcpClient;

class GoGameController
{
	public var socket:TcpClient;
	public var timeUpdate:Float;
	public var currentTime:Float;

	public var mainPlayer:PlayerModel;
	public var players:Array<PlayerModel>;

	public var elapsed:Float;

	public var addViewAnotherPlayer:Function;
	public var spawnBulletFromPlayer:Function;

	public var hud:Hud;

	public function new()
	{
		var weapon = new WeaponModel("Ak", 10, 20, 60, 20);
		mainPlayer = new PlayerModel(1, weapon, 100);
		mainPlayer.x = 1000;
		mainPlayer.y = 1000;
		mainPlayer.mainController = this;
		players = [];

		socket = new TcpClient("localhost", 1235);
		// timeUpdate = 0.1;
		timeUpdate = 0.0476;
		currentTime = 0;

		elapsed = 0;

		DataNet.onConnectFunc = connectMainPlayer;
		DataNet.connectNewPlayer = broadcastUserCoordinates;
		DataNet.shotFromPlayer = spawnBullet;
	}

	public function update(elapsed:Float)
	{
		this.elapsed = elapsed;
		socket.update();
		sendCoordinates();
	}

	public function sendCoordinates()
	{
		currentTime += elapsed;
		if (currentTime >= timeUpdate)
		{
			currentTime = 0;
			var data = DataNet.coordinatesData(mainPlayer.playerId, mainPlayer.x, mainPlayer.y, mainPlayer.weapon.angle);
			socket.send(data);
		}
	}

	public function connectMainPlayer(userId)
	{
		mainPlayer.playerId = userId;
	}

	public function broadcastUserCoordinates(user)
	{
		var exist = false;
		for (player in players)
		{
			if (player.playerId == user.playerId)
			{
				player.x = user.x;
				player.y = user.y;
				player.weapon.angle = user.angle;
				player.timestamp = user.timestamp;
				exist = true;
			}
		}
		if (!exist)
		{
			var weapon = new WeaponModel("Ak", 10, 20, 200, 30);
			var model = new PlayerModel(user.playerId, weapon, 100);
			players.push(model);
			addViewAnotherPlayer(model);
		}
	}

	public function addPlayer(player:PlayerModel)
	{
		players.push(player);
	}

	public function damageToPlayer(player:PlayerModel, anotherPlayer:PlayerModel)
	{
		var damage = player.weapon.generateDamage();
		anotherPlayer.damageFromPlayer(damage);
	}

	public function sendShot(bullet:BulletView, weaponAngle:Float)
	{
		mainPlayer.weapon.shot();
		hud.updateHudWeaponBullets();

		var data = DataNet.shot(bullet.playerId, bullet.x, bullet.y, weaponAngle);
		socket.send(data);
	}

	public function spawnBullet(data:Dynamic)
	{
		spawnBulletFromPlayer(data);
	}

	public function print()
	{
		trace(mainPlayer.x);
		trace(mainPlayer.y);
		trace(mainPlayer.weapon.angle);
		trace(players);
	}
}
