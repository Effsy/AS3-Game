package  {
		
	
	import flash.display.Stage;
		
	public class GlobalVariables{
		
		public var screenHeight:int = 800;
		public var screenWidth:int = 800;
		public var tileSize:int = 80;
		public var worldSize:int = 50;
		
		public var playerX:int = screenWidth/2;
		public var playerY:int = screenHeight/2;
		
		public var spawnX:int = 4;
		public var spawnY:int = 4;
		
		public static var stage:Stage;
		
		public function GlobalVariables() {
			
		}



		public function randomRange(minNum:Number, maxNum:Number):int {
   			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		
	}
	
	
}
