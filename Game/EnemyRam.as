package{
	
	import flash.display.MovieClip;
	
	public class EnemyRam extends MovieClip{
		
		var health:int = 5000;
		var maxHealth:int = 5000;
		var damage:int = 3;
		var speed:int = 1;
		
		var healthBarDist:int = 640;
		var onScreen:Boolean = false;
		var AIType:int = 6;
		
		public function EnemyRam(X:int, Y:int){
			this.x = X;
			this.y = Y;
		}
		
		
	}
	
	
}