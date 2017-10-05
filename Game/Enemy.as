package 
{
	import flash.display.MovieClip;

	public class Enemy extends MovieClip
	{
		var distMoved:int = 1000; //Just a big number
		
		var moveUp:Boolean;
		var moveDown:Boolean;
		var moveLeft:Boolean;
		var moveRight:Boolean;
		var movementDir:int = 0;
		
		var onScreen:Boolean = false;
		
		var global:GlobalVariables = new GlobalVariables();
		
		public function getMoveDirection(X:Number,Y:Number,playerX:Number,playerY:Number,floorUp:Boolean,floorDown:Boolean,floorLeft:Boolean, floorRight:Boolean):int
		{			
			if ((X - playerX) > 0 && (Y - playerY) > 0) //Player up-left of enemy
			{
				if (floorLeft == true && floorUp == true)
				{
					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
					{
						//move left
						return 1;
					}
					else
					{
						//move up
						return 2;
					}
				}
				else if (floorLeft == true && floorUp == false)
				{
					//move left
					return 1;
				}
				else if (floorLeft == false && floorUp == true)
				{
					//move up
					return 2;
				}
				//If nothing is possible Move either right or down
				else
				{
					if (floorRight == true && global.randomRange(0,1) == 0)
					{
						return 4;
					}
					else if (floorDown == true && global.randomRange(0,1) == 0)
					{
						return 3;
					}
				}
				
			}
			else if ((X - playerX) > 0 && (Y - playerY) < 0) //Player down-left of enemy
			{
				if (floorLeft == true && floorDown == true)
				{
					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
					{
						//move left
						return 1;
					}
					else
					{
						//move down
						return 3;
					}
				}
				else if (floorLeft == true && floorDown == false)
				{
					//move left
					return 1;
				}
				else if (floorLeft == false && floorDown == true)
				{
					//move down
					return 3;
				}
				//If nothing is possible Move either right or up
				else
				{ 
				
					if (floorRight == true && global.randomRange(0,1) == 0)
					{
						return 4;
					}
					else if (floorUp == true && global.randomRange(0,1) == 0)
					{
						return 2;
					}
				}
			}
			else if ((X - playerX) < 0 && (Y - playerY) > 0) //Player up-right of enemy
			{
				if (floorRight == true && floorUp == true)
				{
					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
					{
						//move right
						return 4;
					}
					else
					{
						//move up
						return 2;
					}
				}
				else if (floorRight == true && floorUp == false)
				{
					//move right
					return 4;
				}
				else if (floorRight == false && floorUp == true)
				{
					//move up
					return 2;
				}
				//If nothing is possible Move either left or down
				else
				{
					if (floorLeft == true && global.randomRange(0,1) == 0)
					{
						return 1;
					}
					else if (floorDown == true && global.randomRange(0,1) == 0)
					{
						return 3;
					}
				}
			}
			else if ((X - playerX) < 0 && (Y - playerY) < 0) //Player down-right of enemy
			{
				if (floorRight == true && floorDown == true)
				{
					if (Math.abs((X - playerX)) > (Math.abs((Y-playerY))))
					{
						//move right
						return 4;
					}
					else
					{
						//move down
						return 3;
					}
				}
				else if (floorRight == true && floorDown == false)
				{
					//move right
					return 4;
				}
				else if (floorRight == false && floorDown == true)
				{
                    //move down
					return 3;
				}
				//If nothing is possible Move either left or up
				else
				{
					if (floorUp == true && global.randomRange(0,1) == 0)
					{
						return 2;
					}
					else if (floorLeft == true && global.randomRange(0,1) == 0)
					{
						return 1;
					}
				}
			}
			return 0;
		
		}
	}
}