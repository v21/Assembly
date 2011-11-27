package v21.assembly
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author v21
	 */
	public class Main extends Sprite 
	{
		
		public var grid : Grid;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			makeGrid();
			
		}
		
		private function makeGrid() : void
		{
			grid = new Grid();
			grid.x = 50;
			grid.y = 50;
			addChild(grid);
		}
		
		
	}
	
}