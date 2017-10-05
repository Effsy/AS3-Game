package{
	
	import flash.display.Sprite;
	
	public class EnemyWolf extends Enemy{
		
		var health:int = 100;
		var maxHealth:int = 100;
		var damage:int = 1;
		var speed:Number = 5;
		
		var healthBarDist:int = 30;
		
		var AIType:int = 1;
		
		public function EnemyWolf(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		
	}
	
	
}