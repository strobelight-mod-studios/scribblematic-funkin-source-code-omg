package;

import openfl.display.BlendMode;
import openfl.text.TextFormat;
import openfl.display.Application;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
#if GAMEJOLT
import GameJolt;
import GameJolt.GameJoltAPI;
#end

#if desktop
//crash handler stuff
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import Discord.DiscordClient;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 120; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public static var watermarks = true; // Whether to put Kade Engine liteartly anywhere
	public static var isHidden:Bool = false;
	public static var hiddenSongs:Array<String> = ['corn-maze', 'corn maze']; // Kaskudek told me to chart Corn Maze. I don't feel like chartin' it lol
	public static var hiddenSongsCheesy:Array<String> = ['the-shopkeeper', 'the shopkeeper'];
	public static var hiddenSongs2:Array<String> = []; // Goblock's BETADCIUs
	public static var hiddenCanonSongs:Array<String> = ['delayed']; // Adding these songs to story mode later
	// FUCK YOU! No, I'm not deleting empty variables.

	#if GAMEJOLT
	public static var gjToastManager:GJToastManager;
	#end

	public static var shopkeeperUnlocked:Bool = false;

	public static var funnyErrorMessage:Array<String> = [
		"skill issue",
		"beep beep skill issue delivery",
		"ya pirated the mod?", /*200 iq, how original*/
		"Error 404",
		"404",
		"Teotm obviously fucked up something",
		"Report to our Discord Server",
		":(",
		"Oh noes!",
		"Kaskudek added too much Bloodrayne Porn",
		"Never Gonna Give You Up",
		"It's a feature, not a bug",
		"Kade's Fault",
		"Potato PC moment",
		"Don't you tell me you tried to put a 3D object into a 2D game engine.",
		"Is your PC bad or somthing?",
		"You mad bro?"
	];


	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{

		// quick checks 

		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	public static var webmHandler:WebmHandler;

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		#if GAMEJOLT
		gjToastManager = new GJToastManager();
		addChild(gjToastManager);
		#end

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if cpp
		initialState = Caching;
		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
		#else
		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
		#end
		addChild(game);
		
		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fps);

		#end

		#if desktop
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	#if desktop
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "ScribblematicFunkin_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + "\nPlease report the error in our Discord Server: https://discord.com/invite/GeCArAMJ6y
		\n\n> Credits to sqirra-rng for writing this epic Crash Handler.
		\n>Credits to Shadow Mario too, cause I stole this code from Psych.
		\n\nGo to the \"crash/\" directory to get the .txt file with your problem.";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		
		/*
		FlxG.random.int(0, funnyErrorMessage.length - 1)
		funnyErrorMessage[FlxG.random.int(0, funnyErrorMessage.length - 1)]
		*/

		Application.current.window.alert(errMsg, "Error! " + funnyErrorMessage[FlxG.random.int(0, funnyErrorMessage.length - 1)]);
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
	

	var game:FlxGame;

	var fpsCounter:FPS;

	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
	}

	public function setFPSCap(cap:Float)
	{
		openfl.Lib.current.stage.frameRate = cap;
	}

	public function getFPSCap():Float
	{
		return openfl.Lib.current.stage.frameRate;
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}
}
