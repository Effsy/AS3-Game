package{
	
	import flash.display.Sprite;
	
	public class EnemyWormTail extends Enemy{
		
		var health:int = 10000000000000;
		var maxHealth:int = 10000000000000;
		var damage:int = 1;
		var speed:int = 8;
		var enemyDir:int = 0;
		var enemyHealthBar:EnemyHealthBar = new EnemyHealthBar(10, -10);
		
		var AIType:int = 3;
		
		public function EnemyWormTail(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		
		public function wormDirection(X:Number, Y:Number, segmentX:Number, segmentY:Number):int
		{			
		
			if ((X - segmentX) > 0 && (Y - segmentY) > 0) //Previous segment up-left of current segment
			{
				if (Math.abs((X - segmentX)) > (Math.abs((Y-segmentY))))
				{
					//move left
					return 1;
				}
				else
				{
					//move up
					return 2;
				}
				
			}
			else if ((X - segmentX) > 0 && (Y - segmentY) < 0) //Player down-left of enemy
			{
					if (Math.abs((X - segmentX)) > (Math.abs((Y-segmentY))))
					{
						//move left
						return 1;
					}
					else
					{
						//move down
						return 3;
					}
				
			}
			else if ((X - segmentX) < 0 && (Y - segmentY) > 0) //Player up-right of enemy
			{
					if (Math.abs((X - segmentX)) > (Math.abs((Y-segmentY))))
					{
						//move right
						return 4;
					}
					else
					{
						//move up
						return 2;
					}
			}
			else if ((X - segmentX) < 0 && (Y - segmentY) < 0) //Player down-right of enemy
			{
					if (Math.abs((X - segmentX)) > (Math.abs((Y-segmentY))))
					{
						//move right
						return 4;
					}
					else
					{
						//move down
						return 3;
					}
			}
			
			return 0;
		
		}
		
	}
	
	
}