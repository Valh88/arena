package models;

import service.SyncTime;
import models.WeaponModel;

class PlayerModel
{
	public var playerId:Int;
	public var hp:Int;
	public var weapon:WeaponModel;
	public var x:Float;
	public var y:Float;
	public var timestamp:Float;

	public function new(playerId:Int, weapon:WeaponModel, ?hp:Int = 100)
	{
		this.playerId = playerId;
		this.hp = hp;
		this.weapon = weapon;
		this.x = 1000;
		this.y = 1000;
	}

	public function shot()
	{
		weapon.shot();
	}

	public function damageFromPlayer(damage:Int, ?whoDamage:PlayerModel)
	{
		hp -= damage;
	}

	public function setAlpha(serverTimeStamp:Float)
	{
	}
}
