package{
	
	import flash.display.MovieClip;
	
	public class EnemyRat extends Enemy{
		
		var health:int = 5;
		var maxHealth:int = 5;
		var damage:int = 20;
		var speed:int = 8;
		
		var healthBarDist:int = 20;
		
		var AIType:int = 1;
		
		public function EnemyRat(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		
	}
	
	
}