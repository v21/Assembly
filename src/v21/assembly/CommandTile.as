package v21.assembly
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author v21
	 */
	public class  CommandTile extends Sprite
	{
		private static const size : Point = new Point(40, 40);
		
		public static var command : Command = Command.ADD;
		
		public var grid : Grid;
		
		public function CommandTile (grid : Grid) : void
		{
			this.grid = grid;
			graphics.lineStyle(5, 0x000000);
			graphics.drawRect(0, 0, size.x, size.y);
			drawCmd();
			addEventListener(MouseEvent.MOUSE_OVER, rollOver);
		}
		
		public function rollOver (mEvent : MouseEvent) : void 
		{
			grid.hoveredTile = null;
			grid.hoveredCmd = command;
		}
		
		public function drawCmd() : void 
		{
			var txt:TextField = new TextField(); 
			txt.text = command.symbol; 
			addChild(txt);
		}
		
	}
	
}