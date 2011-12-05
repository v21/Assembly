package v21.assembly
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent; 
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import org.flashdevelop.utils.FlashConnect;
	
	
	/**
	 * ...
	 * @author v21
	 */
	public class  Grid extends Sprite
	{
		
		private static const size : Point = new Point(40, 40);
		public var tiles : Vector.<Tile> = new Vector.<Tile>;
		
		public var hoveredTile : Tile;
		public var hoveredCmd : Command;
		
		public var cursorPos : uint = 0;
		private var cursorTimer : Timer;
		
		public var earliestArgPos : uint;
		
		public static var cmdMap : Array = new Array();
		
		public function Grid () : void
		{
			
			cmdMap[100] = new Command();
			(cmdMap[100] as Command).type = Command.ADD;
			
			cmdMap[101] = new Command();
			(cmdMap[101] as Command).type = Command.WRITE;
			
			cmdMap[102] = new Command();
			(cmdMap[102] as Command).type = Command.SPEED;
			
			cmdMap[103] = new Command();
			(cmdMap[103] as Command).type = Command.JMP;
			
			cmdMap[104] = new Command();
			(cmdMap[104] as Command).type = Command.READ;
			
			cmdMap[105] = new Command();
			(cmdMap[105] as Command).type = Command.JMPLESS;
			
			cmdMap[106] = new Command();
			(cmdMap[106] as Command).type = Command.INC;
			
			cmdMap[107] = new Command();
			(cmdMap[107] as Command).type = Command.TRANS;
			
			
			if (!ExternalInterface.available) {
				generateGrid();
				
				redrawAll();
				
				cursorTimer = new Timer(700, 1); 
				cursorTimer.addEventListener(TimerEvent.TIMER, incCursor);
				cursorTimer.start();
			}
			else 
			{
				Security.allowDomain("nottheinternet.com");
				ExternalInterface.addCallback("onURLFetch", onURLFetch);
				ExternalInterface.call("eval", "document.getElementById('Assembly').onURLFetch(window.location.hash);");
			}
			
			
			
			//stringToTiles("01|01|01|65|11|43|94|36|89|50|23|75|61|1|34|67|87|55|25|32|20|22|69|80|10|6|65|32|63|2|84|83|55|90|7|34|89|66|72|77|95|22|60|50|29|81|39|12|47|73|9|91|84|93|96|20|56|64|74|98|86|2|84|53|27|5|98|27|28|41|30|9|93|62|57|48|65|99|85|26|81|13|24|70|1|79|75|46|29|31|1|7|31|13|56|62|85|8|91|51|100|101|102|103|104|105|106|107|");

			
		}
		
		public function onURLFetch (hash : String) : void 
		{
			if (hash.length > 0) {
				stringToTiles(hash);
			}
			else {
				generateGrid();

			}
			
			redrawAll();
			
			cursorTimer = new Timer(700, 1); 
			cursorTimer.addEventListener(TimerEvent.TIMER, incCursor);
			cursorTimer.start();
		}
		
		public function generateGrid() : void 
		{
			for (var i:int = 0; i < 10; i++) 
			{
				for (var j:int = 0; j < 10; j++) 
				{
					
			
				//data = Math.floor(Math.random() * 100);
				//data = (location % 10) * 10 + Math.floor(location / 10);
					var tile: Tile = new Tile(this, i * 10 +  j, Math.floor(Math.random() * 100) , true);
					addChild(tile);
					tile.x = i * 50;
					tile.y = j * 50;
					tiles.push(tile);
				}
				
			}
			
			var commandTileY : uint = 0;
			
			for (var index : * in cmdMap)
			{
				
				var commandTile : Tile = new Tile(this, index, index, false);
				addChild(commandTile);
				commandTile.y = commandTileY;
				commandTileY += 50;
				commandTile.x = 600;
				tiles.push(commandTile);
			}
		}
		
		public function populateGrid( tileVals : Vector.<int>) : void 
		{
			for (var i:int = 0; i < 10; i++) 
			{
				for (var j:int = 0; j < 10; j++) 
				{
					
			
				//data = Math.floor(Math.random() * 100);
				//data = (location % 10) * 10 + Math.floor(location / 10);
					var tile: Tile = new Tile(this, i * 10 +  j, tileVals[i * 10 +  j] , true);
					addChild(tile);
					tile.x = i * 50;
					tile.y = j * 50;
					tiles.push(tile);
				}
				
			}
			
			var commandTileY : uint = 0;
			
			for (var k:int = 100; k < cmdMap.length; k++) 
			{
				var commandTile : Tile = new Tile(this, k, tileVals[k], false);
				addChild(commandTile);
				commandTile.y = commandTileY;
				commandTileY += 50;
				commandTile.x = 600;
				tiles.push(commandTile);
			}
		}
		
		public function incCursor(e : TimerEvent) : void
		{
			if (cursorPos == 99) {
				cursorPos = 0;
			}
			else {
				cursorPos = wrapIndex(cursorPos + 1);
			}
			redrawAll();
			if (tiles[cursorPos].isCmd) 
			{
				runCmdImmediate(cursorPos);
			}
			else {
				cursorTimer.reset();
				cursorTimer.start();
			}
			tilesToAddressbar();
		}
		
		public function runCmdImmediate (pos : uint) : void //here we execute stuff that shouldn't get executed if we recurse onto it. like a jump shouldn't get performed if it's not the first command that gets hit.
		{
			if (tiles[pos].cmd.type == Command.JMP) 
			{
				var newLoc : int = wrapIndex(getArgument(pos - 1).data);
				cursorPos = wrapIndex(newLoc - 1); //so that when we next increment, we actually execute the jump location's possible commands
				tiles[newLoc].drawSelectedBorder();
				trace("JMP" + cursorPos);
				
				cursorTimer.reset();
				cursorTimer.start();
			}
			else if (tiles[pos].cmd.type == Command.JMPLESS) 
			{
				var prev1 : int = wrapIndex(getArgument(pos - 1).data); //side-effects ahoy : sets earliestArgPos
				var prev2 : int = wrapIndex(getArgument(earliestArgPos - 1).data);
				
				var smaller : int;
				if (prev1 > prev2)
					smaller = prev1;
				else
					smaller = prev2;
				
				tiles[smaller].drawSelectedBorder();
				cursorPos = wrapIndex(smaller - 1); //so that when we next increment, we actually execute the jump location's possible commands
				trace("JMPLESS" + smaller);
				cursorTimer.reset();
				cursorTimer.start();
			}
			else if (tiles[pos].cmd.type == Command.INC) 
			{
				var arg1 : int = wrapIndex(getArgument(pos - 1).data);
				tiles[arg1].drawRemoteHighlightedBorder();
				tiles[arg1].incrementData();
				
				trace("INC" + cursorPos);
				
				cursorTimer.reset();
				cursorTimer.start();
			}
			else if (tiles[pos].cmd.type == Command.WRITE) 
			{
				
				var arg1 : int = getArgument(pos - 1).data; //side-effects ahoy : sets earliestArgPos
				var arg2 : int = wrapIndex(getArgument(earliestArgPos - 1).data);
				
				var targetTile : Tile = tiles[arg2];
				targetTile.setData(arg1);
				targetTile.drawRemoteHighlightedBorder();
				trace("WRITE " + targetTile.data + " to " + targetTile.location);
				
				cursorTimer.reset();
				cursorTimer.start();
			}
			
			else if (tiles[pos].cmd.type == Command.SPEED)
			{
				cursorTimer = new Timer(getArgument(pos - 1).data * 50, 1); 
				cursorTimer.addEventListener(TimerEvent.TIMER, incCursor);
				cursorTimer.start();
				
				trace("SPEED to " + getArgument(pos - 1).data * 20 + " ms");
			}
			else 
			{
				runCmd(pos);
			}
		}
		
		
		public function runCmd(pos : int) : void
		{
			
			if (tiles[pos].cmd.type == Command.ADD) 
			{	
				var arg1 : int = getArgument(pos - 1).data; //side-effects ahoy : sets earliestArgPos
				var arg2 : int = getArgument(earliestArgPos - 1).data;
				tiles[pos].data = wrapIndex(arg1 + arg2);
				trace("ADD " + tiles[pos].data);
			}
			else if (tiles[pos].cmd.type == Command.READ) 
			{
				var targetTile : Tile = tiles[getArgument(pos - 1).data];
				targetTile.drawRemoteHighlightedBorder();
				tiles[pos].data = targetTile.data;
				trace("READ " + targetTile.data + " from " + targetTile.location);
				
			}
			else if (tiles[pos].cmd.type == Command.TRANS)
			{
				var data : int =  getArgument(pos - 1).data;
				tiles[pos].data = wrapIndex((data % 10) * 10 + Math.floor(data / 10));
				trace("TRANS " + data);
			}
			else { //if this cmd is an immediate case, like most, ignore them and go further back.
				tiles[pos].drawBorder(); //unhighlight
				trace("unhighlighting");
				tiles[pos].data = getArgument(pos - 1).data;
			}
			
			cursorTimer.reset();
			cursorTimer.start();
		}
		
		public function wrapIndex (pos : int) : uint
		{
			if (pos in tiles) 
			{
				return pos;
			}
			else 
			{
				return  (pos + 10000) % 100;
			}
		}
		
		private function getArgument (pos : int) : Tile
		{
			pos = wrapIndex(pos);
			earliestArgPos = pos;
			tiles[pos].drawHighlightedBorder();
			if (tiles[pos].isCmd)
			{
				runCmd(pos);
			}
			return tiles[pos];
		}
		
		public function redrawAll() : void
		{
			for each (var tile : Tile in tiles)
			{
				tile.redraw();
			}
			
		}
		
		public function tilesToString () : String
		{
			var string : String = "";
			for each (var tile : Tile in tiles) {
				string += tile.contents.toString() + "|";
			}
			return string;
		}
		
		public function tilesToAddressbar () : void
		{
			if (ExternalInterface.available)
				ExternalInterface.call("eval", "if (!!(window.history && history.replaceState)){history.replaceState('', '', window.location.protocol + '//' + window.location.hostname + window.location.pathname + '#' + '" + tilesToString() + "');}");
		}
		
		public function stringToTiles (s : String) : void
		{
			var arr: Array = s.split("|");
			var tileVals : Vector.<int> = new Vector.<int>();
			for each (var a : * in arr) 
			{
				tileVals.push(int(a as String));
			}
			populateGrid(tileVals);
		}
		
		
		
		//public function 
	}
	
}