package models;

import models.WeaponModel;

class PlayerModel
{
	public var playerId:Int;
	public var hp:Int;
	public var weapon:WeaponModel;
	public var x:Float;
	public var y:Float;

	public function new(playerId:Int, weapon:WeaponModel, ?hp:Int = 100)
	{
		this.playerId = playerId;
		this.hp = hp;
		this.weapon = weapon;
	}

	public function shot()
	{
		weapon.shot();
	}

	public function damageFromPlayer(damage:Int, ?whoDamage:PlayerModel) 
	{
		hp -= damage;
	}
}
