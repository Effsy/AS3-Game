package  {
		
	import flash.ui.Keyboard
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class PauseMenu extends MovieClip{

		var addedToWorld:Boolean = false;

		var selectorPosition:int = 0
		
		var spacePressed:Boolean = false
		var upPressed:Boolean = false
		var downPressed:Boolean = false
		var leftPressed:Boolean = false
		var rightPressed:Boolean = false

		public function PauseMenu(X:int, Y:int)
		{
			var stage:Stage = GlobalVariables.stage;
			
			this.x = X;
			this.y = Y;
			
			addEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}
		
		private function stageAddHandler(e:Event):void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			removeEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}
			
		
		private function keyPressed(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
				case Keyboard.W:
					upPressed = true;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					downPressed = true;
					break;
				case Keyboard.SPACE:
				     spacePressed = true;
					 break;
			    case Keyboard.ENTER:
				     spacePressed = true;
					 break;
			}
		}
		private function keyReleased(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
				case Keyboard.W:
					upPressed = false;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					downPressed = false;
					break;
				case Keyboard.SPACE:
				     spacePressed = false;
					 break;
			    case Keyboard.ENTER:
				     spacePressed = false;
					 break;
			}
		}
	
		public function managePauseMenu():void
		{
			if(upPressed && selectorPosition > 0)
			{
				selector.y -= 85;
				selectorPosition--;
				upPressed = false;
			}
			else if(downPressed && selectorPosition < 2)
			{
				selector.y += 85;
				selectorPosition++;
				downPressed = false;
			}
			
		}
		
		public function addEventListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}
		
		public function removeEventListeners():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
	}
	
}
