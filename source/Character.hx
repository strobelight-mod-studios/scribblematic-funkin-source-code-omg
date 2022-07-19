package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import lime.app.Application;
import flash.display.BitmapData;

#if windows
import Sys;
import sys.FileSystem;
import sys.io.File;
#end

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import flixel.text.FlxText;

using StringTools;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var playerAnimations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var playerposition:Array<Float>; //bcuz dammit some of em don't exactly flip right
	var camera_position:Array<Float>;
	var player_camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
	var noteSkin:String;
	var isPlayerChar:Bool;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
	var playerOffsets:Array<Int>;
}

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var animPlayerOffsets:Map<String, Array<Dynamic>>; //for saving as jsons lol
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var isCustom:Bool = false;
	public var altAnim:String = '';
	public var bfAltAnim:String = '';
	public var danceIdle:Bool = false; //Character use "danceLeft" and "danceRight" instead of "idle"

	public var isPsychPlayer:Bool;
	public var healthIcon:String = 'bf';
	public var iconColor:String;
	public var noteSkin:String = PlayState.SONG.noteStyle;
	public var trailColor:String;

	public var holdTimer:Float = 0;

	public var furiosityScale:Float = 1.02;
	public var globaloffset:Array<Float> = [0,0];

	public var charPath:String;

	public static var colorPreString:FlxColor;
	public static var colorPreCut:String; 

	//psych method. yay!
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];
	public var positionArray:Array<Float> = [0, 0];
	public var playerPositionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];
	public var playerCameraPosition:Array<Float> = [0, 0];
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose
	public var animationsArray:Array<AnimArray> = [];
	public var stopIdle:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		iconColor = isPlayer ? 'FF66FF33' : 'FFFF0000';
		trailColor = isPlayer ? "FF0026FF" : "FFAA0044";

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf' | 'gf-evil' | 'speakers' | 'nothing':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'gf':
						frames = Paths.getSparrowAtlas('characters/GF_assets');
						iconColor = 'FFA5004D';
					case 'gf-evil':
						frames = Paths.getSparrowAtlas('characters/other/evil/GF_assets');
						iconColor = 'FF5AFFB2';
					case 'speakers':
						frames = Paths.getSparrowAtlas('characters/speakers');
						iconColor = 'FFA5004D';
					case 'nothing':
						frames = Paths.getSparrowAtlas('characters/empty_spritesheet_for_gf');
						iconColor = '11434253';
				}
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gf-christmas':
				frames = Paths.getSparrowAtlas('characters/gfChristmas');
				iconColor = 'FFA5004D';
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				frames = Paths.getSparrowAtlas('characters/gfCar');
				iconColor = 'FFA5004D';
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				frames = Paths.getSparrowAtlas('characters/gfPixel');
				iconColor = 'FFA5004D';
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad' | 'huh' /*empty spritesheet*/ | 'dad-evil':
				// DAD ANIMATION LOADING CODE
				switch (curCharacter)
				{
					case 'dad':
						frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
						iconColor = 'FFAF66CE';
					case 'huh':
						frames = Paths.getSparrowAtlas('characters/empty_spritesheet');
						iconColor = 'FF0097C4';
					case 'dad-evil':
						frames = Paths.getSparrowAtlas('characters/other/evil/DADDY_DEAREST');
						iconColor = 'FF509931';
				}
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile('dad');

				playAnim('idle');
			case 'spooky':
				frames = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				iconColor = 'FFD57E00';
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'mom' | 'mom-car':
				switch (curCharacter)
				{
					case 'mom':
						frames = Paths.getSparrowAtlas('characters/Mom_Assets');
						iconColor = 'FFD8558E';
					case 'mom-car':
						frames = Paths.getSparrowAtlas('characters/momCar');
						iconColor = 'FFD8558E';
				}

				animation.addByPrefix('idle', "Mom Idle", 24);
				animation.addByPrefix('singUP', "Mom Up Pose", 24);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets');
				iconColor = 'FFF3FF6E';
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				frames = Paths.getSparrowAtlas('characters/monsterChristmas');
				iconColor = 'FFF3FF6E';
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				iconColor = 'FFB7D855';
				flipX = true;
				
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'bf' | 'BOCHEN' | 'bf-evil':

				if (curCharacter == 'bf-evil') {
					loadOffsetFile('bf');
				}
				else {
					loadOffsetFile(curCharacter);
				}

				switch (curCharacter)
				{
					case 'bf':
						frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
						iconColor = 'FF0097C4';
					case 'BOCHEN': // i forgor why i wanted to add him
						frames = Paths.getSparrowAtlas('characters/other/BOUFCHEN');
						iconColor = 'FF00A2E8';
					case 'bf-evil':
						frames = Paths.getSparrowAtlas('characters/other/evil/BOYFRIEND');
						iconColor = 'FFFF683B';
				}

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				playAnim('idle');

				flipX = true;
			case 'bf-christmas':
				frames = Paths.getSparrowAtlas('characters/bfChristmas');
				iconColor = 'FF0097C4';
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				frames = Paths.getSparrowAtlas('characters/bfCar');
				iconColor = 'FF0097C4';
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				iconColor = 'FF0097C4';
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				iconColor = 'FF0097C4';
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai' | 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');
				iconColor = 'FFFFAA6F';
				// noteSkin = 'pixel';

				switch (curCharacter)
				{
					case 'senpai':
						animation.addByPrefix('idle', 'Senpai Idle', 24, false);
						animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
						animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
						animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
						animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);
					case 'senpai-angry':
						animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
						animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
						animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
						animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
						animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);
				}

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
				iconColor = 'FFFF3C6E';
				// noteSkin = 'pixel';
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				iconColor = 'FFC45EAE';
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
			case 'bf-scribblematic':
				frames = Paths.getSparrowAtlas('characters/BF_Scribblematic');
				iconColor = 'FF0097C4';

				animation.addByPrefix('idle', 'Bf Idle', 24, false);
				animation.addByPrefix('singUP', 'Bf Up', 24, false);
				animation.addByPrefix('singLEFT', 'Bf Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Bf Right', 24, false);
				animation.addByPrefix('singDOWN', 'Bf Down', 24, false);
				animation.addByPrefix('singUPmiss', 'Bf Miss Universal', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Bf Miss Universal', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Bf Miss Universal', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Bf Miss Universal', 24, false);

				setGraphicSize(Std.int(width * 0.9));
				loadOffsetFile(curCharacter);
				flipX = true;
			case 'gf-scribblematic': // me tryin' to make her dance while i try to edit dance funtion so i won't have to do that specifically for her.
				frames = Paths.getSparrowAtlas('characters/GF_Scribblematic');
				iconColor = 'FFA5004D';

				animation.addByIndices('singUP', 'GF_Scribblematic danceLeft', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF_Scribblematic danceLeft', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('danceRight', 'GF_Scribblematic danceRight', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('sad', 'GF_Scribblematic sad', [0, 1, 2, 3], "", 24, false);
			case 'kaskudek':
				frames = Paths.getSparrowAtlas('characters/Kassy');
				iconColor = 'FF000399';
				animation.addByPrefix('idle', 'Kassy Idle', 24, false);
				animation.addByPrefix('singUP', 'Kassy up', 24, false);
				animation.addByPrefix('singRIGHT', 'Kassy right', 24, false);
				animation.addByPrefix('singDOWN', 'Kassy down', 24, false);
				animation.addByPrefix('singLEFT', 'Kassy left', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'chill-grunt':
				frames = Paths.getSparrowAtlas('characters/Chill_Grunt');
				iconColor = 'FFB4B4B3';
				animation.addByPrefix('idle', 'Chill Grunt Idle', 24, false);
				animation.addByPrefix('singUP', 'Chill Grunt Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Chill Grunt Right', 24, false);
				animation.addByPrefix('singDOWN', 'Chill Grunt Down', 24, false);
				animation.addByPrefix('singLEFT', 'Chill Grunt Left', 24, false);

				setGraphicSize(Std.int(width * 1.2));
				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'sara-heric':
				frames = Paths.getSparrowAtlas('characters/Sara_Real');
				iconColor = 'FFFF85C6';

				animation.addByPrefix('idle', 'Sara Idle', 24, false);
				animation.addByPrefix('singUP', 'Sara Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sara Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sara Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sara Left', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			/* GODDAMIT, Kaskudek changed the lore. Emerald is no longer in Week 1
			case 'emerald':
				frames = Paths.getSparrowAtlas('characters/emerald_but_better_assets');
				iconColor = 'FF00AA2C';

				animation.addByPrefix('idle', 'SzmaragdYT cool idle animation', 24, true);
				animation.addByPrefix('singUP', 'SzmaragdYT cool sing up animation', 24, false);
				animation.addByPrefix('singRIGHT', 'SzmaragdYT cool sing right animation', 24, false);
				animation.addByPrefix('singDOWN', 'SzmaragdYT cool sing down animation', 24, false);
				animation.addByPrefix('singLEFT', 'SzmaragdYT cool sing left animation', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
				playAnim('idle');
			*/
			case 'lodger' | 'hypno-two-shiny' | 'hypno-shiny' | 'tankman': // bruh
				isCustom = true;

				var characterPath:String = 'images/characters/jsons/' + curCharacter;

				var path:String = Paths.jsonNew(characterPath);
			
				if (!FileSystem.exists(path) && !Assets.exists(path))
				{
					trace('oh no missingno');
					path = Paths.jsonNew('images/characters/jsons/bf'); //If a character couldn't be found, change to bf just to prevent a crash
					curCharacter = 'bf';
				}

				var rawJson:Dynamic;

				if (FileSystem.exists(path))
					rawJson = File.getContent(path);
				else
					rawJson = Assets.getText(path);
				
				var json:CharacterFile = cast Json.parse(rawJson);

				var imagePath = Paths.image(json.image);

				if (Assets.exists(imagePath) && !FileSystem.exists(imagePath))
				{
					txtToFind = Paths.txtNew('images/' + json.image);
				
					if (!Paths.currentTrackedAssets.exists(json.image))
						Paths.cacheImage(json.image, 'shared');
					
					rawPic = Paths.currentTrackedAssets.get(json.image);

					charPath = json.image + '.png'; //cuz we only use pngs anyway
					imageFile = json.image; //psych

					if(Assets.exists(txtToFind))
						frames = Paths.getPackerAtlas(json.image);
					else 
					{
						rawXml = Assets.getText(Paths.xmlNew('images/' + json.image));
		
						frames = FlxAtlasFrames.fromSparrow(rawPic,rawXml);	
					}	
				}
				/* ok leavin' this as commentfor now lol. it's a hard-coded mod
				else //if it's a character added after compiling
				{
					txtToFind= Paths.txtNew('images/' + json.image);
					var modTxtToFind:String = Paths.modsTxt(json.image);

					if (!Paths.currentTrackedAssets.exists(json.image))
						Paths.cacheImage(json.image, 'preload');
					
					rawPic = Paths.currentTrackedAssets.get(json.image);

					charPath = json.image + '.png'; //cuz we only use pngs anyway
					imageFile = json.image; //psych
	
					if(FileSystem.exists(txtToFind))
					{
						rawXml = File.getContent(txtToFind);
						frames = FlxAtlasFrames.fromSpriteSheetPacker(rawPic,rawXml);
					}
					else 
					{
						if (FileSystem.exists(Paths.modsXml(json.image)))
							rawXml = File.getContent(Paths.modsXml(json.image));
						else if (FileSystem.exists(FileSystem.absolutePath("assets/shared/images/"+json.image+".xml")))
							rawXml = File.getContent(FileSystem.absolutePath("assets/shared/images/"+json.image+".xml"));
						else
							rawXml = File.getContent(Paths.xmlNew('images/' + json.image));

						//this took my dumbass 2 hours to figure out.
						if(FlxG.save.data.poltatoPC && curCharacter != 'senpai-christmas' && json.scale != 6)
						{	
							rawXml = resizeXML(rawXml, 0.5);

							json.scale *= 2;
							
							if (isPlayer && json.playerposition != null)
								json.playerposition = [json.playerposition[0] + 230, json.playerposition[1] + 230];
							else
								json.position = [json.position[0] + 230, json.position[1] + 230];
						}

						frames = FlxAtlasFrames.fromSparrow(rawPic,rawXml);
					}		
				}
				*/
				
				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				healthIcon = json.healthicon;
				
				if (isPlayer && json.playerposition != null)
					positionArray = json.playerposition;
				else
					positionArray = json.position;

				if (json.playerposition != null)
					playerPositionArray = json.playerposition;
				else
					playerPositionArray = json.position;

				if (isPlayer && json.player_camera_position != null)
					cameraPosition = json.player_camera_position;
				else
					cameraPosition = json.camera_position;

				if (json.player_camera_position != null)
					playerCameraPosition = json.player_camera_position;
				else
					playerCameraPosition = json.camera_position;
				
				singDuration = json.sing_duration;
				flipX = !!json.flip_x;
				if(json.no_antialiasing) {
					antialiasing = false;
					noAntialiasing = true;
				}

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				//cuz the way bar colors are calculated here is like in B&B
				colorPreString = FlxColor.fromRGB(healthColorArray[0], healthColorArray[1], healthColorArray[2]);
				colorPreCut = colorPreString.toHexString();

				iconColor = colorPreCut.substring(2);

				antialiasing = !noAntialiasing;

				animationsArray = json.animations;

				if (isPlayer && json.playerAnimations != null)
					animationsArray = json.playerAnimations;

				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if (isPlayer)
						{
							if(anim.playerOffsets != null && anim.playerOffsets.length > 1) {
								addOffset(anim.anim, anim.playerOffsets[0], anim.playerOffsets[1]);
							}
							else if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}
						else
						{
							if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}

						if(anim.playerOffsets != null && anim.playerOffsets.length > 1) {
							addPlayerOffset(anim.anim, anim.playerOffsets[0], anim.playerOffsets[1]);
						}
					
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
					quickAnimAdd('singUP', 'BF idle dance');
					quickAnimAdd('singDOWN', 'BF idle dance');
					quickAnimAdd('singLEFT', 'BF idle dance');
					quickAnimAdd('singRIGHT', 'BF idle dance');
				}

				if (animOffsets.exists('danceRight'))
					playAnim('danceRight');
				else
					playAnim('idle');
			default:
				isCustom = true;

				var characterPath:String = 'images/characters/jsons/' + curCharacter;

				var path:String = Paths.jsonNew(characterPath);
			
				if (!FileSystem.exists(path) && !Assets.exists(path))
				{
					trace('oh no missingno');
					path = Paths.jsonNew('images/characters/jsons/bf'); //If a character couldn't be found, change to bf just to prevent a crash
					curCharacter = 'bf';
				}

				var rawJson:Dynamic;

				if (FileSystem.exists(path))
					rawJson = File.getContent(path);
				else
					rawJson = Assets.getText(path);
				
				var json:CharacterFile = cast Json.parse(rawJson);

				var imagePath = Paths.image(json.image);

				if (Assets.exists(imagePath) && !FileSystem.exists(imagePath))
				{
					txtToFind = Paths.txtNew('images/' + json.image);
				
					if (!Paths.currentTrackedAssets.exists(json.image))
						Paths.cacheImage(json.image, 'shared');
					
					rawPic = Paths.currentTrackedAssets.get(json.image);

					charPath = json.image + '.png'; //cuz we only use pngs anyway
					imageFile = json.image; //psych

					if(Assets.exists(txtToFind))
						frames = Paths.getPackerAtlas(json.image);
					else 
					{
						rawXml = Assets.getText(Paths.xmlNew('images/' + json.image));
		
						frames = FlxAtlasFrames.fromSparrow(rawPic,rawXml);	
					}	
				}
				/* ok leavin' this as commentfor now lol. it's a hard-coded mod
				else //if it's a character added after compiling
				{
					txtToFind= Paths.txtNew('images/' + json.image);
					var modTxtToFind:String = Paths.modsTxt(json.image);

					if (!Paths.currentTrackedAssets.exists(json.image))
						Paths.cacheImage(json.image, 'preload');
					
					rawPic = Paths.currentTrackedAssets.get(json.image);

					charPath = json.image + '.png'; //cuz we only use pngs anyway
					imageFile = json.image; //psych
	
					if(FileSystem.exists(txtToFind))
					{
						rawXml = File.getContent(txtToFind);
						frames = FlxAtlasFrames.fromSpriteSheetPacker(rawPic,rawXml);
					}
					else 
					{
						if (FileSystem.exists(Paths.modsXml(json.image)))
							rawXml = File.getContent(Paths.modsXml(json.image));
						else if (FileSystem.exists(FileSystem.absolutePath("assets/shared/images/"+json.image+".xml")))
							rawXml = File.getContent(FileSystem.absolutePath("assets/shared/images/"+json.image+".xml"));
						else
							rawXml = File.getContent(Paths.xmlNew('images/' + json.image));

						//this took my dumbass 2 hours to figure out.
						if(FlxG.save.data.poltatoPC && curCharacter != 'senpai-christmas' && json.scale != 6)
						{	
							rawXml = resizeXML(rawXml, 0.5);

							json.scale *= 2;
							
							if (isPlayer && json.playerposition != null)
								json.playerposition = [json.playerposition[0] + 230, json.playerposition[1] + 230];
							else
								json.position = [json.position[0] + 230, json.position[1] + 230];
						}

						frames = FlxAtlasFrames.fromSparrow(rawPic,rawXml);
					}		
				}
				*/
				
				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				healthIcon = json.healthicon;
				
				if (isPlayer && json.playerposition != null)
					positionArray = json.playerposition;
				else
					positionArray = json.position;

				if (json.playerposition != null)
					playerPositionArray = json.playerposition;
				else
					playerPositionArray = json.position;

				if (isPlayer && json.player_camera_position != null)
					cameraPosition = json.player_camera_position;
				else
					cameraPosition = json.camera_position;

				if (json.player_camera_position != null)
					playerCameraPosition = json.player_camera_position;
				else
					playerCameraPosition = json.camera_position;
				
				singDuration = json.sing_duration;
				flipX = !!json.flip_x;
				if(json.no_antialiasing) {
					antialiasing = false;
					noAntialiasing = true;
				}

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				//cuz the way bar colors are calculated here is like in B&B
				colorPreString = FlxColor.fromRGB(healthColorArray[0], healthColorArray[1], healthColorArray[2]);
				colorPreCut = colorPreString.toHexString();

				iconColor = colorPreCut.substring(2);

				antialiasing = !noAntialiasing;

				animationsArray = json.animations;

				if (isPlayer && json.playerAnimations != null)
					animationsArray = json.playerAnimations;

				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if (isPlayer)
						{
							if(anim.playerOffsets != null && anim.playerOffsets.length > 1) {
								addOffset(anim.anim, anim.playerOffsets[0], anim.playerOffsets[1]);
							}
							else if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}
						else
						{
							if(anim.offsets != null && anim.offsets.length > 1) {
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}

						if(anim.playerOffsets != null && anim.playerOffsets.length > 1) {
							addPlayerOffset(anim.anim, anim.playerOffsets[0], anim.playerOffsets[1]);
						}
					
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
					quickAnimAdd('singUP', 'BF idle dance');
					quickAnimAdd('singDOWN', 'BF idle dance');
					quickAnimAdd('singLEFT', 'BF idle dance');
					quickAnimAdd('singRIGHT', 'BF idle dance');
				}

				if (animOffsets.exists('danceRight'))
					playAnim('danceRight');
				else
					playAnim('idle');
		}

		//if(animOffsets.exists('singLEFTmiss') || animOffsets.exists('singDOWNmiss') || animOffsets.exists('singUPmiss') || animOffsets.exists('singRIGHTmiss'))
			//hasMissAnimations = true;
		recalculateDanceIdle(); // 'kay, let's add this funtion
		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	var txtToFind:String;
	var rawPic:Dynamic;
	var rawXml:String;

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (isCustom)
				dadVar = singDuration;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'speakers' | 'nothing' | 'gf-evil' | 'gf-bloodrayne':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				case 'gf-judgev2':
					if (animation.curAnim.name != 'spooked')
					{
						danced = !danced;
		
						if (isPlayer)
						{
							if (danced)
								playAnim('danceRight' + bfAltAnim);
							else
								playAnim('danceLeft' + bfAltAnim);
						}
						else
						{
							if (danced)
								playAnim('danceRight' + altAnim);
							else
								playAnim('danceLeft' + altAnim);
						}	
					}
				default:
					if (danceIdle)
					{
						danced = !danced;
		
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
					else if (animation.getByName('idle') != null)
					{
						playAnim('idle');
					}
			}
		}
	}

	public function loadOffsetFile(character:String)
	{
		var offset:Array<String>;
		
		if (isPlayer){
			try {
				offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "PlayerOffsets", 'shared'));
			} catch (e) {
				try {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "Offsets", 'shared'));
				}
				catch(e) {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/noOffsets', 'shared'));
				}	
			}
			
		}
		else{
			try {
				offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "Offsets", 'shared'));
			} catch (e) {
				try {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/' + character + "PlayerOffsets", 'shared'));
				}
				catch(e) {
					offset = CoolUtil.coolTextFile(Paths.txtNew('images/characters/offsets/noOffsets', 'shared'));
				}		
			}
		}
		

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	public function loadAnims(character:String) // I know, I know. I added this unnecesarily. I just want to see how Camellia works
	{
		var anim:Array<String>;
		
		anim = CoolUtil.coolTextFile(Paths.txtNew('images/characters/anims/' + character + "Anims", 'shared'));
		
		for (i in 0...anim.length)
		{
			var data:Array<String> = anim[i].split(':');
			var loop:Bool = false;

			if (data[4] == null)
				loop = false;
			else
			{
				if (data[4] == 'true')
					loop = true;
				else if (data[4] == 'false')
					loop = false;
			}

			if (data[0] == 'prefix')
				animation.addByPrefix(data[1], data[2], Std.parseInt(data[3]), loop);
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public var danceEveryNumBeats:Int = 2;
	private var settingCharacterUp:Bool = true;
	public function recalculateDanceIdle() {
		var lastDanceIdle:Bool = danceIdle;
		danceIdle = (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null);

		if(settingCharacterUp)
		{
			danceEveryNumBeats = (danceIdle ? 1 : 2);
		}
		else if(lastDanceIdle != danceIdle)
		{
			var calc:Float = danceEveryNumBeats;
			if(danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}
		settingCharacterUp = false;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function addPlayerOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animPlayerOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String)
	{
		addAnimationByPrefix(name, anim, 24, false);
	}

	public function addAnimationByPrefix(name:String, prefix:String, framerate:Int = 24, loop:Bool = false)
	{
		var newAnim:AnimArray = {
			anim: name,
			name: prefix,
			fps: Math.round(framerate),
			loop: loop,
			indices: [],
			offsets: [0, 0],
			playerOffsets: [0, 0]
		};

		animation.addByPrefix(name, prefix, framerate, loop);
		animationsArray.push(newAnim);
	}

	public function resizeXML(rawXml:String, factor:Float)
	{
		var daXml:Xml = Xml.parse(rawXml);
		var fast = new haxe.xml.Access(daXml);
		var users = fast.node.TextureAtlas;
		for (SubTexture in users.nodes.SubTexture) {
			SubTexture.att.x = Std.string(Std.parseInt(SubTexture.att.x) * factor);
			SubTexture.att.y = Std.string(Std.parseInt(SubTexture.att.y) * factor);
			SubTexture.att.width = Std.string(Std.parseInt(SubTexture.att.width) * factor);
			SubTexture.att.height = Std.string(Std.parseInt(SubTexture.att.height) * factor);

			if (SubTexture.has.frameX)
			{
				SubTexture.att.frameX = Std.string(Std.parseInt(SubTexture.att.frameX) * factor);
				SubTexture.att.frameY = Std.string(Std.parseInt(SubTexture.att.frameY) * factor);
				SubTexture.att.frameWidth = Std.string(Std.parseInt(SubTexture.att.frameWidth) * factor);
				SubTexture.att.frameHeight = Std.string(Std.parseInt(SubTexture.att.frameHeight) * factor);
			}
		}
		return Std.string(daXml);
	}

	public function flipAnims()
	{
		if (animation.getByName('singRIGHT') != null && animation.getByName('singLEFT') != null)
		{
			var oldRight = animation.getByName('singRIGHT').frames;
			animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
			animation.getByName('singLEFT').frames = oldRight;
		}

		// IF THEY HAVE MISS ANIMATIONS??
		if (animation.getByName('singRIGHTmiss') != null && animation.getByName('singLEFTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
		if (animation.getByName('singRIGHT-alt') != null && animation.getByName('singLEFT-alt') != null)
		{
			var oldAlt = animation.getByName('singRIGHT-alt').frames;
			animation.getByName('singRIGHT-alt').frames = animation.getByName('singLEFT-alt').frames;
			animation.getByName('singLEFT-alt').frames = oldAlt;
		}

		if (curCharacter.contains('9key'))
		{
			var oldRight = animation.getByName('singRIGHT2').frames;
			animation.getByName('singRIGHT2').frames = animation.getByName('singLEFT2').frames;
			animation.getByName('singLEFT2').frames = oldRight;
		}
	}
}
