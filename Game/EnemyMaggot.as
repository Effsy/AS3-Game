package{
	
	import flash.display.MovieClip;
	
	public class EnemyMaggot extends Enemy{
		
		var health:int = 100;
		var maxHealth:int = 100;
		var damage:int = 1;
		var speed:int = 4;
		
		var healthBarDist:int = 30;
		
		var AIType:int = 1;
		
		public function EnemyMaggot(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		
	}
	
	
}