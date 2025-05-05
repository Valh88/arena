package service;

class SyncTime
{
	public static function getTime():Float
	{
		return Sys.time() * 1000;
	}

	public static function alpha(timeEventFromServer:Float):Float
	{
		return timeEventFromServer - getTime();
	}
}
