package 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.getQualifiedClassName;
	import flash.ui.Keyboard;

	public class World extends Sprite
	{
		
		private var global:GlobalVariables = new GlobalVariables();
		public var worldSize:int;
		
		//Items
		public var item:Item;
		public var healthPotion:HealthPotion;
		public var spellItem:SpellItem;
		public var keyItem:KeyItem;
		public var shovel:Shovel;
		
		private var antX:int = 2;
		private var antY:int = 2;
		private var finalX:int;
		private var finalY:int;
		
		public var doorX:int;
		public var doorY:int;
		
		//Circle generation variables
		private var circleRadius:int;
		private var circleX:int = 3;
		private var circleY:int = 3;
		private var circleXPoints:Array = [];
		private var circleYPoints:Array = [];
		
		public var tileList:Array = [];
		
		public var floorTile:FloorTile;
		private var doorTile:DoorTile;
		
		private var woodTile:WoodTile;
		public var wallTile:WallTile;
		
		private var temp1Tile:Temp1Tile;
		private var temp2Tile:Temp2Tile;
		private var temp3Tile:Temp3Tile;
		
		private var grassTile:GrassTile;
		private var treeTile:TreeTile;
		
		private var dirtfloorTile:DirtfloorTile;
		private var dirtwallTile:DirtwallTile;
		
		private var platformTile:PlatformTile;
		
		private var magmaRockTile:MagmaRockTile;
		private var magmaTile:MagmaTile;
		
		public var itemList:Array = [];
		
		public var backObjects:Sprite = new Sprite();
		public var frontObjects:Sprite = new Sprite();
		public var wallLayer:Sprite = new Sprite();
		public var floorLayer:Sprite = new Sprite();
		public var bossLayer:Sprite = new Sprite();
		
		private var enemyWolf:Sprite;
		private var enemyWolfDistanceFromSpawn:int = 3;
		
		private var enemySpider:Sprite;
		private var enemySpiderDistanceFromSpawn:int = 6;
		
		private var enemySlime:Sprite;
		private var enemySlimeDistanceFromSpawn:int = 12;
		
		private var enemyRat:Sprite;
		private var enemyRatDistanceFromSpawn:int = 16;
		
		private var enemyDragon:Sprite;
		private var enemyDragonDistanceFromSpawn:int = 18;
		
		private var enemyWorm:Sprite;
		private var enemyWormSegment:Sprite;
		private var enemyWormTail:Sprite;
		
		private var enemyAnt:Sprite;
		
		private var enemyMaggot:Sprite;
		
		private var enemyWisp1:Sprite;
		private var enemyWisp2:Sprite;
		
		private var enemyRam:Sprite;
		
		private var enemyRat2:Sprite;
		private var enemyDragon2:Sprite;
		
		public var enemyList:Array = [];
		public var enemyHealthBarList:Array = [];
		
		public var enemyHealthBar:EnemyHealthBar;
		
		private var waveSize:Number = 3;
		

		public function generateWorld(levelNumber:int, hardmodeActive:Boolean):void
		{
			if (levelNumber == 1)
			{
				//Level Variables
				worldSize = 40;
				
				var enemyWolfNumber:int = 10;
				
				
				for (var a:int = 0; a < worldSize; a++)
				{
					tileList.push(new Array());
					for (var b:int = 0; b < worldSize; b++)
					{
						floorTile = new FloorTile(global.tileSize * a,global.tileSize * b);
						addChild(floorTile);
						tileList[a].push(floorTile);
					}
				}
				
				
				for(var a:int = 0; a < worldSize; a++)
				{
					for(var b:int = 0; b < worldSize; b++)
					{
						//Replace edge tiles
						if(a == 0 || a == worldSize - 1 || b == 0 || b == worldSize - 1)
						{
							removeChild(tileList[a][b]);
							treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
							tileList[a][b] = treeTile;
							addChild(treeTile);
						}
						//Dense forest on left
						else if(a <= (0.2 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 3)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						//Dense forest on right
						else if(a >= (0.8 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 3)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						//Dense forest on up
						else if(b <= (0.2 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 3)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						//Dense forest on down
						else if(b >= (0.8 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 3)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						
						/////////SPARSE\\\\\\\\\
						//Sparse forest on left
						else if(a <= (0.4 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 5)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						//Sparse forest on right
						else if(a >= (0.6 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 5)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						//Sparse forest on up
						else if(b <= (0.4 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 5)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						//Sparse forest on down
						else if(b >= (0.6 * worldSize))
						{
							var s:int = global.randomRange(0, 9)
							if(s > 5)
							{
   								removeChild(tileList[a][b]);
								treeTile = new TreeTile(a * global.tileSize, b * global.tileSize);
								tileList[a][b] = treeTile;
								addChild(treeTile);
							}
						}
						
					}
				}
				////////Ant paths
				//Calculate end point
				
				//Ant path 1
				finalX = worldSize / 2;
				finalY = worldSize / 2;
	
				while (antX != finalX || antY != finalY)
				{
					var coin:Number = global.randomRange(0,1);
					if (coin == 0 && antX != finalX)
					{
						antX++;
						if(getQualifiedClassName(tileList[antX][antY]) == "TreeTile")
						{
							removeChild(tileList[antX][antY]);
						}
						floorTile = new FloorTile(antX * global.tileSize, antY * global.tileSize);
						tileList[antX][antY] = floorTile;
						addChild(floorTile);
					}
					else if (coin == 1 && finalY != antY)
					{
						antY++;
						if(getQualifiedClassName(tileList[antX][antY]) == "TreeTile")
						{
							removeChild(tileList[antX][antY]);
						}
						floorTile = new FloorTile(antX * global.tileSize, antY * global.tileSize);
						tileList[antX][antY] = floorTile;
						addChild(floorTile);
					}
				}
				
				//Ant path 2
				
				//Calculate end point
				
				while(finalX < worldSize * 0.8 && finalY < worldSize * 0.8)
				{
					finalX = global.randomRange(1, worldSize - 2);
					finalY = global.randomRange(1, worldSize - 2);
				}
				while (antX != finalX || antY != finalY)
				{
					
					var coin:Number = global.randomRange(0,1);	
					
					if (antX <= finalX && antY <= finalY)
					{
						if (coin == 0 && antX != finalX)
						{
							antX++;
							if (getQualifiedClassName(tileList[4][4]) == "TreeTile")
								removeChild(tileList[antX][antY]);
						}
						else if (coin == 1 && finalY != antY)
						{
							antY++;
							if (getQualifiedClassName(tileList[4][4]) == "TreeTile")
								removeChild(tileList[antX][antY]);
						}
					}
					else if (antX >= finalX && antY <= finalY)
					{
						if (coin == 0 && antX != finalX)
						{
							antX--;
							if (getQualifiedClassName(tileList[4][4]) == "TreeTile")
							removeChild(tileList[antX][antY]);
						}
						else if (coin == 1 && finalY != antY)
						{
							antY++;
							if (getQualifiedClassName(tileList[4][4]) == "TreeTile")
								removeChild(tileList[antX][antY]);
						}
					}
					else if (antX <= finalX && antY >= finalY)
					{
						if (coin == 0 && antX != finalX)
						{
							antX++;
							if (getQualifiedClassName(tileList[4][4]) == "TreeTile")
								removeChild(tileList[antX][antY]);
						}
						else if (coin == 1 && finalY != antY)
						{
							antY--;
							if (getQualifiedClassName(tileList[4][4]) == "TreeTile")
								removeChild(tileList[antX][antY]);
						}
					}
					floorTile = new FloorTile(antX * global.tileSize, antY * global.tileSize);
					tileList[antX][antY] = floorTile;
					addChild(floorTile);
				}
				
				
				
				doorX = finalX;
				doorY = finalY;
					
					
				
				
				//Remove tiles at spawn
				if(getQualifiedClassName(tileList[4][4]) == "TreeTile")
				{
					if (contains(tileList[4][4]))
						removeChild(tileList[4][4]);
					
					floorTile = new FloorTile(4 * global.tileSize, 4 * global.tileSize);
					tileList[4][4] = addChild(floorTile);
				
				}
				if(getQualifiedClassName(tileList[5][4]) == "TreeTile")
				{
					if (contains(tileList[5][4]))
						removeChild(tileList[5][4]);

					floorTile = new FloorTile(5 * global.tileSize, 4 * global.tileSize);
					tileList[5][4] = addChild(floorTile);
				
				}
				if(getQualifiedClassName(tileList[4][5]) == "TreeTile")
				{
					if (contains(tileList[4][5]))
						removeChild(tileList[4][5]);
					
					floorTile = new FloorTile(4 * global.tileSize, 5 * global.tileSize);
					tileList[4][5] = addChild(floorTile);
						
				}
				if(getQualifiedClassName(tileList[5][5]) == "TreeTile")
				{
					if (contains(tileList[5][5]))
						removeChild(tileList[5][5]);
					
					floorTile = new FloorTile(5 * global.tileSize, 5 * global.tileSize);
					tileList[5][5] = addChild(floorTile);
					
				}
				
				//Place "FloorTile" Sprite over all FloorTiles
				
				for (var a:int = 0; a < worldSize - 1; a++)
				{
					for (var b:int = 0; b < worldSize - 1; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "FloorTile")
						{
							grassTile = new GrassTile(a * global.tileSize, b * global.tileSize);
							addChild(grassTile);
						}
					}
				}
				
				removeChild(tileList[doorX][doorY]);
				doorTile = new DoorTile(doorX * global.tileSize, doorY * global.tileSize);
				tileList[doorX][doorY] = doorTile;
				addChild(doorTile);
			
				floorTile = new FloorTile(doorX * global.tileSize, doorY * global.tileSize);
				tileList[doorX][doorY] = floorTile;
				addChild(floorTile);
				
				
				
				addChild(backObjects);
				addChild(frontObjects);
				
				addItem(keyItem, KeyItem, worldSize / 2 * global.tileSize, worldSize / 2 * global.tileSize);
				
				//-------------
				//SPAWN ENEMIES
				//-------------
				//Enemy Wolf
				for(var c:int = 0; c < enemyWolfNumber; c++){
					//Position and distance from spawn
					a = 0;
					b = 0;
					while (getQualifiedClassName(tileList[a][b]) != "FloorTile" || a < enemyWolfDistanceFromSpawn || b < enemyWolfDistanceFromSpawn){
						a = global.randomRange(1,worldSize - 1);
						b = global.randomRange(1,worldSize - 1);
							
					}
					enemyWolf = new EnemyWolf(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyList.push(enemyWolf);
					frontObjects.addChild(enemyWolf);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
					a = 0;
					b = 0;
				}
				
				
			}
			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			else if(levelNumber == 2)
			{
				
				//Level Variables
				
				worldSize = 50;
				
				var enemySpiderNumber:int = 15;
				var enemySlimeNumber:int = 8;
				var enemyRatNumber:int = 12;
				var enemyDragonNumber:int = 6;
				
				
				var pathNumber:int = 1;

				var circleNumber:int = 10;
				
				
				//Create wall tile at every point
				for (var a:int = 0; a < worldSize; a++)
				{
					tileList.push(new Array());
					for (var b:int = 0; b < worldSize; b++)
					{
						wallTile = new WallTile(global.tileSize * a, global.tileSize * b);
						addChild(wallTile);
						tileList[a].push(wallTile);
					}
				}

				//Random ant path
				for (var d:int = 0; d < pathNumber; d++)
				{
					//Calculate end point
					while (finalX < worldSize - 5 && finalY < worldSize - 5)
					{
						finalX = global.randomRange(20,worldSize - 3);
						finalY = global.randomRange(20,worldSize - 3);
					}
	
					while (antX != finalX || antY != finalY)
					{
						var coin:Number = global.randomRange(0,1);
						if (coin == 0 && antX != finalX)
						{
							antX++;
							//if (contains(tileList[antX][antY]))
							//{
								removeChild(tileList[antX][antY]);
							//}
							
							floorTile = new FloorTile(antX * global.tileSize, antY * global.tileSize);
							tileList[antX][antY] = floorTile;
							addChild(floorTile);
						}
						else if (coin == 1 && finalY != antY)
						{
							antY++;
							//if (contains(tileList[antX][antY]))
							//{
								removeChild(tileList[antX][antY]);
							//}
							floorTile = new FloorTile(antX * global.tileSize, antY * global.tileSize);
							tileList[antX][antY] = floorTile;
							addChild(floorTile);
						}

					}
					//Add door at end of path
					if(d == pathNumber - 1)
					{
						//removeChild(tileList[finalX][finalY]);
						
						doorX = finalX;
						doorY = finalY;
					}
					antX = 3;
					antY = 3;
					finalX = 0;
					finalY = 0;
					
				}
			
				//Generate Circle
				for (var a:int = 0; a < circleNumber; a++){
					for (var b:int = 0; b < worldSize; b++){
						for (var c:int = 0; c < worldSize; c++){
							
							if (Math.pow(circleRadius, 2) >= Math.pow((b - circleX), 2) + Math.pow((c - circleY), 2))
							{
								if (contains(tileList[b][c]))
									removeChild(tileList[b][c]);
									
								floorTile = new FloorTile(b * global.tileSize, c * global.tileSize);
								tileList[b][c] = floorTile;
								addChild(floorTile);
							}
						}
					}
					
					circleXPoints.push(circleX);
					circleYPoints.push(circleY);

					circleX = global.randomRange(7,worldSize - 7);
					circleY = global.randomRange(7,worldSize - 7);
					circleRadius = global.randomRange(2,4);
				}
				
				//Path from circle to circle
				for (var a:int = 0; a < circleNumber-1; a++)
				{
					antX = circleXPoints[a];
					antY = circleYPoints[a];
					finalX = circleXPoints[a + 1];
					finalY = circleYPoints[a + 1];
					while (antX != finalX || antY != finalY)
					{
						var coin:Number = global.randomRange(0,1);	
					
						if (antX <= finalX && antY <= finalY)
						{
							if (coin == 0 && antX != finalX)
							{
								antX++;
								if (contains(tileList[antX][antY]))
									removeChild(tileList[antX][antY]);
							}
							else if (coin == 1 && finalY != antY)
							{
								antY++;
								if (contains(tileList[antX][antY]))
									removeChild(tileList[antX][antY]);
							}
						}
						else if (antX >= finalX && antY <= finalY)
						{
							if (coin == 0 && antX != finalX)
							{
								antX--;
								if (contains(tileList[antX][antY]))
								removeChild(tileList[antX][antY]);
							}
							else if (coin == 1 && finalY != antY)
							{
								antY++;
								if (contains(tileList[antX][antY]))
									removeChild(tileList[antX][antY]);
							}
						}
						else if (antX <= finalX && antY >= finalY)
						{
							if (coin == 0 && antX != finalX)
							{
								antX++;
								if (contains(tileList[antX][antY]))
									removeChild(tileList[antX][antY]);
							}
							else if (coin == 1 && finalY != antY)
							{
								antY--;
								if (contains(tileList[antX][antY]))
									removeChild(tileList[antX][antY]);
							}
						}
						else if (antX >= finalX && antY >= finalY)
						{
							if (coin == 0 && antX != finalX)
							{
								antX--;
								if (contains(tileList[antX][antY]))
									removeChild(tileList[antX][antY]);
							}
							else if (coin == 1 && finalY != antY)
							{
								antY--;
								if (contains(tileList[antX][antY]))
									removeChild(tileList[antX][antY]);
							}
						}
						floorTile = new FloorTile(antX * global.tileSize, antY * global.tileSize);
						tileList[antX][antY] = floorTile;
						addChild(floorTile);
					}
				}
			
				
		
				//Remove tiles at spawn
				if(getQualifiedClassName(tileList[4][4]) == "WallTile")
				{
					if (contains(tileList[4][4]))
						removeChild(tileList[4][4]);
					
					floorTile = new FloorTile(4 * global.tileSize, 4 * global.tileSize);
					tileList[4][4] = addChild(floorTile);
				
				}
				if(getQualifiedClassName(tileList[5][4]) == "WallTile")
				{
					if (contains(tileList[5][4]))
						removeChild(tileList[5][4]);

					floorTile = new FloorTile(5 * global.tileSize, 4 * global.tileSize);
					tileList[5][4] = addChild(floorTile);
				
				}
				if(getQualifiedClassName(tileList[4][5]) == "WallTile")
				{
					if (contains(tileList[4][5]))
						removeChild(tileList[4][5]);
					
					floorTile = new FloorTile(4 * global.tileSize, 5 * global.tileSize);
					tileList[4][5] = addChild(floorTile);
						
				}
				if(getQualifiedClassName(tileList[5][5]) == "WallTile")
				{
					if (contains(tileList[5][5]))
						removeChild(tileList[5][5]);
					
					floorTile = new FloorTile(5 * global.tileSize, 5 * global.tileSize);
					tileList[5][5] = addChild(floorTile);
					
				}
			
			
				//Remove other tiles
				for (var a:int = 1; a < worldSize - 1; a++){
					for (var b:int = 1; b < worldSize - 1; b++){
						
						wallTile = new WallTile(a,b);
						
						if (getQualifiedClassName(tileList[a][b]) == "WallTile"){
							if ((getQualifiedClassName(tileList[a][Math.abs(b-1)]) == "WallTile" || getQualifiedClassName(tileList[a][Math.abs(b-1)]) == "Temp3Tile") &&
							(getQualifiedClassName(tileList[a][b+1]) == "WallTile" || getQualifiedClassName(tileList[a][b+1]) == "Temp3Tile") &&
							(getQualifiedClassName(tileList[Math.abs(a-1)][b]) == "WallTile" || getQualifiedClassName(tileList[Math.abs(a-1)][b]) == "Temp3Tile") &&
							(getQualifiedClassName(tileList[a+1][b]) == "WallTile" || getQualifiedClassName(tileList[a+1][b]) == "Temp3Tile")){
								removeChild(tileList[a][b]);
								temp3Tile = new Temp3Tile(global.tileSize * a,global.tileSize * b);
								tileList[a][b] = addChild(temp3Tile);
							}
						}
					}
				}
			
				//Remove edge tiles
				for (var a:int = 0; a < worldSize - 1; a++)//Top
				{
					removeChild(tileList[a][0]);
					temp1Tile = new Temp1Tile(global.tileSize * a, 0);
					tileList[a][0] = addChild(temp1Tile);
				}
				for (var a:int = 0; a < worldSize - 1; a++)//Bottom
				{
					removeChild(tileList[a][worldSize -1]);
					temp1Tile = new Temp1Tile(global.tileSize * a, global.tileSize * (worldSize -1));
					tileList[a][worldSize -1] = addChild(temp1Tile);
				}
				for (var a:int = 0; a < worldSize; a++)//Right
				{
					removeChild(tileList[worldSize - 1][a]);
					temp1Tile = new Temp1Tile(global.tileSize * (worldSize - 1),global.tileSize * a);
					tileList[worldSize - 1][a] = addChild(temp1Tile);
				}
				for (var a:int = 0; a < worldSize - 1; a++)//Left
				{
					removeChild(tileList[0][a]);
					temp1Tile = new Temp1Tile(0,global.tileSize * a);
					tileList[0][a] = addChild(temp1Tile);
				}
				
				//Remove all temp1Tiles
				for (var a:int = 0; a < worldSize; a++)
				{
					for (var b:int = 0; b < worldSize; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "Temp1Tile")
						{
							removeChild(tileList[a][b]);
							
							
						}
					}
				}
			
				//Fill corners with wall
				for (var a:int = 1; a < worldSize - 1; a++)
				{
					for (var b:int = 1; b < worldSize - 1; b++)
					{var adjacentFloorTiles:int = 0;
						if (getQualifiedClassName(tileList[a][b]) == "Temp3Tile")
						{
							if (getQualifiedClassName(tileList[a][b-1]) == "WallTile")
							{
								adjacentFloorTiles++;
							}
							if (getQualifiedClassName(tileList[a-1][b]) == "WallTile")
							{
								adjacentFloorTiles++;
							}
							if (getQualifiedClassName(tileList[a+1][b]) == "WallTile")
							{
								adjacentFloorTiles++;
							}
							if (getQualifiedClassName(tileList[a][b+1]) == "WallTile")
							{
								adjacentFloorTiles++;
							}
							if (adjacentFloorTiles > 1 && adjacentFloorTiles < 4)
							{
								removeChild(tileList[a][b]);
								temp2Tile = new Temp2Tile(global.tileSize * a,global.tileSize * b);
								tileList[a][b] = addChild(temp2Tile);
							}
						}

					}
				}
			
				//Replace all temp2Tiles
				for (var a:int = 0; a < worldSize - 1; a++)
				{
					for (var b:int = 0; b < worldSize - 1; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "Temp2Tile")
							{
								removeChild(tileList[a][b]);
								wallTile = new WallTile(global.tileSize * a,global.tileSize * b);
								tileList[a][b] = addChild(wallTile);
							}
					}
				}
			
				//Remove all temp3Tiles
				for (var a:int = 0; a < worldSize - 1; a++)
				{
					for (var b:int = 0; b < worldSize - 1; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "Temp3Tile")
						{
							removeChild(tileList[a][b]);
							//temp3Tile = new temp1Tile(global.tileSize * a,global.tileSize * b);
							//tileList[a][b] = addChild(temp1Tile);
						}
					}
				}
				
				//Place "FloorTile" Sprite over all FloorTiles
				
				for (var a:int = 0; a < worldSize - 1; a++)
				{
					for (var b:int = 0; b < worldSize - 1; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "FloorTile")
						{
							woodTile = new WoodTile(a * global.tileSize, b * global.tileSize);
							addChild(woodTile);
						}
					}
				}
				
				removeChild(tileList[doorX][doorY]);
				doorTile = new DoorTile(doorX*global.tileSize, doorY*global.tileSize);
				tileList[doorX][doorY] = doorTile;
				addChild(doorTile);
				
				floorTile = new FloorTile(doorX * global.tileSize, doorY * global.tileSize);
				tileList[doorX][doorY] = floorTile;
				addChild(floorTile);
				
				addChild(backObjects);
				addChild(frontObjects);
				
				//-------------
				//SPAWN ENEMIES
				//-------------
				//Enemy 1
				for (var c:int = 0; c < enemySpiderNumber; c++){
					//Position and distance from spawn
					while (getQualifiedClassName(tileList[a][b]) != "FloorTile" || (a < enemySpiderDistanceFromSpawn && b < enemySpiderDistanceFromSpawn)){
						a = global.randomRange(1,worldSize - 1);
						b = global.randomRange(1,worldSize - 1);
							
					}
					enemySpider = new EnemySpider(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyList.push(enemySpider);
					frontObjects.addChild(enemySpider);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
					a = 0;
					b = 0;
				}
			
				//Enemy 2
				for (var c:int = 0; c < enemySlimeNumber; c++)
				{
					//Position and distance from spawn
					while (getQualifiedClassName(tileList[a][b]) != "FloorTile" || (a < enemySlimeDistanceFromSpawn && b < enemySlimeDistanceFromSpawn))
					{
						a = global.randomRange(1,worldSize - 1);
						b = global.randomRange(1,worldSize - 1);

					}
					enemySlime = new EnemySlime(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyList.push(enemySlime);
					frontObjects.addChild(enemySlime);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
					a = 0;
					b = 0;
				}
  
				//Enemy 3
				for (var c:int = 0; c < enemyRatNumber; c++)
				{
					//Position and distance from spawn
					while (getQualifiedClassName(tileList[a][b]) != "FloorTile" || (a < enemyRatDistanceFromSpawn && b < enemyRatDistanceFromSpawn))
					{
						a = global.randomRange(1,worldSize - 1);
						b = global.randomRange(1,worldSize - 1);

					}
					enemyRat = new EnemyRat(global.tileSize * a + 40,global.tileSize * b + 40);
					enemyList.push(enemyRat);
					frontObjects.addChild(enemyRat);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 20);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
					a = 0;
					b = 0;
				}
				//Enemy 4
				for (var c:int = 0; c < enemyDragonNumber; c++)
				{
					//Position and distance from spawn
					while (getQualifiedClassName(tileList[a][b]) != "FloorTile" || (a < enemyDragonDistanceFromSpawn && b < enemyDragonDistanceFromSpawn))
					{
						a = global.randomRange(1,worldSize - 1);
						b = global.randomRange(1,worldSize - 1);
					}
					enemyDragon = new EnemyDragon(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyList.push(enemyDragon);
					frontObjects.addChild(enemyDragon);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 25);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
					a = 0;
					b = 0;
				}
				
				//Add key
				while (getQualifiedClassName(tileList[a][b]) != "FloorTile" || (a < 20 && b < 20))
				{
						a = global.randomRange(1,worldSize - 1);
						b = global.randomRange(1,worldSize - 1);
				}
				addItem(keyItem, KeyItem, a * global.tileSize, b * global.tileSize);
				
			}
			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			
			else if(levelNumber == 3)
			{
				//Level Variables
				worldSize = 34;
				var wormLength:int = 8;
				
				var roomNumber:int = 10;
				
				var enemyPosition:Array = [];
				
				for (var a:int = 0; a < worldSize; a++)
				{
					tileList.push(new Array());
					for (var b:int = 0; b < worldSize; b++)
					{
						temp1Tile = new Temp1Tile(global.tileSize * a, global.tileSize * b);
						addChild(temp1Tile);
						tileList[a].push(temp1Tile);
					}
				}
	
				//Room at spawn
				for(var a:int = 0; a < 5; a++)
				{
					for (var b:int = 0; b < 5; b++)
					{
						removeChild(tileList[(worldSize / 2 - 2 + a)][(worldSize / 2 - 2 + b)]);
						floorTile = new FloorTile((worldSize / 2 - 2 + a) * global.tileSize, (worldSize / 2 - 2 + b) * global.tileSize);
						tileList[(worldSize / 2 - 2 + a)][(worldSize / 2 - 2 + b)] = floorTile;
						addChild(floorTile);
					}
				}
				
				//Random Rooms
				
				for(var c:int = 0; c < roomNumber; c++)
				{
					var a:int = 20;
					var b:int = 20;
					while ((a > worldSize / 2 - 8 && a < worldSize / 2 + 6) && (b > worldSize / 2 - 8 && b < worldSize / 2 + 6))
					{
						a = global.randomRange(1, worldSize - 5);
						b = global.randomRange(1, worldSize - 5);
					}
					
					var roomWidth:int = global.randomRange(2, 4);
					var roomHeight:int = global.randomRange(2, 4);
					
					for(var d:int = 0; d < roomWidth; d++)
					{
						for(var e:int = 0; e < roomHeight; e++)
						{
							removeChild(tileList[d + a][e + b]);
							floorTile = new FloorTile((d + a) * global.tileSize, (e + b) * global.tileSize);
							tileList[(d + a)][(e + b)] = floorTile;
							addChild(floorTile);
						}
					}
					
					//Add a different item in each room
					switch(c)
					{
						case 1:
							addItem(shovel, Shovel, (d + a - 1) * global.tileSize, (e + b - 1) * global.tileSize);
							break;
						case 2:
							doorX = d + a - 2;
							doorY = e + b - 2;
							break;
						case 3:
							addItem(keyItem, KeyItem, (d + a - 1) * global.tileSize, (e + b - 1) * global.tileSize);
							break;
						default:
							addItem(healthPotion, HealthPotion, (d + a - 1) * global.tileSize, (e + b - 1) * global.tileSize);

					}
					enemyPosition.push(new Array());
					enemyPosition[c].push(d + a - 1);
					enemyPosition[c].push(e + b - 1);
					
					
					
				}

				//Place "FloorTile" Sprite over all FloorTiles
				
				for (var a:int = 0; a < worldSize - 1; a++)
				{
					for (var b:int = 0; b < worldSize - 1; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "FloorTile")
						{
							dirtfloorTile = new DirtfloorTile(a * global.tileSize, b * global.tileSize);
							floorLayer.addChild(dirtfloorTile);
						}
						
					}
				}
				doorTile = new DoorTile(doorX * global.tileSize, doorY * global.tileSize);
				tileList[doorX][doorY] = doorTile;
				floorLayer.addChild(doorTile);
				
				floorTile = new FloorTile(doorX * global.tileSize, doorY * global.tileSize);
				tileList[doorX][doorY] = floorTile;
				addChild(floorTile);
							
				addChild(floorLayer);
				addChild(backObjects);
				addChild(frontObjects);
				addChild(wallLayer);
				
				//For covering worm
				//Replace "temp1Tiles" with dirtwallTiles
				for (var a:int = 0; a < worldSize - 1; a++)
				{
					for (var b:int = 0; b < worldSize - 1; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "Temp1Tile")
						{
							removeChild(tileList[a][b]);
							dirtwallTile = new DirtwallTile(a * global.tileSize, b * global.tileSize);
							tileList[a][b] = dirtwallTile;
							wallLayer.addChild(dirtwallTile);
						}
					}
				}
				
				//-------------
				//SPAWN ENEMIES
				//-------------
				spawnWorm(wormLength);
				
				//Enemy Ants
				enemyAnt = new EnemyAnt((worldSize / 2) * global.tileSize + 5 + 40, (worldSize / 2 - 2) * global.tileSize + 40);
				enemyList.push(enemyAnt);
				frontObjects.addChild(enemyAnt);
				enemyHealthBarList.push(0);
				enemyAnt = new EnemyAnt((worldSize / 2) * global.tileSize + 5 + 40, (worldSize / 2 + 2) * global.tileSize + 40);
				enemyList.push(enemyAnt);
				frontObjects.addChild(enemyAnt);
				enemyHealthBarList.push(0);
				enemyAnt = new EnemyAnt((worldSize / 2 - 2) * global.tileSize + 5 + 40, (worldSize / 2) * global.tileSize + 40);
				enemyList.push(enemyAnt);
				frontObjects.addChild(enemyAnt);
				enemyHealthBarList.push(0);
				enemyAnt = new EnemyAnt((worldSize / 2 + 2) * global.tileSize + 5 + 40, (worldSize / 2) * global.tileSize + 40);
				enemyList.push(enemyAnt);
				frontObjects.addChild(enemyAnt);
				enemyHealthBarList.push(0);
				
				//Enemy Maggots
				for (var c:int = 0; c < roomNumber; c++)
				{
					//Position and distance from spawn
					a = enemyPosition[c][0];
					b = enemyPosition[c][1];
					
					enemyMaggot = new EnemyMaggot(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyList.push(enemyMaggot);
					frontObjects.addChild(enemyMaggot);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 40);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
				}
					
				x = -(worldSize / 2 - 4.5) * global.tileSize;
				y = -(worldSize / 2 - 4.5) * global.tileSize;
			}
			
			else if(levelNumber == 4)
			{
				worldSize = 30;
				var enemyWisp1Number:int = 20;
				var enemyWisp1DistanceFromSpawn:int = 7;
				
				var enemyWisp2Number:int = 2;
				var enemyWisp2DistanceFromSpawn:int = 8;
				
				for (var a:int = 0; a < worldSize; a++)
				{
					tileList.push(new Array());
					for(var b:int = 0; b < worldSize; b++)
					{
						tileList[a][b] = 0;
					}
				}
				
				//Generate maze
				generateMazeRecursion(20, 20);
				
				//Point inside the boundary
				doorX = 21;
				doorY = 21;
				
				while (tileList[doorX][doorY] == 0 || ((doorX > worldSize * 0.1 && doorX < worldSize * 0.9) || (doorY > worldSize * 0.1 && doorY < worldSize * 0.9))){
					doorX = global.randomRange(0, worldSize - 1);
					doorY = global.randomRange(0, worldSize - 1);
					
					
				}
				tileList[doorX][doorY] = 2;
				
				
				addItem(keyItem, KeyItem, (worldSize - doorX) * global.tileSize + 40, (worldSize - doorY) * global.tileSize + 40);
				
				trace(doorX, doorY);
				
				//Place "FloorTile" Sprite over all FloorTiles
				
				for (var a:int = 0; a < worldSize; a++)
				{
					for (var b:int = 0; b < worldSize; b++)
					{
						if (tileList[a][b] == 1)
						{
							platformTile = new PlatformTile(a * global.tileSize, b * global.tileSize);
							addChild(platformTile);
							floorTile = new FloorTile(a * global.tileSize, b * global.tileSize);
							tileList[a][b] = floorTile;
							addChild(floorTile);
						}
						else if(tileList[a][b] == 2)
						{
							doorTile = new DoorTile(a * global.tileSize, b * global.tileSize);
							tileList[a][b] = doorTile;
							addChild(doorTile);
							
							floorTile = new FloorTile(a * global.tileSize, b * global.tileSize);
							tileList[a][b] = floorTile;
							addChild(floorTile);
						}
						
					}
				}
				
				
				addChild(backObjects);
				addChild(frontObjects);
				
				//-------------
				//SPAWN ENEMIES
				//-------------
				
				//Spawn EnemyWisp1
				for (var c:int = 0; c < enemyWisp1Number; c++){
					//Position and distance from spawn
					var a:int = 20;
					var b:int = 20;
					while ((a > worldSize / 2 - enemyWisp1DistanceFromSpawn && a < worldSize / 2 + enemyWisp1DistanceFromSpawn) && (b > worldSize / 2 - enemyWisp1DistanceFromSpawn && b < worldSize / 2 + enemyWisp1DistanceFromSpawn)){
						a = global.randomRange(1, worldSize - 1);
						b = global.randomRange(1, worldSize - 1);
					}
					enemyWisp1 = new EnemyWisp1(global.tileSize * a + 25, global.tileSize * b + 25);
					enemyList.push(enemyWisp1);
					frontObjects.addChild(enemyWisp1);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 20);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
				}
				//Spawn EnemyWisp2
				for (var c:int = 0; c < enemyWisp2Number; c++){
					//Position and distance from spawn
					var a:int = 20;
					var b:int = 20;
					while ((a > worldSize / 2 - enemyWisp2DistanceFromSpawn && a < worldSize / 2 + enemyWisp2DistanceFromSpawn) && (b > worldSize / 2 - enemyWisp2DistanceFromSpawn && b < worldSize / 2 + enemyWisp2DistanceFromSpawn)){
						a = global.randomRange(1, worldSize - 1);
						b = global.randomRange(1, worldSize - 1);
					}
					enemyWisp2 = new EnemyWisp2(global.tileSize * a + 25, global.tileSize * b + 25);
					enemyList.push(enemyWisp2);
					frontObjects.addChild(enemyWisp2);
					enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 20);
					enemyHealthBarList.push(enemyHealthBar);
					frontObjects.addChild(enemyHealthBar);
				}
				
				
				x = -(11.5) * global.tileSize;
				y = -(11.5) * global.tileSize;
			}
			else if(levelNumber == 5)
			{
				worldSize = 80;
				var worldSizeX:int = 80;
				var worldSizeY:int = 14;
				
				//Magma Tiles
				for (var a:int = 0; a < worldSizeX; a++)
				{
					tileList.push(new Array());
					for (var b:int = 0; b < worldSizeY; b++)
					{
						magmaTile = new MagmaTile(global.tileSize * a, global.tileSize * b);
						addChild(magmaTile);
						tileList[a].push(3);
					}
				}
				
				//Magma Rock Tiles
				for (var a:int = 3; a < worldSizeX - 3; a++)
				{
					for (var b:int = 3; b < worldSizeY - 3; b++)
					{
						floorTile = new FloorTile(global.tileSize * a, global.tileSize * b);
						addChild(floorTile);
						tileList[a][b] = floorTile;
					}
				}
				
				//Place "FloorTile" Sprite over all FloorTiles
				
				for (var a:int = 0; a < worldSize - 1; a++)
				{
					for (var b:int = 0; b < worldSize - 1; b++)
					{
						if (getQualifiedClassName(tileList[a][b]) == "FloorTile")
						{
							magmaRockTile = new MagmaRockTile(a * global.tileSize, b * global.tileSize);
							addChild(magmaRockTile);
						}
					}
				}
				
				addChild(backObjects);
				addChild(frontObjects);
				
				//-------------
				//SPAWN ENEMIES
				//-------------
				enemyRam = new EnemyRam(5 * global.tileSize, worldSizeY/2 * global.tileSize);
				enemyList.push(enemyRam);
				frontObjects.addChild(enemyRam);
				enemyHealthBar = new EnemyHealthBar(5 * global.tileSize, worldSizeY/2 * global.tileSize + 320);
				enemyHealthBarList.push(enemyHealthBar);
				frontObjects.addChild(enemyHealthBar);
				
				x = -8 * global.tileSize;
				y = -3 * global.tileSize;
				
				
			}
		}
		
		public function generateMazeRecursion(a:int, b:int):void
		{
			var randDirs:Array = [1, 2, 3, 4];
			randDirs.sort(randomSort);
			
			for(var c:int = 0; c < randDirs.length; c++)
			{
				switch(randDirs[c])
				{
					case 1: //Up
						if(b - 2 <= 0)
							continue;
						if(tileList[a][b - 2] == 0)
						{
							tileList[a][b - 2] = 1;
							tileList[a][b - 1] = 1;
							generateMazeRecursion(a, b - 2);
						}
						break;
					case 2: //Right
						if(a + 2 >= worldSize - 1)
							continue;
							
						if(tileList[a + 2][b] == 0)
						{
							tileList[a + 2][b] = 1;
							tileList[a + 1][b] = 1;
							generateMazeRecursion(a + 2, b);
						}
						break;
					case 3: //Down
						if(b + 2 >= worldSize - 1)
							continue;
							
						if(tileList[a][b + 2] == 0)
						{
							tileList[a][b + 2] = 1;
							tileList[a][b + 1] = 1;
							generateMazeRecursion(a, b + 2);
						}
						break;
					case 4: //Left
						if(a - 2 <= 0)
							continue;
							
						if(tileList[a - 2][b] == 0)
						{
							tileList[a - 2][b] = 1;
							tileList[a - 1][b] = 1;
							generateMazeRecursion(a - 2, b);
						}
						break;
				}
				
				
				
			}
		
		}
		
		public function randomSort(a:*, b:*):int
		{
 			if (Math.random() < 0.5) return -1;
 			else return 1;
		}
		public function spawnWorm(wormLength:int):void
		{
			enemyWorm = new EnemyWorm(2 * global.tileSize, 2 * global.tileSize);
			enemyList.push(enemyWorm);
			frontObjects.addChild(enemyWorm);
			
			enemyHealthBar = new EnemyHealthBar(2 * global.tileSize + 40, 2 * global.tileSize + 40);
			enemyHealthBarList.push(enemyHealthBar);
			frontObjects.addChild(enemyHealthBar);
			
			for (var c:int = 0; c < wormLength - 1; c++)
			{
				enemyWormSegment = new EnemyWormSegment(1 * global.tileSize + 40, 1 * global.tileSize + 40);
				enemyList.push(enemyWormSegment);
				frontObjects.addChild(enemyWormSegment);
				enemyHealthBarList.push(0);
			}
			
			enemyWormTail = new EnemyWormTail(1 * global.tileSize + 40, 1 * global.tileSize + 40);
			enemyList.push(enemyWormTail);
			frontObjects.addChild(enemyWormTail);
			enemyHealthBarList.push(0);
		}
		
		public function replaceDirtWall(tileX:int, tileY:int):void
		{
			wallLayer.removeChild(tileList[tileX][tileY]);

				dirtfloorTile = new DirtfloorTile(tileX * global.tileSize, tileY * global.tileSize);
				tileList[tileX][tileY] = dirtfloorTile;
				floorLayer.addChild(dirtfloorTile);
			
				floorTile = new FloorTile(tileX * global.tileSize, tileY * global.tileSize);
				tileList[tileX][tileY] = floorTile;
				addChild(floorTile);

			
		}
		
		public function replaceTree(tileX:int, tileY:int):void
		{
			
			removeChild(tileList[tileX][tileY]);
			
			grassTile = new GrassTile(tileX * global.tileSize, tileY * global.tileSize);
			tileList[tileX][tileY] = grassTile;
			addChild(grassTile);
			
			floorTile = new FloorTile(tileX * global.tileSize, tileY * global.tileSize);
			tileList[tileX][tileY] = floorTile;
			addChild(floorTile);
		}
		
		public function addItem(a:Sprite, b:Class, X:int, Y:int)
		{
			a = new b(X + global.randomRange(-20, 20), Y + global.randomRange(-20, 20));
			itemList.push(a)
			backObjects.addChild(a);
		}
		
		public function removeItem(a:int)
		{
			backObjects.removeChild(itemList[a])
			itemList.splice(a, 1)
		}

		public function spawnWave(tileX):void
		{
			//Bomb Rat
			for(var c:int = 0; c < waveSize; c++)
			{
				var b:int = global.randomRange(3, 10);
				if(global.randomRange(0, 1) == 0)
				{
					var a:int = (tileX - 5);
				}
				else
				{
					var a:int = (tileX + 5);
				}
				enemyRat = new EnemyRat(global.tileSize * a + 40, global.tileSize * b + 40);
				enemyList.push(enemyRat);
				frontObjects.addChild(enemyRat);
				enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 20);
				enemyHealthBarList.push(enemyHealthBar);
				frontObjects.addChild(enemyHealthBar);
			}
			//Atomic Bomb Rat
			for(var c:int = 0; c < waveSize - 4; c++)
			{
				var b:int = global.randomRange(3, 10);
				if(global.randomRange(0, 1) == 0)
				{
					var a:int = (tileX - 5);
				}
				else
				{
					var a:int = (tileX + 5);
				}
				enemyRat2 = new EnemyRat2(global.tileSize * a + 40, global.tileSize * b + 40);
				enemyList.push(enemyRat2);
				frontObjects.addChild(enemyRat2);
				enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 20);
				enemyHealthBarList.push(enemyHealthBar);
				frontObjects.addChild(enemyHealthBar);
			}
			//Dragon
			for(var c:int = 0; c < waveSize - 5; c++)
			{
				var a:int = global.randomRange(tileX + 5, tileX + 11);
				if(global.randomRange(0, 1) == 0)
				{
					var b:int = 3;
				}
				else
				{
					var b:int = 11;
				}
				enemyDragon2 = new EnemyDragon2(global.tileSize * a + 40, global.tileSize * b + 40);
				enemyList.push(enemyDragon2);
				frontObjects.addChild(enemyDragon2);
				enemyHealthBar = new EnemyHealthBar(global.tileSize * a + 40, global.tileSize * b + 20);
				enemyHealthBarList.push(enemyHealthBar);
				frontObjects.addChild(enemyHealthBar);
			}
			
			waveSize += 0.5;
		}

	}

}