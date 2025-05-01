package models;

class WeaponModel
{
	public var name:String;
	public var damageMin:Int;
	public var damageMax:Int;
	public var countBullets:Int;
	public var maxBulletInMagazine:Int;
	public var bulletInMagazine:Int;
	public var angle:Float;

	public function new(name:String, damageMin:Int, damageMax:Int, countBullets:Int, maxBulletInMagazine:Int)
	{
		this.name = name;
		this.damageMax = damageMax;
		this.damageMin = damageMin;
		this.countBullets = countBullets;
		this.maxBulletInMagazine = maxBulletInMagazine;
		this.bulletInMagazine = this.countBullets - this.maxBulletInMagazine;
		this.angle = 0;
	}

	public function shot()
	{
		bulletInMagazine - 1;
		if (bulletInMagazine == 0)
		{
			if (countBullets <= maxBulletInMagazine)
			{
				bulletInMagazine = countBullets;
				countBullets = 0;
			} else
			{
				bulletInMagazine = maxBulletInMagazine;
				countBullets -= maxBulletInMagazine;
			}
		}
	}

	public function generateDamage():Int
	{
		return damageMin + Math.floor(Math.random() * (damageMax - damageMin + 1));
	}

	public function destroy()
	{
	}
}
