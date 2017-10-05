package{
	
	import flash.display.MovieClip;
	
	public class EnemyRat2 extends Enemy{
		
		var health:int = 5;
		var maxHealth:int = 5;
		var damage:int = 50;
		var speed:int = 4;
		
		var healthBarDist:int = 20;
		
		var AIType:int = 1;
		
		public function EnemyRat2(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		
	}
	
	
}