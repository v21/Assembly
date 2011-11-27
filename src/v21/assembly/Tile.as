package v21.assembly
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author v21
	 */
	public class Tile extends Sprite 
	{
		public var data : int;
		public var location : int;
		
		public var contents : int;
		
		public var isCmd : Boolean;
		public var cmd : Command;
		
		public var previousData : int;
		
		public static const frameWidth : Number = 5;
		public static const size : Point = new Point(40, 40);
		
		private var mouseStartCoords : Point;
		
		public var grid : Grid;
		
		public var cursorOn : Boolean;
		
		
		public function Tile(grid : Grid, location : int, contents : int, settable : Boolean) : void
		{
			this.grid = grid;
			this.location = location;
			this.contents = contents;
			setFromContents();
			
			addEventListener(MouseEvent.MOUSE_OVER, rollOver);
			
			if (settable)
				addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			
			//redraw();
		}
		
		public function setData(data : int) : void 
		{
			this.contents = data;
			setFromContents();
		}
		
		public function incrementData() : void
		{
			this.contents = grid.wrapIndex(this.contents + 1);
			setFromContents();
		}
		
		public function setFromContents() : void
		{
			this.data = this.contents;
			if ( this.contents in Grid.cmdMap)
			{
				isCmd = true;
				this.cmd = Grid.cmdMap[this.contents];
			}
			else 
			{
				isCmd = false;
			}
		}
		
		public function redraw() : void 
		{
			graphics.clear();
			if (isCmd) 
				drawCmd();
			else 
				drawData();
			
			if (location in Grid.cmdMap || grid.tiles[grid.cursorPos] == this)
				drawSelectedBorder();
			else
				drawBorder();
		}
		public static function toXY(value : int) : UintPoint
		{
			value = (value + 10000) % 100;
			return new UintPoint(value / 10, value % 10);
		}
		
		public function drawBorder () : void
		{
			graphics.moveTo(0, frameWidth);
			graphics.lineStyle(frameWidth,ColorHSL.fromHSL(toXY(location).x / 10.0, 0.8, 0.5).int, 1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER );
			graphics.lineTo(0, size.y);
			graphics.lineTo(size.x, size.y);
			graphics.moveTo(size.x, size.y - frameWidth);
			graphics.lineStyle(frameWidth,ColorHSL.fromHSL(toXY(location).y / 10.0, 0.8, 0.5).int, 1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER );
			graphics.lineTo(size.x, 0);
			graphics.lineTo(0, 0);
		}
		
		public function drawHighlightedBorder() : void
		{
			graphics.lineStyle(5, 0xFFFFFF, 1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			graphics.drawRect(4, 4, size.x - 8, size.y - 8);
		}
		
		public function drawRemoteHighlightedBorder() : void
		{
			graphics.lineStyle(5, 0x000000, 1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			graphics.drawRect(4, 4, size.x - 8, size.y - 8);
		}
		
		public function drawSelectedBorder () : void
		{
			graphics.lineStyle(5, 0x000000, 1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			graphics.drawRect(0, 0, size.x, size.y);
		}
		public function drawData() : void
		{
			
			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(ColorHSL.fromHSL(toXY(data).x / 10.0, 0.8, 0.5).int);
			graphics.moveTo((frameWidth / 2), (frameWidth / 2));
			graphics.lineTo((frameWidth / 2), size.y - (frameWidth / 2));
			graphics.lineTo(size.x - (frameWidth / 2), size.y - (frameWidth / 2));
			graphics.endFill();
			
			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(ColorHSL.fromHSL(toXY(data).y / 10.0, 0.8, 0.5).int);
			graphics.moveTo(size.x - (frameWidth / 2), size.y - (frameWidth / 2));
			graphics.lineTo(size.x - (frameWidth / 2), (frameWidth / 2));
			graphics.lineTo((frameWidth / 2), (frameWidth / 2));
			graphics.endFill();
			
		}
		
		public function drawCmd() : void 
		{
			cmd.drawCommand(this);
		}
		

		
		public function rollOver (mEvent : MouseEvent) : void 
		{
			grid.hoveredTile = this;
			
		}
		
		public function onClick (mEvent:MouseEvent) : void
		{
			mouseStartCoords = new Point(mouseX, mouseY);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			previousData = data;
		}
		
		public function mouseMove( mEvent : MouseEvent) : void 
		{
			this.contents = grid.hoveredTile.location;
			setFromContents();
			redraw();
		}
		
		public function mouseUp (mEvent : MouseEvent) : void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
		}
	}
}