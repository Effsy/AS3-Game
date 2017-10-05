package  {
	import flash.ui.Keyboard
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.display.MovieClip;
	
	public class Inventory extends MovieClip
	{
		var world:World;
		var overlay:Overlay;
		
		var addedToWorld:Boolean = false;
		var inventorySlots:Array = [0, 0, 0, 0, 0, 0, 0, 0];
		
		var item:Item;
		
		var selectorPosition:int = 0
		
		var qPressed:Boolean = false
		var spacePressed:Boolean = false
		var upPressed:Boolean = false
		var downPressed:Boolean = false
		var leftPressed:Boolean = false
		var rightPressed:Boolean = false
		
		var scroll1:Scroll;
		var healthPotion:HealthPotion;
		var poisonPotion:PoisonPotion;
		
		
		public function selectorPositionX(a:int):int
		{
			switch(a)
			{
			case 0:
				return(70)
				break;
			case 1:
				return(170)
				break;
			case 2:
			    return(270)
				break;
			case 3:
			   	return(370)
				break;
			case 4:
				return(70)
				break;
			case 5:
			   	return(170)
				break;
			case 6:
				return(270)
				break;
			case 7:
				return(370)
				break;
			}
			return 0;
		}
		
		public function selectorPositionY(a:int):int
		{
			switch(a)
			{
			case 0:
				return(70)
				break;
			case 1:
				return(70)
				break;
			case 2:
			    return(70)
				break;
			case 3:
			   	return(70)
				break;
			case 4:
				return(170)
				break;
			case 5:
			   	return(170)
				break;
			case 6:
				return(170)
				break;
			case 7:
				return(170)
				break;
			}
			return 0;			
		}
	
	    public function storeItem (a:Sprite, b:Class):void
		{
			for(var c:int = 0; c < inventorySlots.length; c++)
			{
				if(inventorySlots[c] == 0)
				{
					a = new b(selectorPositionX(c), selectorPositionY(c));
					inventorySlots[c] = a;
					c = inventorySlots.length;
					
				}
			}
			addChild(a);
		}
		
		public function setHotbarItem(a:Sprite, b:Class):void
		{
			a = new b(737.5, 362.5);
			overlay.hotbarItem = a;
			overlay.addChild(a)
		}

		public function Inventory(X:int,Y:int)
		{
			
			var stage:Stage = GlobalVariables.stage;
			
			this.x = X
			this.y = Y
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
				case Keyboard.LEFT:
				case Keyboard.A:
					leftPressed = true;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					rightPressed = true;
					break;
				case Keyboard.SPACE:
				     spacePressed = true;
					 break;
			    case Keyboard.Q:
				     qPressed = true;
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
				case Keyboard.LEFT:
				case Keyboard.A:
					leftPressed = false;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					rightPressed = false;
					break;
				case Keyboard.SPACE:
				     spacePressed = false;
					 break;
			    case Keyboard.Q:
				     qPressed = false;
					 break;
			}
		}

		public function manageInventory():void
		{
			
			//Move selector
			if(upPressed && selectorPosition > 3)
			{
				selector.y -= 100;
				selectorPosition -= 4;
				upPressed = false;
			}
			else if(downPressed && selectorPosition < 4)
			{
				selector.y += 100;
				selectorPosition += 4;
				downPressed = false;
			}
			else if(rightPressed && ((selectorPosition >= 0 && selectorPosition <= 2) || (selectorPosition >= 4 && selectorPosition <= 6)))
			{
				selector.x += 100;
				selectorPosition += 1;
				rightPressed = false;
			}
			else if(leftPressed && ((selectorPosition >= 1 && selectorPosition <= 3) || (selectorPosition >= 5 && selectorPosition <= 7)))
			{
				selector.x -= 100;
				selectorPosition -= 1;
				leftPressed = false;
			}
			
			//Add item to hotbar
			if(spacePressed)
			{
				if(inventorySlots[selectorPosition] == 0)
				{
					if(overlay.hotbarItem != 0)//Inventory empty | overlay.hotbarItem filled
					{
						overlay.removeChild(overlay.hotbarItem);
						storeItem(overlay.hotbarItem, getClass(overlay.hotbarItem));
						overlay.hotbarItem = 0;
					}
					//Inventory empty | overlay.hotbarItem empty
				}
				else
				{
					if(overlay.hotbarItem != 0)//Inventory filled | overlay.hotbarItem filled
					{
						var tempItem:Sprite = overlay.hotbarItem;
						
						removeChild(inventorySlots[selectorPosition]);
						overlay.removeChild(overlay.hotbarItem);
						setHotbarItem(inventorySlots[selectorPosition], getClass(inventorySlots[selectorPosition]));
						inventorySlots[selectorPosition] = 0;
						storeItem(tempItem, getClass(tempItem));
					}
					else //Inventory filled | overlay.hotbarItem empty
					{
						removeChild(inventorySlots[selectorPosition]);
						setHotbarItem(inventorySlots[selectorPosition], getClass(inventorySlots[selectorPosition]));
						inventorySlots[selectorPosition] = 0;
					}
					
				}
				spacePressed = false;
			}
		
			//Drop item
			if (qPressed)
			{
				if(inventorySlots[selectorPosition] != 0)
				{
					world.addItem(inventorySlots[selectorPosition], getClass(inventorySlots[selectorPosition]), -world.x + 400, -world.y + 400);
					removeChild(inventorySlots[selectorPosition]);
					inventorySlots[selectorPosition] = 0;
					qPressed = false;
				}
			}
		}
	
		public function setWorld(newWorld:World):void
		{
			this.world = newWorld;
		}
		
		public function setOverlay(newOverlay:Overlay):void
		{
			this.overlay = newOverlay;
		}
		
	    private function getClass(obj:Object):Class
		{
    		return Class(flash.utils.getDefinitionByName(getQualifiedClassName(obj)));
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
