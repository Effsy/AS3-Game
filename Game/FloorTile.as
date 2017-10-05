package  {
	
	import flash.display.Shape;
	
	public class FloorTile extends Shape{

		public function FloorTile(X:int, Y:int) {
			this.x = X
			this.y = Y
			
			graphics.drawRect(0, 0, 80, 80);
		}

	}
	
}
