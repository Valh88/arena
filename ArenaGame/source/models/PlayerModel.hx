package models;

import models.WeaponModel;

class PlayerModel
{
	public var playerId:Int;
	public var hp:Int;
	public var weapon:WeaponModel;

	public function new(playerId:Int, weapon:WeaponModel, ?hp:Int = 100)
	{
		this.playerId = playerId;
		this.hp = hp;
	}
}
