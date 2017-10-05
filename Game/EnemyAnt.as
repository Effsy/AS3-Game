package{
	
	import flash.display.Sprite;
	
	public class EnemyAnt extends Enemy{
		
		var health:uint = 1000000000000000000000;
		var maxHealth:uint = 1000000000000000000000;
		var damage:int = 1;
		var speed:int = 4;
		
		var AIType:int = 5;
		
		public function EnemyAnt(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		
	}
	
	
}