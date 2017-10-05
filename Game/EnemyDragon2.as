
package{
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class EnemyDragon2 extends Enemy{
		
		var health:int = 100;
		var maxHealth:int = 200;
		var damage:int = 10;
		var speed:int = 4;
		
		var healthBarDist:int = 25;
		
		var AIType:int = 2;
		
		var projectileDelayTimer:Timer = new Timer(2000);
		var projectileReady;
		
		public function EnemyDragon2(X:int, Y:int){
			super();
			this.x = X;
			this.y = Y;
			projectileDelayTimer.addEventListener(TimerEvent.TIMER, projectileRefresh);
			projectileDelayTimer.start();
			
		}
		
		public function projectileRefresh(e:TimerEvent):void{
			projectileReady = true;
			projectileDelayTimer.stop();
		} 
	}
	
	
}