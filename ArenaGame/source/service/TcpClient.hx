package service;

import sys.net.Socket;
import sys.net.Host;
import haxe.io.Error;
import haxe.io.Bytes;
import StringTools;
import service.DataNet;

class TcpClient
{
	private var socket:Socket;
	private var host:String;
	private var port:Int;
	private var buffer:String;
	private var connected:Bool;
	private var connecting:Bool;

	public function new(host:String, port:Int)
	{
		this.host = host;
		this.port = port;
		this.buffer = "";
		this.connected = false;
		this.connecting = false;

		initializeSocket();
	}

	private function initializeSocket()
	{
		socket = new Socket();
		socket.setBlocking(false);

		try
		{
			connecting = true;
			socket.connect(new Host(host), port);
		} catch (e:Dynamic)
		{
			
		}
	}

	public function update()
	{
		if (socket == null)
			return;


		if (!connected && connecting)
		{
			checkConnection();
			if (!connected)
				return;
		}


		readAvailableData();
	}

	private function checkConnection()
	{
		try
		{
			socket.output.writeByte(0);
			connected = true;
			connecting = false;
			trace('Successfully connected to $host:$port');
		} catch (e:Dynamic)
		{
			if (e == Error.Blocked)
			{
			} else
			{
				trace('Connection failed: $e');
				close();
			}
		}
	}

	private function readAvailableData()
	{
		if (!connected)
			return;

		try
		{
			while (true)
			{
				var byte = socket.input.readByte();
				buffer += String.fromCharCode(byte);

				if (byte == '\n'.code)
				{
					processCompleteLine();
				}
			}
		} catch (e:Dynamic)
		{
			if (e == Error.Blocked)
			{
				// all ok
			} else
			{
				trace('Read error: $e');
				close();
			}
		}
	}

	private function processCompleteLine()
	{
		var line = StringTools.trim(buffer);
		buffer = "";

		if (line.length > 0)
		{
			onDataReceived(line);
		}
	}

	public dynamic function onDataReceived(data:String)
	{
		// trace('Received: $data');
		DataNet.parseData(data);
	}

	public function send(data:String):Bool
	{
		if (!connected || socket == null)
			return false;

		try
		{
			socket.output.writeString(data + "\n");
			return true;
		} catch (e:Dynamic)
		{
			trace('Send error: $e');
			close();
			return false;
		}
	}

	public function close()
	{
		if (socket != null)
		{
			try
			{
				socket.close();
			} catch (e:Dynamic)
			{
			}
			socket = null;
		}
		connected = false;
		connecting = false;
	}

	public function isConnected():Bool
	{
		return connected;
	}
}
