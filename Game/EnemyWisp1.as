package{
	
	import flash.display.Sprite;
	
	public class EnemyWisp1 extends Enemy{
		
		var health:int = 100;
		var maxHealth:int = 100;
		var damage:int = 1;
		var speed:int = 4;
		var xSpeed:int = 2;
		var ySpeed:int = 2;
		var knockback:int = 5;
		
		var healthBarDist:int = 30;
		
		var AIType:int = 7;
		
		public function EnemyWisp1(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
		}
		public function setWispSpeed(wispX:Number, wispY:Number, playerX:Number, playerY:Number):void
		{
			if(playerX > wispX && playerY > wispY) //Player down-right of wisp
			{
				xSpeed = 2;
				ySpeed = 2;
				movementDir = 1;
			}
			else if(playerX > wispX && playerY < wispY) //Player up-right of wisp
			{
				xSpeed = 2;
				ySpeed = -2;
				movementDir = 1;
			}
			else if(playerX < wispX && playerY > wispY) //Player down-left of wisp
			{
				xSpeed = -2;
				ySpeed = 2;
				movementDir = 2;
			}
			else if(playerX < wispX && playerY < wispY) //Player up-left of wisp
			{
				xSpeed = -2;
				ySpeed = -2;
				movementDir = 2;
			}
		}
		
	}
	
	
}