package controllers;

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

	public function new()
	{
		var weapon = new WeaponModel("Ak", 10, 20, 200, 30);
		mainPlayer = new PlayerModel(1, weapon, 100);
		mainPlayer.x = 1000;
		mainPlayer.y = 1000;

		players = [];

		socket = new TcpClient("localhost", 1234);
		timeUpdate = 0.1;
		currentTime = 0;

		elapsed = 0;
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
		if (currentTime>= timeUpdate)
		{
			var data = DataNet.coordinatesData(mainPlayer.playerId,mainPlayer.x, mainPlayer.y, mainPlayer.weapon.angle);
			socket.send(data);
		}
	}

	public function addPlayer(player:PlayerModel)
	{
		// var weapon = new WeaponModel("Ak", 10, 20, 200, 30);
		// var player = new PlayerModel(1, weapon, 100);
		players.push(player);
	}
	
	public function damageToPlayer(player:PlayerModel, anotherPlayer:PlayerModel) 
	{
		var damage = player.weapon.generateDamage();
		anotherPlayer.damageFromPlayer(damage);
	}
	public function print() 
	{
		trace(mainPlayer.x);
		trace(mainPlayer.y);
		trace(mainPlayer.weapon.angle);	
	}
}
