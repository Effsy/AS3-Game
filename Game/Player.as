package{
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Stage;
	
	public class Player extends Sprite{
		
		var health:Number = 100;
		var maxHealth:int = 100;
		var healthRegen:Number = 0.1;
		
		var stamina:Number = 100;
		var maxStamina:int = 100;
		var staminaRegen:Number = 0.2;
		var staminaRegenTimer:Timer = new Timer(3500);
		var staminaDelay:Boolean = false;
		
		var moving:Boolean = false;
		
		//Input variables
		var upPressed:Boolean;
		var downPressed:Boolean;
		var leftPressed:Boolean;
		var rightPressed:Boolean;
		var shiftPressed:Boolean;
		var spacePressed:Boolean;
		var numberPressed:Boolean;
		var mousePressed:Boolean;
		var mouseScrolled:Boolean;
		var mouseMoved:Boolean;
		var pickUpPressed:Boolean;
		var eToggle:Boolean = false;
		var pToggle:Boolean = false;
		
		//Collision detection variables
		var leftCollision:Boolean = false;
		var rightCollision:Boolean = false;
		var upCollision:Boolean = false;
		var downCollision:Boolean = false;
		
		//Movement variables
		var acceleration:Number = 1.5;
		var diagonalAcceleration:Number = 1.06;
		var xSpeed:Number = 0;
		var ySpeed:Number = 0;
		var minSpeed:Number = 0.05;
		var antiFriction:Number = 0.8;
		
		var spellActive:int = 1;
		var hotbarSlotActive:int = 1;
		
		
		var spell1DelayTimer:Timer = new Timer(400);
		var spell1Ready:Boolean = true;
		var spell1Cost:int = 1;		
		
		var spell2DelayTimer:Timer = new Timer(10);
		var spell2Ready:Boolean = true;
		var spell2Cost:int = 2;
		
		var spell3DelayTimer:Timer = new Timer(4000);
		var spell3Ready:Boolean = true;
		var spell3Cost:int = 40;
		
		var spell3ActiveTimer:Timer = new Timer(4000);
		var spell3Finished:Boolean = true;
		
		var shovelDelayTimer:Timer = new Timer(600);
		var shovelReady:Boolean = true;
		
		var spellsUnlocked:int = 3;
		
		var spell1Mana:Number = 100;
		var spell2Mana:Number = 100;
		var spell3Mana:Number = 100;
		
		var spell1MaxMana:int = 100;
		var spell2MaxMana:int = 100;
		var spell3MaxMana:int = 100;
		
		var spellMaxMana:int = 100;
		
		var spell1ManaRegen:Number = 2;
		var spell2ManaRegen:Number = 0.5;
		var spell3ManaRegen:Number = 0.1;
		
		var spell1ManaCost:int = 35;
		var spell2ManaCost:int = 5;
		var spell3ManaCost:int = 70;

		
		var hotbar1Slot:int = 1;
		var hotbar2Slot:int = 2;
		var hotbar3Slot:int = 3;
		var hotbar4Slot:int = 4;
		
		public function Player(X:int, Y:int){
			addEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
			var stage:Stage = GlobalVariables.stage;
			this.x = X;
			this.y = Y;
		}
		
		private function stageAddHandler(e:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMousePress);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelScroll);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
			spell1DelayTimer.addEventListener(TimerEvent.TIMER, spell1Refresh);
			spell2DelayTimer.addEventListener(TimerEvent.TIMER, spell2Refresh);
			spell3DelayTimer.addEventListener(TimerEvent.TIMER,spell3Refresh);
			spell3ActiveTimer.addEventListener(TimerEvent.TIMER, spell3ActiveRefresh);
			shovelDelayTimer.addEventListener(TimerEvent.TIMER, shovelRefresh);
			staminaRegenTimer.addEventListener(TimerEvent.TIMER, staminaRefresh);
			
			removeEventListener(Event.ADDED_TO_STAGE, stageAddHandler);
		}
		
		public function controlPlayer():void{
			//moving = true;
			if(upPressed && leftPressed && !downPressed && !rightPressed){
				xSpeed -= diagonalAcceleration;
				ySpeed -= diagonalAcceleration;
			}
			else if(upPressed && rightPressed && !downPressed && !leftPressed){
				xSpeed += diagonalAcceleration;
				ySpeed -= diagonalAcceleration;
			}
			else if(downPressed && leftPressed && !upPressed && !rightPressed){
				xSpeed -= diagonalAcceleration;
				ySpeed += diagonalAcceleration;
			}
			else if(downPressed && rightPressed && !upPressed && !leftPressed){
				xSpeed += diagonalAcceleration;
				ySpeed += diagonalAcceleration;
			}
			else if(upPressed && !downPressed && !leftPressed && !rightPressed)
				ySpeed -= acceleration;
			else if(downPressed && !upPressed && !leftPressed && !rightPressed)
				ySpeed += acceleration;
			else if(leftPressed && !upPressed && !downPressed && !rightPressed)
				xSpeed -= acceleration;
			else if(rightPressed && !upPressed && !downPressed && !leftPressed)
				xSpeed += acceleration;
				
			//Sprinting
			if (stamina < 0)
				stamina = 0;
			else if (stamina > 100)
				stamina = 100;
				
			if (staminaDelay)
				stamina += staminaRegen;
			
			
			if (shiftPressed)
			{
				if(stamina > 5)
				{
					acceleration = 4;
					diagonalAcceleration = 2.828;
				}
				else
				{
					acceleration = 1.5;
					diagonalAcceleration = 1.06;
				}
				if (upPressed || downPressed || leftPressed || rightPressed)
				{
					stamina -=  1;
					staminaDelay = false;
					staminaRegenTimer.start();
				}
			}
			else if (!shiftPressed)
			{
				acceleration = 1.5;
				diagonalAcceleration = 1.06;
			}

			xSpeed *= antiFriction;
			ySpeed *= antiFriction;
			
			
			//Reduce speed to 0
			if(xSpeed <= minSpeed && xSpeed >= -minSpeed)
				xSpeed = 0;
			if(ySpeed <= minSpeed && ySpeed >= -minSpeed)
				ySpeed = 0;
			
			//Health
			
			if (health > 100)
				health = 100;
			else if(health < 0)
				health = 0;
			
			
			//health += healthRegen;
			
			
			//Mana Regen
			spell1Mana += spell1ManaRegen;
			spell2Mana += spell2ManaRegen;
			spell3Mana += spell3ManaRegen;
			
			
			if(spell1Mana > 100)
				spell1Mana = 100;
			else if(spell1Mana < 0)
				spell1Mana = 0;
				
			if(spell2Mana > 100)
				spell2Mana = 100;
			else if(spell2Mana < 0)
				spell2Mana = 0;
				
			if(spell3Mana > 100)
				spell3Mana = 100;
			else if(spell3Mana < 0)
				spell3Mana = 0;			
			
		}
		
		public function keyPressed(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.UP:
				case Keyboard.W:
					upPressed = true;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					downPressed = true;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					leftPressed = true;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					rightPressed = true;
					break;
				case Keyboard.Q:
				     pickUpPressed = true;
					 break;
				case Keyboard.E:
					if (!eToggle)
						eToggle = true;
					else
						eToggle = false;
					break;
				case Keyboard.P:
					if (!pToggle)
						pToggle = true;
					else
						pToggle = false;
					break;
				
					
				//WEAPONS
				case Keyboard.NUMBER_1:
					hotbarSlotActive = 1;
					numberPressed = true;
					break;
				case Keyboard.NUMBER_2:
					hotbarSlotActive = 2;
					numberPressed = true;
					break;
				case Keyboard.NUMBER_3:
					hotbarSlotActive = 3;
					numberPressed = true;
					break;
				case Keyboard.NUMBER_4:
					hotbarSlotActive = 4;
					numberPressed = true;
					break;
				//SPRINT
				case Keyboard.SHIFT:
					shiftPressed = true
					break;
				case Keyboard.SPACE:
					spacePressed = true;
					break;
			}
	
		}
		
		public function keyReleased(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.UP:
				case Keyboard.W:
					upPressed = false;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					downPressed = false;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					leftPressed = false;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					rightPressed = false;
					break;
				case Keyboard.Q:
				     pickUpPressed = false;
					break;
				case Keyboard.NUMBER_1:
					numberPressed = false;
					break;
				case Keyboard.NUMBER_2:
					numberPressed = false;
					break;
				case Keyboard.NUMBER_3:
					numberPressed = false;
					break;
				case Keyboard.NUMBER_4:
					numberPressed = false;
					break;
				//SPRINT
				case Keyboard.SHIFT:
					shiftPressed = false;
					break;
				case Keyboard.SPACE:
					spacePressed = false;
					break;
			}
		}
		
		public function onMousePress(e:MouseEvent):void{
			mousePressed = true;
		}
		
		public function onMouseRelease(e:MouseEvent):void{
			mousePressed = false;
		}
		
		public function spell1Refresh(e:TimerEvent):void{
			spell1Ready = true;
			spell1DelayTimer.stop();
		}
		public function spell2Refresh(e:TimerEvent):void{
			spell2Ready = true;
			spell2DelayTimer.stop();
		}
		public function spell3Refresh(e:TimerEvent):void{
			spell3Ready = true;
			spell3DelayTimer.stop();
		}
		public function spell3ActiveRefresh(e:TimerEvent):void{
			spell3Finished = true;
			spell3ActiveTimer.stop();
		}
		
		public function onMouseWheelScroll(e:MouseEvent):void{
			if(e.delta < 0 && hotbarSlotActive < 4)
				hotbarSlotActive++
			else if(e.delta > 0 && hotbarSlotActive > 1)
				hotbarSlotActive--;
				
				mouseScrolled = true;
			
		}
		public function onMouseMoved(e:MouseEvent):void{
			mouseMoved = true;
		}
		public function staminaRefresh(e:TimerEvent):void
		{
			staminaDelay = true;
		}

		public function shovelRefresh(e:TimerEvent):void{
			shovelReady = true;
			shovelDelayTimer.stop();
		}
	}
	
	
}
	