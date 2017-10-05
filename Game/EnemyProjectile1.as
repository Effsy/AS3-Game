package  {
	
	import flash.display.MovieClip;
		
	public class EnemyProjectile1 extends MovieClip{
		
		var speed:int = 15; 
		var damage:int = 8;
		
		var velocityX:Number;
		var velocityY:Number;
		
		public function EnemyProjectile1(X:int, Y:int, playerX:Number, playerY:Number) {
			this.x = X;
			this.y = Y;
			rotation = (180/Math.PI) * Math.atan2(playerY - Y, playerX - X);
			velocityX = speed * Math.cos(Math.PI * rotation/180);
			velocityY = speed * Math.sin(Math.PI * rotation/180);
		}

	}
	
}









