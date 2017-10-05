package{
	
	import flash.display.Sprite;
	
	public class EnemyWorm extends Enemy{
		
		var health:int = 2000;
		var maxHealth:int = 2000;
		var damage:Number = 0.8;
		var speed:int = 8;
		
		var AIType:int = 4;
		
		var healthBarDist:int = 40;
		
		var segmentMoved:int = 80;
		
		public function EnemyWorm(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		public function wormDirection(X:Number, Y:Number, playerX:Number, playerY:Number, playerTileY:int, wormTileY:int):int
		{
			if(playerTileY == wormTileY)
			{
				if(X - playerX > 0)
				{
					return 1;
				}
				else
				{
					return 4;
				}
			}
			else
			{
				if(Y - playerY > 0)
				{
					return 2
				}
				else 
				{
					return 3;
				}
			}
		
			return 0;
		
		}
		
	}
	
	
}