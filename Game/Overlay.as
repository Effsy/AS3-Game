package  
{
    import flash.display.MovieClip;
	
	public class Overlay extends MovieClip
	{
		var inventory:Inventory = new Inventory (180, 180);
		var pauseMenu:PauseMenu = new PauseMenu(180, 180);
		var hotbarItem:* = 0;
		
		
        public function addInv():void
		{
			inventory.addedToWorld = true;
			inventory.addEventListeners();
			addChild(inventory);
			inventory.setOverlay(this);
			inventory.InventoryGraphic.play;
		}
		public function removeInv():void
		{
			inventory.addedToWorld = false;
			inventory.removeEventListeners();
			removeChild(inventory);
		}
		public function addPauseMenu():void
		{
			pauseMenu.addedToWorld = true;
			pauseMenu.addEventListeners();
			addChild(pauseMenu);
		}
		public function removePauseMenu():void
		{
			pauseMenu.addedToWorld = false;
			removeChild(pauseMenu);
		}
	}
}
