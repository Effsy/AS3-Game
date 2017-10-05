package 
{

	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.utils.getQualifiedClassName;
	import flash.ui.Mouse;
	import flash.display.MovieClip;

	import flash.media.SoundChannel;

	public class GameHandler extends Sprite
	{
		var global:GlobalVariables = new GlobalVariables();
		
		var hardmode:Boolean = false;
		
		//General
		var collisionsEnabled:Boolean = true;
		var gamePaused:Boolean = false;
		var levelNumber = 0;
		
		//Items
		var item:Item;
		
		var healthPotion:HealthPotion;
		var scroll1:Scroll;
		
		//Text
		var inventoryFull:InventoryFull;

		//Display Object containers
		var player:Player;
		var playerGraphic:PlayerGraphic;
		var world:World = new World();
		var overlay:Overlay = new Overlay();
		var cursor:Sprite = new Sprite();

		//Music
		var bgmSoundChannel:SoundChannel;	
		var bgmPlaying:Boolean = false;

		//Projectiles
		var projectile1:Projectile1;
		var projectile2:Projectile2;
		var enemyProjectile1:EnemyProjectile1;
		var projectileShovel:ProjectileShovel;
		var aoeBlock:AoEBlock;
		var aoeTiles:Array = [];
		
		//Cursors
		var spell1Cursor:Spell1Cursor = new Spell1Cursor();
		var spell2Cursor:Spell2Cursor = new Spell2Cursor();
		var spell3Cursor:Spell3Cursor = new Spell3Cursor();
		
		
		var projectilesList:Array = [];
		var enemyProjectilesList:Array = [];
		var enemyDeathList:Array = [];
		
		var wormArray:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0];
		
		var rainFilter:RainFilter;
		var darkFilter:DarkFilter;
		
		var deathScene:DeathScene = new DeathScene(0, 0);
		var screenTimer:Timer = new Timer(3500);
			
		var screenFinishLevelTimer:Timer = new Timer(3500);
		
		var bossWaveTimer:Timer = new Timer(15000);
		
		public function GameHandler()
		{
			Mouse.hide();
			startLevel();
			screenTimer.addEventListener(TimerEvent.TIMER, deathScreenRefresh);
			screenFinishLevelTimer.addEventListener(TimerEvent.TIMER, finishLevelRefresh);
			addEventListener(Event.ENTER_FRAME, gameLoop);
		}

		public function gameLoop(e:Event):void
		{
			
			///Pause/unpause the game
			if(player.pToggle)
			{
				if(!overlay.pauseMenu.addedToWorld)
				{
					overlay.addPauseMenu();
					gamePaused = true;
				}
				overlay.pauseMenu.managePauseMenu();
				if(overlay.pauseMenu.spacePressed)
				{
					switch(overlay.pauseMenu.selectorPosition)
					{
						case 0:
							if(bgmPlaying)
							{
								bgmSoundChannel.stop();
								bgmPlaying = false;
							}
							else
							{
								switch(levelNumber)
								{
									case 1:
										var bgm1:Music1 = new Music1();
										bgmSoundChannel = bgm1.play(0, 999);
										break;
									case 2:
										//var bgm2:Music1 = new Music1();
										//bgmSoundChannel = bgm2.play(0, 999);
										break;
									case 3:
										var bgm3:Music3 = new Music3();
										bgmSoundChannel = bgm3.play(0, 999);
										break;
									case 4:
										//var bgm4:Music1 = new Music1();
										//bgmSoundChannel = bgm4.play(0, 999);
										break;
									case 5:
										//var bgm5:Music1 = new Music1();
										//bgmSoundChannel = bgm5.play(0, 999);
										break;
								}
								
								bgmPlaying = true;
							}
							break;
						case 1:
							levelNumber--;
							endLevel();
							break;
						case 2:
							
							break;
					}
					overlay.pauseMenu.spacePressed = false;
				}
			}
			else if(overlay.pauseMenu.addedToWorld)
			{
				overlay.removePauseMenu();
				gamePaused = false;
			}
			///Open/close the inventory
			else if (player.eToggle)
			{
				if (!overlay.inventory.addedToWorld)
				{
					overlay.inventory.setWorld(world);
					overlay.addInv();
					gamePaused = true;
				}
				
				overlay.inventory.manageInventory();
			}
			else if (overlay.inventory.addedToWorld)
			{
				overlay.removeInv();
				gamePaused = false;
			}
			
			//While running
			if (!gamePaused)
			{
				//Health/Stamina/Mana
				overlay.healthBar.scaleX = player.health/player.maxHealth;
				overlay.staminaBar.scaleX = player.stamina/player.maxStamina;
				
				//Pickup items
				if (player.pickUpPressed)
				{
					var inventoryFull:Boolean = false;
					//Check if inventory is full
					for(var a:int = 0; a < overlay.inventory.inventorySlots.length; a++)
					{
						if(overlay.inventory.inventorySlots[a] == 0)
						{
							//End 'for loop' check if slot is empty
							a = overlay.inventory.inventorySlots.length;
						}
						if(a == overlay.inventory.inventorySlots.length - 1)
						{
							inventoryFull = true;
						}
					}
					
					if(!inventoryFull)
					{
						for (var a:int = 0; a < world.itemList.length; a++)
						{
						
					   		if (world.itemList[a].hitTestObject(player))
					   		{
							overlay.inventory.storeItem(world.itemList[a], getClass(world.itemList[a]))
							world.removeItem(a);
							//Only pickup first item
							a = world.itemList.length;
							player.pickUpPressed = false;
							}
						}
					}
					else
					{
						//Inventory is full
					}
					
					
				}
				///----------------
				///ENEMY MANAGEMENT
				///----------------
				for (var a:int = 0; a < world.enemyList.length; a++)
				{
					if(world.enemyList[a].AIType == 1)
					{
						//Recalculate movement direction and reset position to center
						if(world.enemyList[a].distMoved >= global.tileSize && world.enemyList[a].onScreen)
						{
							var u:Boolean = false;
							var d:Boolean = false;
							var l:Boolean = false;
							var r:Boolean = false;

							if (getQualifiedClassName(world.tileList[Math.floor(world.enemyList[a].x/global.tileSize)-1][Math.floor(world.enemyList[a].y/global.tileSize)]) == "FloorTile")
							{
								l = true;
							}
							if (getQualifiedClassName(world.tileList[Math.floor(world.enemyList[a].x/global.tileSize)+1][Math.floor(world.enemyList[a].y/global.tileSize)]) == "FloorTile")
							{
								r = true;
							}
							if (getQualifiedClassName(world.tileList[Math.floor(world.enemyList[a].x/global.tileSize)][Math.floor(world.enemyList[a].y/global.tileSize)-1]) == "FloorTile")
							{
								u = true;
							}
							if (getQualifiedClassName(world.tileList[Math.floor(world.enemyList[a].x/global.tileSize)][Math.floor(world.enemyList[a].y/global.tileSize)+1]) == "FloorTile")
							{
								d = true;
							}
							world.enemyList[a].movementDir = world.enemyList[a].getMoveDirection(world.enemyList[a].x,world.enemyList[a].y, -world.x + player.x, -world.y + player.y,u,d,l,r);
					
							world.enemyList[a].x = Math.round(world.enemyList[a].x / global.tileSize) * global.tileSize - 40;
							world.enemyList[a].y = Math.round(world.enemyList[a].y / global.tileSize) * global.tileSize - 40;
							
							//Rotate Enemy
							if (world.enemyList[a].movementDir == 1)
							{
								world.enemyList[a].rotation = 180;
							}
							else if (world.enemyList[a].movementDir == 2)
							{
								world.enemyList[a].rotation = 270;
							}
							else if (world.enemyList[a].movementDir == 3)
							{
								world.enemyList[a].rotation = 90;
							}
							else if (world.enemyList[a].movementDir == 4)
							{
								world.enemyList[a].rotation = 0;
							}
							
							world.enemyList[a].distMoved = 0;
						}
						
						if (world.enemyList[a].movementDir == 1)
						{
							world.enemyList[a].x -=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 2)
						{
							world.enemyList[a].y -=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 3)
						{
							world.enemyList[a].y +=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 4)
						{
							world.enemyList[a].x +=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						//Recheck for movement
						else if (world.enemyList[a].movementDir == 0)
						{
							world.enemyList[a].distMoved = global.tileSize;
						}
						
						//Adjust HealthBar 
						world.enemyHealthBarList[a].x = world.enemyList[a].x;
						world.enemyHealthBarList[a].y = world.enemyList[a].y + world.enemyList[a].healthBarDist;
					}
					else if(world.enemyList[a].AIType == 2)
					{
						if(world.enemyList[a].projectileReady)
						{
							enemyProjectile1 = new EnemyProjectile1(world.enemyList[a].x, world.enemyList[a].y, -world.x + global.playerX, -world.y + global.playerY);
							enemyProjectilesList.push(enemyProjectile1);
							world.enemyList[a].projectileReady = false;
							world.enemyList[a].projectileDelayTimer.start();
							world.frontObjects.addChild(enemyProjectile1);
						}
						//Adjust HealthBar 
						world.enemyHealthBarList[a].x = world.enemyList[a].x;
						world.enemyHealthBarList[a].y = world.enemyList[a].y + world.enemyList[a].healthBarDist;
						
						world.enemyList[a].rotation = (180/Math.PI) * -Math.atan2(world.enemyList[a].x - (-world.x + 400), world.enemyList[a].y - (-world.y +400));
					}
					else if(world.enemyList[a].AIType == 3) //WormSegments
					{
						
						
						//Recalculate movement direction and reset position to center
						if(world.enemyList[a].distMoved >= global.tileSize)
						{
							world.enemyList[a].movementDir = wormArray[a];
							world.enemyList[a].distMoved = 0;
							
							//Rotate Enemy
							if (world.enemyList[a].movementDir == 1)
							{
								world.enemyList[a].rotation = 180;
							}
							else if (world.enemyList[a].movementDir == 2)
							{
								world.enemyList[a].rotation = 270;
							}
							else if (world.enemyList[a].movementDir == 3)
							{
								world.enemyList[a].rotation = 90;
							}
							else if (world.enemyList[a].movementDir == 4)
							{
								world.enemyList[a].rotation = 0;
							}
						}
						
						if (world.enemyList[a].movementDir == 1)
						{
							world.enemyList[a].x -= world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 2)
						{
							world.enemyList[a].y -= world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 3)
						{
							world.enemyList[a].y += world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 4)
						{
							world.enemyList[a].x += world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
						}
						//Recheck for movement
						else if (world.enemyList[a].movementDir == 0)
						{
							world.enemyList[a].distMoved = global.tileSize;
						}
					}
					else if(world.enemyList[a].AIType == 4) //Worm Head
					{
						
						//Recalculate movement direction and reset position to center
						var c:int = 1;
						if(world.enemyList[a].movementDir == 1 || world.enemyList[a].movementDir == 4)
						{
							c = 8;
						}
						
						if(world.enemyList[a].distMoved >= global.tileSize * c)
						{
							world.enemyList[a].movementDir = world.enemyList[a].wormDirection(world.enemyList[a].x, world.enemyList[a].y, -world.x + player.x, -world.y + player.y, getCurrentYTile(), getTileY(world.enemyList[a].y));
					
							world.enemyList[a].x = Math.round(world.enemyList[a].x / global.tileSize) * global.tileSize - 40;
							world.enemyList[a].y = Math.round(world.enemyList[a].y / global.tileSize) * global.tileSize - 40;
							
							world.enemyList[a].distMoved = 0;
							
							//Rotate Enemy
							if (world.enemyList[a].movementDir == 1)
							{
								world.enemyList[a].rotation = 180;
							}
							else if (world.enemyList[a].movementDir == 2)
							{
								world.enemyList[a].rotation = 270;
							}
							else if (world.enemyList[a].movementDir == 3)
							{
								world.enemyList[a].rotation = 90;
							}
							else if (world.enemyList[a].movementDir == 4)
							{
								world.enemyList[a].rotation = 0;
							}
						}
						
						//Store last positions
						if(world.enemyList[a].segmentMoved >= global.tileSize)
						{
							wormArray.unshift(world.enemyList[a].movementDir);
							wormArray.pop;
							world.enemyList[a].segmentMoved = 0;
						}
						
						if (world.enemyList[a].movementDir == 1)
						{
							world.enemyList[a].x -=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							world.enemyList[a].segmentMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 2)
						{
							world.enemyList[a].y -=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							world.enemyList[a].segmentMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 3)
						{
							world.enemyList[a].y +=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							world.enemyList[a].segmentMoved += world.enemyList[a].speed;
						}
						else if (world.enemyList[a].movementDir == 4)
						{
							world.enemyList[a].x +=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							world.enemyList[a].segmentMoved += world.enemyList[a].speed;
						}
						//Recheck for movement
						else if (world.enemyList[a].movementDir == 0)
						{
							world.enemyList[a].distMoved = global.tileSize;
						}
						//Adjust HealthBar 
						world.enemyHealthBarList[a].x = world.enemyList[a].x;
						world.enemyHealthBarList[a].y = world.enemyList[a].y + world.enemyList[a].healthBarDist;
					}
					else if(world.enemyList[a].AIType == 5) //Ant
					{
						if(world.enemyList[a].distMoved >= global.tileSize)
						{
							var changeDirChance:int = global.randomRange(0, 4);
							
							if(changeDirChance == 0 || getTileX(world.enemyList[a].x) < 2 || getTileY(world.enemyList[a].y) < 2 || getTileY(world.enemyList[a].y) > 30 || getTileX(world.enemyList[a].x) > 29)
							{
								
								//Get move direction
								var canMove:Boolean = false;
								while(!canMove){
									var moveDirChance:int = global.randomRange(1, 4);
									if(moveDirChance == 1 && getTileX(world.enemyList[a].x) > 2)
									{
										world.enemyList[a].movementDir = 1;
										canMove = true;
									}
									else if(moveDirChance == 2 && getTileY(world.enemyList[a].y) > 2)
									{
										world.enemyList[a].movementDir = 2;
										canMove = true;
									}
									else if(moveDirChance == 3 && getTileY(world.enemyList[a].y) < 30)
									{
										world.enemyList[a].movementDir = 3;
										canMove = true;
									}
									else if(moveDirChance == 4 && getTileX(world.enemyList[a].x) < 29)
									{
										world.enemyList[a].movementDir = 4;
										canMove = true;
									}
								}
							}
							
							//Rotate Enemy
							if (world.enemyList[a].movementDir == 1)
							{
								world.enemyList[a].rotation = 180;
							}
							else if (world.enemyList[a].movementDir == 2)
							{
								world.enemyList[a].rotation = 270;
							}
							else if (world.enemyList[a].movementDir == 3)
							{
								world.enemyList[a].rotation = 90;
							}
							else if (world.enemyList[a].movementDir == 4)
							{
								world.enemyList[a].rotation = 0;
							}
							
							world.enemyList[a].distMoved = 0;
							
						}
						
						if (world.enemyList[a].movementDir == 1)
						{
							world.enemyList[a].x -=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							
							if(world.enemyList[a].hitTestObject(world.tileList[getTileX(world.enemyList[a].x) - 1][getTileY(world.enemyList[a].y)]) && getQualifiedClassName(world.tileList[getTileX(world.enemyList[a].x) - 1][getTileY(world.enemyList[a].y)]) == "DirtwallTile")
								world.replaceDirtWall(getTileX(world.enemyList[a].x) - 1, getTileY(world.enemyList[a].y));
						}
						else if (world.enemyList[a].movementDir == 2)
						{
							world.enemyList[a].y -=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							
							if(world.enemyList[a].hitTestObject(world.tileList[getTileX(world.enemyList[a].x)][getTileY(world.enemyList[a].y) - 1]) && getQualifiedClassName(world.tileList[getTileX(world.enemyList[a].x)][getTileY(world.enemyList[a].y) - 1]) == "DirtwallTile")
								world.replaceDirtWall(getTileX(world.enemyList[a].x), getTileY(world.enemyList[a].y) - 1);
						}
						else if (world.enemyList[a].movementDir == 3)
						{
							world.enemyList[a].y +=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							
							if(world.enemyList[a].hitTestObject(world.tileList[getTileX(world.enemyList[a].x)][getTileY(world.enemyList[a].y) + 1]) && getQualifiedClassName(world.tileList[getTileX(world.enemyList[a].x)][getTileY(world.enemyList[a].y) + 1]) == "DirtwallTile")
								world.replaceDirtWall(getTileX(world.enemyList[a].x), getTileY(world.enemyList[a].y) + 1);
						}
						else if (world.enemyList[a].movementDir == 4)
						{
							world.enemyList[a].x +=  world.enemyList[a].speed;
							world.enemyList[a].distMoved += world.enemyList[a].speed;
							
							if(world.enemyList[a].hitTestObject(world.tileList[getTileX(world.enemyList[a].x) + 1][getTileY(world.enemyList[a].y)]) && getQualifiedClassName(world.tileList[getTileX(world.enemyList[a].x) + 1][getTileY(world.enemyList[a].y)]) == "DirtwallTile")
								world.replaceDirtWall(getTileX(world.enemyList[a].x) + 1, getTileY(world.enemyList[a].y));
						}
						//Recheck for movement
						else if (world.enemyList[a].movementDir == 0)
						{
							world.enemyList[a].distMoved = global.tileSize;
						}
						
					}
					else if(world.enemyList[a].AIType == 6)
					{
						world.enemyList[a].x += world.enemyList[a].speed;
						//Adjust HealthBar 
						world.enemyHealthBarList[a].x = world.enemyList[a].x;
					}
					else if (world.enemyList[a].AIType == 7)
					{
						if(world.enemyList[a].onScreen)
						{
							if(world.enemyList[a].distMoved >= 200)
							{
								world.enemyList[a].setWispSpeed(world.enemyList[a].x, world.enemyList[a].y, -world.x + player.x, -world.y + player.y);
								world.enemyList[a].distMoved = 0;
								
								//Rotate Enemy
							if (world.enemyList[a].movementDir == 1)
							{
								world.enemyList[a].scaleX = -1;
							}
							else if (world.enemyList[a].movementDir == 2)
							{
								world.enemyList[a].scaleX = 1;
							}
								
							}
						}
						else
						{
							world.enemyList[a].xSpeed = 0;
							world.enemyList[a].ySpeed = 0;
							world.enemyList[a].distMoved = 0;
						}
						world.enemyList[a].x += world.enemyList[a].xSpeed;
						world.enemyList[a].y += world.enemyList[a].ySpeed;
						world.enemyList[a].distMoved += world.enemyList[a].speed;
						
						//Adjust HealthBar 
						world.enemyHealthBarList[a].x = world.enemyList[a].x;
						world.enemyHealthBarList[a].y = world.enemyList[a].y + world.enemyList[a].healthBarDist;
					}
					
					/////////////////////////
					//If enemy is on screen//
					/////////////////////////
					if (checkOnScreen(world.enemyList[a].x,world.enemyList[a].y))
					{	
						//Deal damage to enemy
						world.enemyList[a].onScreen = true;
						for (var b:int = 0; b < projectilesList.length; b++)
						{
							
							//TEMP\\
							if(world.enemyList[a].AIType == 1 || world.enemyList[a].AIType == 2 || world.enemyList[a].AIType == 4 || world.enemyList[a].AIType == 6 || world.enemyList[a].AIType == 7)
							{
								if (world.enemyList[a].hitTestObject(projectilesList[b]))
								{
									world.enemyList[a].health -= projectilesList[b].damage;
									world.enemyHealthBarList[a].scaleX = world.enemyList[a].health/world.enemyList[a].maxHealth;
									if(projectilesList[b].projectileType != 2)
									{
										world.frontObjects.removeChild(projectilesList[b]);
										projectilesList.splice(b, 1);
									}
								}
							}
						}
						//Check aoe
						for(var c:int = 0; c < aoeTiles.length; c++)
						{
							if(world.enemyList[a].AIType == 1 || world.enemyList[a].AIType == 2 || world.enemyList[a].AIType == 4 || world.enemyList[a].AIType == 7)
							{
								if(world.enemyList[a].hitTestObject(aoeTiles[c]))
								{
									world.enemyList[a].health -=  aoeTiles[b].damage;
									world.enemyHealthBarList[a].scaleX = world.enemyList[a].health/world.enemyList[a].maxHealth;
								}
							}
						}
						
						//Enemy hit player
						if (world.enemyList[a].hitTestObject(player))
						{
							
							//Deal damage to player
							if(getQualifiedClassName(world.enemyList[a]) != "EnemyWisp1" && getQualifiedClassName(world.enemyList[a]) != "EnemyWisp2")
							{
								player.health -= world.enemyList[a].damage;
							}
							else if(getQualifiedClassName(world.enemyList[a]) == "EnemyWisp1")
							{//For enemyWisp1 - Knockback
								knockbackPlayer(world.enemyList[a].x + 25, world.enemyList[a].y + 25, -world.x + player.x,  -world.y + player.y, world.enemyList[a].knockback);
							}
							else
							{//For enemyWisp2 - Restart level
								levelNumber--;
								endLevel();
							}
							
							//Suicidal enemies
							if(getQualifiedClassName(world.enemyList[a]) == "EnemyRat")
							{
								var enemyRatDeath:EnemyRatDeath = new EnemyRatDeath(world.enemyList[a].x, world.enemyList[a].y);
								world.backObjects.addChild(enemyRatDeath);
								enemyDeathList.push(enemyRatDeath);
								
								world.frontObjects.removeChild(world.enemyList[a]);
								world.enemyList.splice(a, 1);
								world.frontObjects.removeChild(world.enemyHealthBarList[a]);
								world.enemyHealthBarList.splice(a, 1);
							}
						}
						
						//Remove enemy
						if (world.enemyList[a].health <= 0)
						{
							//Enemy drop item
							var R:int = global.randomRange(0,10) 
							
							if (R > 6)
							{
								world.addItem(healthPotion,HealthPotion,world.enemyList[a].x, world.enemyList[a].y)
							}
							else if (R <= 1)
							{
								world.addItem(scroll1,Scroll,world.enemyList[a].x, world.enemyList[a].y)
							}
							
							
							//Add EnemyDeathAnimation
							if(getQualifiedClassName(world.enemyList[a]) == "EnemyRat")
							{
								var enemyRatDeath:EnemyRatDeath = new EnemyRatDeath(world.enemyList[a].x, world.enemyList[a].y);
								world.backObjects.addChild(enemyRatDeath);
								enemyDeathList.push(enemyRatDeath);
							}
							else if(getQualifiedClassName(world.enemyList[a]) == "EnemyRat2")
							{
								var enemyRatDeath2:EnemyRatDeath2 = new EnemyRatDeath2(world.enemyList[a].x, world.enemyList[a].y);
								world.backObjects.addChild(enemyRatDeath2);
								enemyDeathList.push(enemyRatDeath2);
							}
							else
							{
								var enemyDeath:EnemyDeath = new EnemyDeath(world.enemyList[a].x, world.enemyList[a].y);
								world.backObjects.addChild(enemyDeath);
								enemyDeathList.push(enemyDeath);
							}
							
							
							//Remove Enemy
							if(world.enemyList[a].AIType == 6)
							{
								if(world.bossLayer.contains(world.enemyList[a]))
								{
									world.bossLayer.removeChild(world.enemyList[a]);
									world.enemyList.splice(a, 1);
									world.bossLayer.removeChild(world.enemyHealthBarList[a]);
									world.enemyHealthBarList.splice(a, 1);
								}
							}
							else(world.frontObjects.contains(world.enemyList[a]))
							{
								world.frontObjects.removeChild(world.enemyList[a]);
								world.enemyList.splice(a, 1);
								world.frontObjects.removeChild(world.enemyHealthBarList[a]);
								world.enemyHealthBarList.splice(a, 1);
							}
						}
						
					}
					else
					{
						world.enemyList[a].onScreen = false;
						
						if(world.enemyList[a].AIType == 1 || world.enemyList[a].AIType == 2)
							world.enemyList[a].movementDir = 0;
					}
				}
				
				///----------------------
				///ENEMY DEATH ANIMATIONS
				///----------------------
				for(var a:int = 0; a < enemyDeathList.length;a++)
				{
					if(getQualifiedClassName(enemyDeathList[a]) == "EnemyRatDeath")
					{
						if(enemyDeathList[a].frameNumber < 27)
						{
							enemyDeathList[a].frameNumber++
						}
						else
						{
							world.backObjects.removeChild(enemyDeathList[a]);
							enemyDeathList.splice(a, 1);
						}
					}
					else
					{
						if(enemyDeathList[a].frameNumber < 25)
						{
							enemyDeathList[a].frameNumber++
						}
						else
						{
							world.backObjects.removeChild(enemyDeathList[a]);
							enemyDeathList.splice(a, 1);
						}
					}
				}
				///-------------------
				///COLLISION DETECTION
				///-------------------
				
				if(collisionsEnabled){
				
				///Moving LEFT and UP
				if((player.leftPressed || player.xSpeed < 0) && (player.upPressed || player.ySpeed < 0) && !player.rightPressed && !player.downPressed)
				{
					if (player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) != "FloorTile")
					{
						player.leftCollision = true;

						world.x -= (world.tileList[getCurrentXTile() - 1][getCurrentYTile()].x + 80 -(-world.x + global.screenWidth/2 - 25));
						player.xSpeed = 0;
					}
					if (player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) != "FloorTile")
					{
						player.upCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					player.rightCollision = false;
					player.downCollision = false;
				}
				///Moving LEFT and DOWN
				else if((player.leftPressed || player.xSpeed < 0) && (player.downPressed || player.ySpeed > 0) && !player.rightPressed && ! player.upPressed)
				{
					if (player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) != "FloorTile")
					{
						player.leftCollision = true;
						world.x -= (world.tileList[getCurrentXTile() - 1][getCurrentYTile()].x + 80 -(-world.x + global.screenWidth/2 - 25));
						player.xSpeed = 0;
					}
					if (player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) != "FloorTile")
					{
						player.downCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y + 30 - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					player.rightCollision = false;
					player.upCollision = false;
				}
				///Moving RIGHT and UP
				else if((player.rightPressed || player.xSpeed > 0) && (player.upPressed || player.ySpeed < 0) && !player.leftPressed && ! player.downPressed)
				{
					if (player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) != "FloorTile")
					{
						player.rightCollision = true;
						world.x -=  world.tileList[getCurrentXTile()][getCurrentYTile()].x + 30 - (-world.x + global.screenHeight/2 - 25);
						
					}
					if (player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) != "FloorTile")
					{
						player.upCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y - (-world.y + global.screenHeight/2 - 25);
					}
					
					player.leftCollision = false;
					player.downCollision = false;
				}
				///Moving RIGHT and DOWN
				else if((player.rightPressed || player.xSpeed > 0) && (player.downPressed || player.ySpeed > 0) && !player.leftPressed && !player.upPressed)
				{
					if (player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) != "FloorTile")
					{
						player.rightCollision = true;
						world.x -=  world.tileList[getCurrentXTile()][getCurrentYTile()].x + 30 - (-world.x + global.screenHeight/2 - 25);
						player.xSpeed = 0;

					}
					if (player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) != "FloorTile")
					{
						player.downCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y + 30 - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					player.leftCollision = false;
					player.upCollision = false;
				}
				 
				///Single direction movement collision detection
				
				///Moving UP
				else if((player.upPressed || player.ySpeed < 0) && !player.downPressed && !player.leftPressed && !player.rightPressed)
				{
					if (!player.leftCollision && !player.rightCollision && 
						(player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) != "FloorTile"))
					{
						player.upCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					else if(player.leftCollision &&
						(player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) != "FloorTile"))
					{
						player.upCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					else if(player.rightCollision &&
						(player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() - 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) != "FloorTile"))
					{
						player.upCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					player.downCollision = false;
				}
				///Moving DOWN
				else if((player.downPressed || player.ySpeed > 0) && !player.upPressed && !player.leftPressed && !player.rightPressed)
				{
					if (!player.leftCollision && !player.rightCollision &&
						(player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) != "FloorTile"))
					{
						player.downCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y + 30 - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					else if (player.leftCollision &&
						(player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) != "FloorTile"))
					{
						player.downCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y + 30 - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					else if (player.rightCollision &&
						(player.hitTestObject(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile()][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) != "FloorTile"))
					{
						player.downCollision = true;
						world.y -=  world.tileList[getCurrentXTile()][getCurrentYTile()].y + 30 - (-world.y + global.screenHeight/2 - 25);
						player.ySpeed = 0;
					}
					player.upCollision = false
				}
				///Moving LEFT
				else if((player.leftPressed || player.xSpeed < 0) && !player.upPressed && !player.downPressed && !player.rightPressed)
				{
					if (!player.upCollision && !player.downCollision &&
					(player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) != "FloorTile"))
					{
						player.leftCollision = true;
						world.x -= (world.tileList[getCurrentXTile() - 1][getCurrentYTile()].x + 80 -(-world.x + global.screenWidth/2 - 25));
						player.xSpeed = 0;
					}
					else if (player.upCollision && 
						(player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() + 1]) != "FloorTile"))
					{
						player.leftCollision = true;
						world.x -= (world.tileList[getCurrentXTile() - 1][getCurrentYTile()].x + 80 -(-world.x + global.screenWidth/2 - 25));
						player.xSpeed = 0;
					}
					else if (player.downCollision && 
						(player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() - 1][getCurrentYTile() - 1]) != "FloorTile"))
					{
						player.leftCollision = true;
						world.x -= (world.tileList[getCurrentXTile() - 1][getCurrentYTile()].x + 80 -(-world.x + global.screenWidth/2 - 25));
						player.xSpeed = 0;
					}
					player.rightCollision = false;
				}
				///Moving RIGHT
				else if((player.rightPressed || player.xSpeed > 0) && !player.upPressed && !player.downPressed && !player.leftPressed)
				{
					if (!player.upCollision && !player.downCollision &&
						(player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) != "FloorTile"))
					{
						player.rightCollision = true;
						world.x -=  world.tileList[getCurrentXTile()][getCurrentYTile()].x + 30 - (-world.x + global.screenHeight/2 - 25);
						player.xSpeed = 0;
					}
					else if (player.upCollision && 
						(player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() + 1]) != "FloorTile"))
					{
						player.rightCollision = true;
						world.x -=  world.tileList[getCurrentXTile()][getCurrentYTile()].x + 30 - (-world.x + global.screenHeight/2 - 25);
						player.xSpeed = 0;
					}
					else if (player.downCollision &&
						(player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile()]) != "FloorTile" ||
						player.hitTestObject(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) && getQualifiedClassName(world.tileList[getCurrentXTile() + 1][getCurrentYTile() - 1]) != "FloorTile"))
					{
						player.rightCollision = true;
						world.x -=  world.tileList[getCurrentXTile()][getCurrentYTile()].x + 30 - (-world.x + global.screenHeight/2 - 25);
						player.xSpeed = 0;
					}
					player.leftCollision = false;
				}
				
				
				}
				else
				{					
					if(world.tileList[getCurrentXTile()][getCurrentYTile()] == 0)
					{
						player.health = 0;
					}
					else if(world.tileList[getCurrentXTile()][getCurrentYTile()] == 3)
					{
						player.health -= 3;
					}
				}
				///---------------------------
				///END OF COLLISION DETECTION
				///---------------------------
				
				///--------
				///PLAYER
				///--------
				player.controlPlayer();
				if((player.leftPressed || player.xSpeed < 0) && (player.rightPressed || player.xSpeed > 0))
					player.xSpeed = 0;
				else
					world.x -=  player.xSpeed;
				
				if((player.upPressed || player.ySpeed < 0) && (player.downPressed || player.ySpeed > 0))
					player.ySpeed = 0;
				else
					world.y -=  player.ySpeed;
				
				
				playerGraphic.rotation = (180/Math.PI) * Math.atan2(mouseY - 400, mouseX - 400);
				if(!player.moving && (player.upPressed || player.downPressed || player.leftPressed || player.rightPressed))
				{
					playerGraphic.play();
					player.moving = true;
				}
				else if(player.moving && (!player.upPressed && !player.downPressed && !player.leftPressed && !player.rightPressed))
				{
					playerGraphic.gotoAndStop(1);
					player.moving = false;
				}
				

				///---------------------
				///SPELL MANAGEMENT
				///---------------------
				
				/////////////////////////////////WIP///////////////////////////-------------------->
				
				//Changing Spells and adding cursors
				if(player.mouseScrolled || player.numberPressed)
				{
					//Remove cursor
					switch(player.spellActive)
					{
						case 1:
							cursor.removeChild(spell1Cursor);
							spell1Cursor.addedToWorld = false;
							break;
						case 2:
							cursor.removeChild(spell2Cursor);
							spell2Cursor.addedToWorld = false;
							break;
						case 3:
							cursor.removeChild(spell3Cursor);
							spell3Cursor.addedToWorld = false;
							break;
						case 7:
							cursor.removeChild(spell1Cursor);
							spell1Cursor.addedToWorld = false;
							break;
					}
					
					//Move Selector
					switch(player.hotbarSlotActive)
					{
						case 1:
							
							player.spellActive = player.hotbar1Slot;
							
							overlay.selector.y = 22.5;
							if(!spell1Cursor.addedToWorld)
							{
								cursor.addChild(spell1Cursor);
								spell1Cursor.startDrag(true);
								spell1Cursor.addedToWorld = true;
							}
							break;
						case 2:
						
							player.spellActive = player.hotbar2Slot;
						
							overlay.selector.y = 122.5;
							if(!spell2Cursor.addedToWorld)
							{
								cursor.addChild(spell2Cursor);
								spell2Cursor.startDrag(true);
								spell2Cursor.addedToWorld = true;
							}
							break;
						case 3:
						
							player.spellActive = player.hotbar3Slot;
						
							overlay.selector.y = 222.5;
							if(!spell3Cursor.addedToWorld)
							{
								overlay.selector.y = 222.5;
								cursor.addChild(spell3Cursor);
								spell3Cursor.addedToWorld = true;
							}
							break;
						case 4:
						
							player.spellActive = player.hotbar4Slot;
						
							overlay.selector.y = 322.5;
							if(!spell1Cursor.addedToWorld)
							{
								cursor.addChild(spell1Cursor);
								spell1Cursor.startDrag(true);
								spell1Cursor.addedToWorld = true;
							}
							break;
					}
					
				}
				
				//Spell Used
				if(player.mousePressed)
				{
					switch(player.spellActive)
					{
						case 1:
							if(player.spell1Ready && player.spell1Mana > player.spell1ManaCost)
							{
								shootSpell1();
								player.spell1Mana -= player.spell1ManaCost;
							}
							break;
						case 2:
							if(player.spell2Ready && player.spell2Mana > player.spell2ManaCost)
							{
								shootSpell2();
								player.spell2Mana -= player.spell2ManaCost;
							}
							break;
						case 3:
							if(player.spell3Ready && player.spell3Mana > player.spell3ManaCost && spell3Cursor.addedToWorld)
							{
								shootSpell3();
								player.spell3Mana -= player.spell3ManaCost;
							}
							break;
						case 4:
							useItem(getQualifiedClassName(overlay.hotbarItem));
							break;
						
					}
				}
				if(player.spacePressed)
				{
					useItem(getQualifiedClassName(overlay.hotbarItem));
				}
				
				//Moving Spells
				if(player.spellActive == 3)
				{
					if (player.mouseMoved)
					{
						spell3Cursor.x = getTileX(-world.x + mouseX) * global.tileSize + world.x;
						spell3Cursor.y = getTileY(-world.y + mouseY) * global.tileSize + world.y;
					}
				}
				
				//Overlay Mana Management
				overlay.hotbar1ManaBox.scaleX = 1 - player.spell1Mana/player.spell1MaxMana;
				overlay.hotbar2ManaBox.scaleX = 1 - player.spell2Mana/player.spell2MaxMana;
				overlay.hotbar3ManaBox.scaleX = 1 - player.spell3Mana/player.spell3MaxMana;
				
				/////////////////////////////////WIP///////////////////////////-------------------->\\

				manageProjectiles();
				
				//---------------
				//End level
				//---------------
				/*if(player.health <= 0)
				{
					loseLevel();
				}*/
			}
			else
			{
				
				//Pause menu stuff
			}
			
		}

		public function manageProjectiles():void
		{
			
			for (var a:int = 0; a < projectilesList.length; a++)
			{
				if(world.contains(projectilesList[a]))
				{
					//PROJECTILE MOVING
					projectilesList[a].x += projectilesList[a].velocityX;
					projectilesList[a].y += projectilesList[a].velocityY;
				}
				//PROJECTILE REMOVAL OFF-SCREEN
				if (checkOnScreen(projectilesList[a].x, projectilesList[a].y) == false)
				{
					world.frontObjects.removeChild(projectilesList[a]);
					projectilesList.splice(a, 1);
				}
				//PROJECTILE REMOVAL COLLISION WITH WALL
				else if(projectilesList[a].x > 80 && projectilesList[a].x < world.worldSize * global.tileSize && projectilesList[a].y > 80 && projectilesList[a].y < world.worldSize * global.tileSize)
				{
					if(levelNumber != 4 || levelNumber != 5)
					{
						if(projectilesList[a].hitTestObject(world.tileList[getTileX(projectilesList[a].x)][getTileY(projectilesList[a].y)]) &&
							getQualifiedClassName(world.tileList[getTileX(projectilesList[a].x)][getTileY(projectilesList[a].y)]) != "FloorTile")
						{
							//Shovel
							if(projectilesList[a].projectileType == 3)
							{//Check outer edge boundary
								if(getTileX(projectilesList[a].x) > 0 && getTileX(projectilesList[a].x) < 32 && getTileY(projectilesList[a].y) > 0 && getTileY(projectilesList[a].y) < 32)
									world.replaceDirtWall(getTileX(projectilesList[a].x), getTileY(projectilesList[a].y));
							}
							
							world.frontObjects.removeChild(projectilesList[a]);
							projectilesList.splice(a, 1);
						}
					}
				}
				if(projectilesList[a].projectileType == 2)
				{
					if (Math.pow(160, 2) <= Math.pow(((-world.x + global.screenWidth/2) - projectilesList[a].x), 2) + Math.pow(((-world.y + global.screenWidth/2) - projectilesList[a].y), 2))
					{
						world.frontObjects.removeChild(projectilesList[a]);
					    projectilesList.splice(a, 1);
					}
				}
			}
			//AoE
			if(player.spell3Finished){
				for(var a:int = 0; a < aoeTiles.length; a++)
				{
					world.backObjects.removeChild(aoeTiles[a]);
				}
				aoeTiles = [];
				player.spell3Finished = false;
			}
			
			//ENEMY PROJECTILES
			for(var a:int = 0; a < enemyProjectilesList.length; a++)
			{
				if(world.contains(enemyProjectilesList[a]))
				{
					//PROJECTILE MOVING
					enemyProjectilesList[a].x += enemyProjectilesList[a].velocityX;
					enemyProjectilesList[a].y += enemyProjectilesList[a].velocityY;
					if(player.hitTestObject(enemyProjectilesList[a]))
					{
						player.health -=  enemyProjectilesList[a].damage;
						world.frontObjects.removeChild(enemyProjectilesList[a]);
						enemyProjectilesList.splice(a, 1);
					}
				}
				//PROJECTILE REMOVAL OFF-SCREEN
				if (checkOnScreen(enemyProjectilesList[a].x, enemyProjectilesList[a].y) == false)
				{
					world.frontObjects.removeChild(enemyProjectilesList[a]);
					enemyProjectilesList.splice(a, 1);
				}
			}
		}

		public function shootSpell1():void
		{
			projectile1 = new Projectile1(player.x - world.x, player.y - world.y, stage.mouseX, stage.mouseY, player.x, player.y);		
			projectilesList.push(projectile1);
			player.spell1Ready = false;
			player.spell1DelayTimer.start();
			world.frontObjects.addChild(projectile1);
		}
		public function shootSpell2():void
		{
			projectile2 = new Projectile2(player.x - world.x, player.y - world.y, stage.mouseX, stage.mouseY, player.x, player.y);
			projectilesList.push(projectile2);
			player.spell2Ready = false;
			player.spell2DelayTimer.start();
			world.frontObjects.addChild(projectile2);
		}
		public function shootSpell3():void
		{
			var aoeTilePosition:Array = [[0, -2], [-1, -1], [0, -1], [1, -1], [-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0], [-1, 1], [0, 1], [1, 1], [0, 2]];//Tile position in diamond
			for(var a:int = 0; a < aoeTilePosition.length; a++)
			{
				//Only add to floorTiles
				if(getQualifiedClassName(world.tileList[getTileX(mouseX - world.x) + aoeTilePosition[a][0]][getTileY(mouseY - world.y) + aoeTilePosition[a][1]]) == "FloorTile")
				{
					aoeBlock = new AoEBlock((getTileX(mouseX - world.x) + aoeTilePosition[a][0]) * global.tileSize, (getTileY(mouseY - world.y) + aoeTilePosition[a][1]) * global.tileSize);
					aoeTiles.push(aoeBlock);
					world.backObjects.addChild(aoeBlock);
				}
			}
			player.spell3Ready = false;
			player.spell3DelayTimer.start();
			player.spell3ActiveTimer.start();
		}
		
		public function shootShovel():void
		{
			projectileShovel = new ProjectileShovel(player.x - world.x, player.y - world.y, stage.mouseX, stage.mouseY, player.x, player.y);		
			projectilesList.push(projectileShovel);
			player.shovelReady = false;
			player.shovelDelayTimer.start();
			world.frontObjects.addChild(projectileShovel);
		}
		
		public function useItem(itemName:String):void
		{
			switch(itemName)
			{
				case "HealthPotion":
					if(player.health < 100)
					{
						player.health += 50;
						
						overlay.removeChild(overlay.hotbarItem);
						overlay.hotbarItem = 0;
					}
					break;
				case "Scroll":
					player.maxHealth += 20;
					player.health += 20;
				
					overlay.removeChild(overlay.hotbarItem);
					overlay.hotbarItem = 0;
					break;
				case "KeyItem":
					if(player.hitTestObject(world.tileList[world.doorX][world.doorY]))
					{
						overlay.removeChild(overlay.hotbarItem);
						overlay.hotbarItem = 0;
						finishLevel();
					}
					break;
				case "Shovel":
					if(player.shovelReady && levelNumber == 3)
					{
						shootShovel();
					}
					break;
			}
		}
		
		public function getCurrentXTile():int
		{
			var currentXTile:int = Math.floor((-world.x + player.x)/global.tileSize);
			return currentXTile;
		}

		public function getCurrentYTile():int
		{
			var currentYTile:int = Math.floor((-world.y + player.y)/global.tileSize);
			return currentYTile;
		}

		public function getTileX(posX:int):int{
			return Math.floor(posX/global.tileSize);
		}

		public function getTileY(posY:int):int{
			return Math.floor(posY/global.tileSize);
		}

		public function checkOnScreen(objX:Number, objY:Number):Boolean
		{
			if (objX > -world.x - 150 && objX < -world.x + global.screenWidth + 150 && objY > -world.y - 150 && objY < -world.y + global.screenHeight + 150)
				return true;
			else
				return false;
		}

	    static function getClass(obj:Object):Class
        {
        return Class(flash.utils.getDefinitionByName(getQualifiedClassName(obj)));
        }
	
	
		public function endLevel():void
		{
			gamePaused = true;
			projectilesList = [];
			
			removeChild(world);
			removeChild(player);
			removeChild(playerGraphic);
			removeChild(overlay);
			removeChild(cursor);
			
			//Remove Shovel at end of level
			if(levelNumber == 1)
			{
				removeChild(rainFilter);
				removeChild(darkFilter);
			}
			else if(levelNumber == 3)
			{
				wormArray = [0, 0, 0, 0, 0, 0, 0, 0, 0];
			}
			
			bgmSoundChannel.stop();
			bgmPlaying = false;
			startLevel();
		}
		
		public function startLevel():void
		{
			levelNumber++;
			world.enemyList = [];
			world = new World();
			addChild(world);
			world.generateWorld(levelNumber, hardmode);
			//world.scaleX = 0.2;
			//world.scaleY = 0.2;
			player = new Player(global.screenWidth / 2, global.screenHeight / 2);
			addChild(player);
			playerGraphic = new PlayerGraphic(global.screenWidth / 2, global.screenHeight / 2);
			addChild(playerGraphic);
			playerGraphic.stop();
			
			//Extra additions to levels
			switch(levelNumber)
			{
				case 1:
					collisionsEnabled = true;
					rainFilter = new RainFilter(0, 0);
					addChild(rainFilter);
					darkFilter = new DarkFilter(0, 0);
					addChild(darkFilter);
					var bgm1:Music1 = new Music1();
					bgmSoundChannel = bgm1.play(0, 999);
					break;
				case 2:
					collisionsEnabled = true;
					//var bgm2:Music1 = new Music1();
					//bgmSoundChannel = bgm2.play(0, 999);
					break;
				case 3:
					collisionsEnabled = true;
					var bgm3:Music3 = new Music3();
					bgmSoundChannel = bgm3.play(0, 999);
					break;
				case 4:
					collisionsEnabled = false;
					var darkness:Darkness = new Darkness(0, 0);
					addChild(darkness);
					//var bgm4:Music1 = new Music1();
					//bgmSoundChannel = bgm4.play(0, 999);
					break;
				case 5:
					collisionsEnabled = false;
					//var bgm5:Music1 = new Music1();
					//bgmSoundChannel = bgm5.play(0, 999);
					bossWaveTimer.addEventListener(TimerEvent.TIMER, bossWaveRefresh);
					bossWaveTimer.start();
					break;
			}
			
			addChild(cursor);
			cursor.addChild(spell1Cursor);
			spell1Cursor.startDrag(true);
			
			addChild(overlay);

			bgmPlaying = true;
			gamePaused = false;
		}
		
		public function knockbackPlayer(enemyX:Number, enemyY:Number, playerX:Number, playerY:Number, knockbackAmount:int):void
		{
			if(playerX > enemyX && playerY > enemyY) //Player down-right of enemy
			{
				player.xSpeed = knockbackAmount;
				player.ySpeed = knockbackAmount;
			}
			else if(playerX > enemyX && playerY < enemyY) //Player up-right of enemy
			{
				player.xSpeed = knockbackAmount;
				player.ySpeed = -knockbackAmount;
			}
			else if(playerX < enemyX && playerY > enemyY) //Player down-left of enemy
			{
				player.xSpeed = -knockbackAmount;
				player.ySpeed = knockbackAmount;
			}
			else if(playerX < enemyX && playerY < enemyY) //Player up-left of enemy
			{
				player.xSpeed = -knockbackAmount;
				player.ySpeed = -knockbackAmount;
			}
		}
		
		public function loseLevel():void
		{
			gamePaused = true;
			screenTimer.start();
			addChild(deathScene);
			
		}
		public function deathScreenRefresh(e:TimerEvent):void
		{
			screenTimer.stop();
			removeChild(deathScene);
			levelNumber--;
			endLevel();
		}
		
		public function finishLevel():void
		{
			gamePaused = true;
			screenFinishLevelTimer.start();
			addChild(deathScene);
			
			/*switch(levelNumber)
			{
				case 1:
					
			}*/
		}
		public function finishLevelRefresh(e:TimerEvent):void
		{
			screenFinishLevelTimer.stop();
			removeChild(deathScene);
			endLevel();
		}
		
		public function bossWaveRefresh(e:TimerEvent):void{
			bossWaveTimer.stop();
			world.spawnWave(getCurrentXTile());
			bossWaveTimer.start();
		}

	}





}