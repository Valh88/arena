package models;

class WeaponModel
{
	public var name:String;
	public var damageMin:Int;
	public var damageMax:Int;
	public var countBullets:Int;
	public var maxBulletInMagazine:Int;
	public var bulletInMagazine:Int;

	public function new(name:String, damageMin:Int, damageMax:Int, countBullets:Int, maxBulletInMagazine:Int)
	{
		this.name = name;
		this.damageMax = damageMax;
		this.damageMin = damageMin;
		this.countBullets = countBullets;
		this.maxBulletInMagazine = maxBulletInMagazine;
		this.bulletInMagazine = this.countBullets - this.maxBulletInMagazine;
	}
}
