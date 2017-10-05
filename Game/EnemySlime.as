package{
	
	import flash.display.MovieClip;
	
	public class EnemySlime extends Enemy{
		
		var health:int = 300;
		var maxHealth:int = 300;
		var damage:int = 1;
		var speed:int = 2;
		
		var healthBarDist:int = 40;
		
		var AIType:int = 1;
		
		public function EnemySlime(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		
	}
	
	
}