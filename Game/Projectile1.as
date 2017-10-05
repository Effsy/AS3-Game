package  {
	
	import flash.display.MovieClip;
		
	public class Projectile1 extends MovieClip{
		
		var speed:int = 10; 
		var damage:int = 30;
		
		var velocityX:Number;
		var velocityY:Number;
		
		var projectileType:int = 1;
		
		public function Projectile1(X:int, Y:int, mousex:Number, mousey:Number, playerX:Number, playerY:Number) {
			this.x = X;
			this.y = Y;
			rotation = (180/Math.PI) * Math.atan2(mousey - playerY, mousex - playerX);
			velocityX = speed * Math.cos(Math.PI * rotation/180);
			velocityY = speed * Math.sin(Math.PI * rotation/180);
		}

	}
	
}









