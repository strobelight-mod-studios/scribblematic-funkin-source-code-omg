package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import openfl.geom.Rectangle;
import flixel.math.FlxRect;
import haxe.xml.Access;
import openfl.system.System;
import openfl.geom.Matrix;
import lime.utils.Assets;
import flixel.FlxSprite;
#if desktop
import sys.io.File;
import sys.FileSystem;
#end
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

import flash.media.Sound;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			if(currentLevel != 'shared') {
				levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function lua(key:String,?library:String)
	{
		return getPath('data/$key.lua', TEXT, library);
	}

	inline static public function luaImage(key:String, ?library:String)
	{
		return getPath('data/$key.png', IMAGE, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function txtNew(key:String, ?library:String) // Psych Engine character implementing
	{
		return getPath('$key.txt', TEXT, library);
	}

	inline static public function xmlNew(key:String, ?library:String) // Psych Engine character implementing
	{
		return getPath('$key.xml', TEXT, library);
	}

	inline static public function lyric(key:String, ?library:String) // Lyrical files
	{
		return getPath('data/$key.lyric', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function video(key:String, ?library:String) // FNF mp4 Video support
	{
		trace('Video in assets/videos/$key.mp4 is playing right now');
		return getPath('videos/$key.mp4', BINARY, library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
				case "rabbit's-luck": songLowercase = "rabbit's-luck-hard";
				case 'intense training': songLowercase = 'intense-training';
				case 'the shopkeeper': songLowercase = 'the-shopkeeper';
			}

		var pre:String = "";
		var suf:String = "";
		
		return 'songs:assets/songs/${songLowercase}/'+pre+'Voices'+suf+'.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
				case "rabbit's-luck": songLowercase = "rabbit's-luck-hard";
				case 'intense training': songLowercase = 'intense-training';
				case 'the shopkeeper': songLowercase = 'the-shopkeeper';
			}

		var pre:String = "";
		var suf:String = "";

		return 'songs:assets/songs/${songLowercase}/'+pre+'Inst'+suf+'.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	/*
	inline static public function voicesPlayer(song:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
				case "rabbit's-luck": songLowercase = "rabbit's-luck-hard";
				case 'intense training': songLowercase = 'intense-training';
				case 'the shopkeeper': songLowercase = 'the-shopkeeper';
			}

		var pre:String = "";
		var suf:String = "";
		
		return 'songs:assets/songs/${songLowercase}/'+pre+'VoicesPlayer'+suf+'.$SOUND_EXT';
	}
	*/

	inline static public function jsonNew(key:String, ?library:String) // Psych Engine character implementing
	{
		return getPath('$key.json', TEXT, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	public static function cacheImage(key:String, ?library:String = null)
	{
		var path:String;

		if (FileSystem.exists(FileSystem.absolutePath('assets/shared/images/$key.png')))
			path = FileSystem.absolutePath('assets/shared/images/$key.png');
		else
			path = getPath('images/$key.png', IMAGE, library);
	
		if (FileSystem.exists(path) || Assets.exists(path)) 
		{
			if(!currentTrackedAssets.exists(key)) 
			{
				var newBitmap:BitmapData;

				if (FlxG.save.data.poltatoPC)
				{
					var matrix:Matrix = new Matrix();
					matrix.scale(0.5, 0.5);

					var bigBMP:BitmapData;

					if (Assets.exists(path))
						bigBMP = BitmapData.fromFile(path);
					else
						bigBMP = BitmapData.fromFile(path);

					newBitmap = new BitmapData(Std.int(bigBMP.width * 0.5), Std.int(bigBMP.height * 0.5), true, 0x000000);
					newBitmap.draw(bigBMP, matrix, null, null, null, true);

					bigBMP.dispose();
					bigBMP.disposeImage();
					bigBMP = null;
				}
				else	
					newBitmap = BitmapData.fromFile(path);

				var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, key);
				newGraphic.persist = true;
				currentTrackedAssets.set(key, newGraphic);
			}
			localTrackedAssets.push(key);
			return currentTrackedAssets.get(key);
		}

		trace('you failed dipshit');
		return null;		
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var localTrackedAssets:Array<String> = [];

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
	{
		#if MODS_ALLOWED
		if(FileSystem.exists(mods(currentModDirectory + '/' + key)) || FileSystem.exists(mods(key))) {
			return true;
		}
		#end
		
		if(OpenFlAssets.exists(Paths.getPath(key, type))) {
			return true;
		}
		return false;
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}
