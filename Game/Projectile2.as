package  {
	
	import flash.display.Sprite;

	public class Projectile2 extends Sprite{
		
		var global:GlobalVariables = new GlobalVariables();
		
		var speed:int = 10; 
		var damage:Number = 0.6;
		
		var velocityX:Number;
		var velocityY:Number;
		
		var projectileType:int = 2;
		
		public function Projectile2(X:int, Y:int, mousex:Number, mousey:Number, playerX:Number, playerY:Number) {
			this.x = X;
			this.y = Y;
			
			rotation = (180/Math.PI) * Math.atan2(((global.randomRange(5, 20)/10)*(mousey - playerY)),((global.randomRange(5,20)/10)*(mousex - playerX)));
			velocityX = speed * Math.cos(Math.PI * rotation/180);
			velocityY = speed * Math.sin(Math.PI * rotation/180);
		}

	}
	
}



