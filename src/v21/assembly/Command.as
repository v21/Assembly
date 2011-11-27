package v21.assembly
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author v21
	 */
	public class  Command
	{
		public static const ADD : String = "ADD";
		public static const JMP : String = "JMP";
		public static const JMPLESS : String = "JMPLESS";
		public static const WRITE : String = "WRITE";
		public static const READ : String = "READ";
		public static const SPEED : String = "SPEED";
		public static const INC : String = "INC";
		public static const TRANS : String = "TRANS";
		
		
		public var type : String = "WRITE";
		
		public function Command() : void
		{
			
		}
		
		
		public function drawCommand(sprite : Sprite) : void
		{
			var white : uint = 0xFFFFFF;
			var lightgrey : uint = 0xC8C8C8;
			var medgrey : uint = 0x7F7F7F;
			var darkgrey : uint = 0x414141;
			var black : uint = 0x000000;
			
			var col1 : uint = 0x400040;
			var col2 : uint = 0x400040;
			if (type == Command.WRITE)
			{
				col1 = white;
				col2 = medgrey;
			}
			else if (type == Command.ADD)
			{
				col1 = lightgrey;
				col2 = black;
			}
			else if (type == Command.JMP)
			{
				col1 = medgrey;
				col2 = lightgrey;
			}
			else if (type == Command.JMPLESS)
			{
				col1 = lightgrey;
				col2 = medgrey;
			}
			else if (type == Command.READ)
			{
				col1 = black;
				col2 = white;
			}
			else if (type == Command.SPEED)
			{
				col1 = lightgrey;
				col2 = white;
			}
			else if (type == Command.INC)
			{
				col1 = black;
				col2 = black;
			}
			else if (type == Command.TRANS)
			{
				col1 = medgrey;
				col2 = black;
			}
			sprite.graphics.lineStyle(0, 0, 0);
			sprite.graphics.beginFill(col1);
			sprite.graphics.moveTo(Tile.size.x - (Tile.frameWidth / 2), (Tile.frameWidth / 2));
			sprite.graphics.lineTo((Tile.frameWidth / 2), Tile.size.y - (Tile.frameWidth / 2));
			sprite.graphics.lineTo(Tile.size.x - (Tile.frameWidth / 2), Tile.size.y - (Tile.frameWidth / 2));
			sprite.graphics.endFill();
			
			sprite.graphics.lineStyle(0, 0 , 0);
			sprite.graphics.beginFill(col2);
			sprite.graphics.moveTo(Tile.size.x - (Tile.frameWidth / 2), (Tile.frameWidth / 2));
			sprite.graphics.lineTo((Tile.frameWidth / 2), Tile.size.y - (Tile.frameWidth / 2));
			sprite.graphics.lineTo((Tile.frameWidth / 2), (Tile.frameWidth / 2));
			sprite.graphics.endFill();

			
		}
		
	}
	
}