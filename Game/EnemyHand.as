package{
	
	import flash.display.Sprite;
	
	public class EnemyHand extends Enemy{
		
		var health:int = 1000;
		var maxHealth:int = 1000;
		var damage:int = 1;
		var speed:int = 4;
		var enemyHealthBar:EnemyHealthBar = new EnemyHealthBar(-10, -15);

		var hitTree:Boolean = true;
		
		var AIType:int = 6;
		
		public function EnemyHand(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
			addChild(enemyHealthBar);
		}
		
		public function getGolemMoveDirection(X:Number,Y:Number,playerX:Number,playerY:Number):int
		{			
			prevMovementDir = movementDir;
			if ((X - playerX) > 0 && (Y - playerY) > 0) //Player up-left of enemy
			{
					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
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
			else if ((X - playerX) > 0 && (Y - playerY) < 0) //Player down-left of enemy
			{
					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
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
			else if ((X - playerX) < 0 && (Y - playerY) > 0) //Player up-right of enemy
			{

					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
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
			else if ((X - playerX) < 0 && (Y - playerY) < 0) //Player down-right of enemy
			{
					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
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
		
		public function setRotationSpeed(prevMovementDir:int, movementDir:int):int
		{
			//90 degrees clockwise
			if(prevMovementDir == 1 && movementDir == 2)
			{
				distToTurn = 90;
				return 5;
			}
			else if(prevMovementDir == 2 && movementDir == 4)
			{
				distToTurn = 90;
				return 5;
			}
			else if(prevMovementDir == 4 && movementDir == 3)
			{
				distToTurn = 90;
				return 5;
			}
			else if(prevMovementDir == 3 && movementDir == 1)
			{
				distToTurn = 90;
				return 5;
			}
			//90 degrees anticlockwise
			else if(prevMovementDir == 2 && movementDir == 1)
			{
				distToTurn = -90;
				return -5;
			}
			else if(prevMovementDir == 1 && movementDir == 3)
			{
				distToTurn = -90;
				return -5;
			}
			else if(prevMovementDir == 3 && movementDir == 4)
			{
				distToTurn = -90;
				return -5;
			}
			else if(prevMovementDir == 4 && movementDir == 2)
			{
				distToTurn = -90;
				return -5;
			}
			//180 degrees
			else if(prevMovementDir == 1 && movementDir == 4)
			{
				distToTurn = 180;
				return 10;
			}
			else if(prevMovementDir == 2 && movementDir == 3)
			{
				distToTurn = 180;
				return 10;
			}
			else if(prevMovementDir == 3 && movementDir == 2)
			{
				distToTurn = 180;
				return 10;
			}
			else if(prevMovementDir == 4 && movementDir == 1)
			{
				distToTurn = 180;
				return 10;
			}
			else
			{
				distToTurn = 0;
				return 0;
			}
			
			
			
		}
		
	}
	
	
}