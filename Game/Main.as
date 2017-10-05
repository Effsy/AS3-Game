package{
	
	import flash.display.MovieClip;
	//import flash.stage.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.media.SoundChannel;
	
	public class Main extends MovieClip{
		
		var gameHandler:GameHandler;
		
		var startMenu:StartMenu = new StartMenu(0, 0);
		var sceneOpen:SceneOpen = new SceneOpen(0, 0);
		var sceneOpenTimer:Timer = new Timer(21000);
		
		//Music
		var soundChannel:SoundChannel;	
		var soundPlaying:Boolean = false;
		
		var tutorialSound:TutorialSound = new TutorialSound();
		
		public function Main(){
			//scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			addChild(sceneOpen);
			sceneOpenTimer.start();
			
			sceneOpenTimer.addEventListener(TimerEvent.TIMER, sceneOpenFinished);
		}
		
		public function startMenuLoop(e:Event):void
		{
			startMenu.manageStartMenu();
			if(startMenu.spacePressed)
			{
				if(startMenu.selectorPosition == 0)
				{
					gameHandler = new GameHandler();
					addChild(gameHandler);
					removeChild(startMenu);
					removeEventListener(Event.ENTER_FRAME, startMenuLoop);
				}
				else
				{
					if(soundPlaying)
					{
						soundChannel.stop();
						soundPlaying = false;
					}
					else
					{
						soundChannel = tutorialSound.play(0, 1);
						soundPlaying = true;
					}
				}
			}
		}
		
		public function sceneOpenFinished(e:TimerEvent):void
		{
			
			sceneOpenTimer.stop();
			removeChild(sceneOpen);
			
			startMenu.addEventListeners();
			addChild(startMenu);
			addEventListener(Event.ENTER_FRAME, startMenuLoop);
		}
	}
	
}