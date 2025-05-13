package service;

import haxe.Constraints.Function;
import haxe.Json;

class DataNet
{
	public static var onConnectFunc:Function;
	public static var connectNewPlayer:Function;
	public static var onDisconnectPlayer:Function;
	public static var shotFromPlayer:Function;

	public static function returnField(data:Dynamic):String
	{
		if (Reflect.hasField(data, "connect"))
		{
			return "connect";
		} else if (Reflect.hasField(data, "player"))
		{
			return "player";
		} else if (Reflect.hasField(data, "shot"))
		{
			return "shot";
		}
		return "error";
	}

	public static function toDynamic(data:String):Dynamic
	{
		return Json.parse(data);
	}

	public static function connectData(data:Dynamic)
	{
		if (onConnectFunc != null)
		{
			onConnectFunc(data.user);
		}
	}

	public static function parseData(data:String)
	{
		var obj = toDynamic(data);
		switch (returnField(obj))
		{
			case "connect":
				connectData(obj.connect);
			case "player":
				connectNewPlayer(obj.player);
			case "shot":
				shotFromPlayer(obj.shot);
			case _:
				trace(obj);
		}
	}

	public static function coordinatesData(playerId, x, y, angle):String
	{
		var data =
			{
				coordinates:
					{
						playerId: playerId,
						x: x,
						y: y,
						angle: angle,
						timestamp: Sys.time() * 1000,
					}
			};
		var jsonString = haxe.Json.stringify(data);
		return jsonString;
	}

	public static function shot(playerId:Int, x:Float, y:Float, angle:Float):String
	{
		var data =
			{
				shot:
					{
						playerId: playerId,
						x: x,
						y: y,
						angle: angle,
						timestamp: SyncTime.getTime()
					}
			};
		return haxe.Json.stringify(data);
	}
}
