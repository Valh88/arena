package controllers;

import models.PlayerModel;
import models.WeaponModel;

class GoGameController
{
	public var mainPlayer:PlayerModel;
	public var players:Array<PlayerModel>;

	public function new()
	{
		var weapon = new WeaponModel("Ak", 10, 20, 200, 30);
		mainPlayer = new PlayerModel(1, weapon, 100);

		players = [];
	}

	public function addPlayer(player:PlayerModel)
	{
		// var weapon = new WeaponModel("Ak", 10, 20, 200, 30);
		// var player = new PlayerModel(1, weapon, 100);
		players.push(player);
	}
}
