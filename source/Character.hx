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
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
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
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var isCustom:Bool = false;
	public var altAnim:String = '';
	public var bfAltAnim:String = '';

	public var iconColor:String;
	public var noteSkin:String = PlayState.SONG.noteStyle;
	public var trailColor:String;

	public var holdTimer:Float = 0;

	public static var colorPreString:FlxColor;
	public static var colorPreCut:String; 

	//psych method. yay!
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];
	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];
	public var singDuration:Float = 4; //Multiplier of how long a character holds the sing pose
	public var animationsArray:Array<AnimArray> = [];

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
			case 'gf' | 'speakers' | 'nothing' | 'speakers-bw' | 'gf-bf-bw' | 'gf-bw' | 'gf-and-bf' | 'gf-and-bf-bw':
				// GIRLFRIEND CODE
				switch (curCharacter)
				{
					case 'gf':
						frames = Paths.getSparrowAtlas('characters/GF_assets');
						iconColor = 'FFA5004D';
					case 'speakers':
						frames = Paths.getSparrowAtlas('characters/speakers');
						iconColor = 'FFA5004D';
					case 'nothing':
						frames = Paths.getSparrowAtlas('characters/literally_nothing');
						iconColor = 'FF434253';
					case 'speakers-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/speakers');
						iconColor = 'FFA5004D';
					case 'gf-bf-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/GF_BF_assets');
						iconColor = 'FF6F6F6F';
					case 'gf-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/GF_assets');
						iconColor = 'FF3A3A3A';
					case 'gf-and-bf':
						frames = Paths.getSparrowAtlas('characters/other/GF_and_BF_assets');
						iconColor = 'FFA5004D';
					case 'gf-and-bf-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/GF_and_BF_assets');
						iconColor = 'FF3A3A3A';
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
			case 'gf-judgev2':
				frames = Paths.getSparrowAtlas('characters/other/GF_Tablev2');

				iconColor = 'FFA5004D';

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('spooked', 'GF_Spooked', 24);

				addOffset('cheer', 170, 79);
				addOffset('sad', 170, 63);
				addOffset('danceLeft', 171, 73);
				addOffset('danceRight', 171, 73);

				addOffset("singLEFT", 171, 71);
				addOffset("singRIGHT", 171, 70);
				addOffset("singDOWN", 171, 69);
				addOffset("singUP", 171, 74);

				addOffset('spooked', 171, 70);

				setGraphicSize(Std.int(width * 0.6));
				updateHitbox();

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
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

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

			case 'dad' | 'blash' | 'huh' | 'blantad' | 'tabi' | 'tabi-bw' | 'hd-senpai-happy' | 'hd-senpai-angry' | 'hd-spirit' | 'carol':
				// DAD ANIMATION LOADING CODE
				switch (curCharacter)
				{
					case 'dad':
						frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
						iconColor = 'FF5A07F5';
					case 'blash': // Note: Blash isn't in the Trio in this mod, however, he is canon.
						frames = Paths.getSparrowAtlas('characters/blash_the_blue_guy');
						iconColor = 'FFB83DBA';
						/*
							Something about the character:
							Blash is a Daddy Dearest skin replacement.
							The character was made by teotm (me), using his bad skills at pc art a few months before Some Trio was an idea for mod.
								(duh, even before I met Kaskudek, I think.)
								(And yes I was talking about me in 3rd person, cause for now there are no other coders. :/)
							He is obviously a joke character.
							I made him because I wanted to make a custom character, that would be singing Ridge.
							yes, he is a male with female voice (he had that voice since he was born).
							He is canonicaly friends with Lucky Guy and Arts and Crafters (that one from Baldi's Basics).
						*/
					case 'huh':
						frames = Paths.getSparrowAtlas('characters/BF_Test_SiIvaGunner');
						iconColor = 'FF0097C4';
					case 'blantad':
						frames = Paths.getSparrowAtlas('characters/other/Blantad_New');
						iconColor = 'FF64B3FE';
					case 'tabi':
						frames = Paths.getSparrowAtlas('characters/other/TABI');
						iconColor = 'FFFFBB81';
					case 'tabi-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/TABI');
						iconColor = 'FFC9C9C9';
					case 'hd-senpai-happy' | 'hd-senpai-angry':
						iconColor = 'FFFFAA6F';
						switch (curCharacter)
						{
							case 'hd-senpai-happy':
								frames = Paths.getSparrowAtlas('characters/other/HD_SENPAI_HAPPY');
							case 'hd-senpai-angry':
								frames = Paths.getSparrowAtlas('characters/other/HD_SENPAI_ANGRY');
						}
					case 'hd-spirit':
						iconColor = 'FFFF3C6E';
						frames = Paths.getSparrowAtlas('characters/other/HD_SPIRIT');
					case 'carol':
						iconColor = 'FF282833';
						frames = Paths.getSparrowAtlas('characters/other/Carol');
				}
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				if (curCharacter == 'blantad') {
					addOffset('idle', 0, 0);
					addOffset("singDOWN", -30, -12);
					addOffset("singRIGHT", -25, -4);
					addOffset("singUP", -23, 18);
					addOffset("singLEFT", -24, 1);
				}
				else if (curCharacter == 'tabi' || curCharacter == 'tabi-bw') {
					addOffset('idle', 0, 0);
					addOffset("singDOWN", -5, -108);
					addOffset("singRIGHT", -15, 11);
					addOffset("singUP", 44, 50);
					addOffset("singLEFT", 104, -28);
				}
				else {
					addOffset('idle');
					addOffset("singUP", -6, 50);
					addOffset("singRIGHT", 0, 27);
					addOffset("singLEFT", -10, 10);
					addOffset("singDOWN", 0, -30);
				}

				playAnim('idle');
			case 'spooky':
				frames = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				iconColor = 'FFF57E07';
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom' | 'mom-car':
				switch (curCharacter)
				{
					case 'mom' | 'mom-car':
						frames = Paths.getSparrowAtlas('characters/Mom_Assets');
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
			case 'dad-gf-judgev2':
				frames = Paths.getSparrowAtlas('characters/other/GF_Tablev2');

				iconColor = 'FFA5004D';

				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('spooked', 'GF_Spooked', 24);

				addOffset('danceLeft', 171, 73);
				addOffset('danceRight', 171, 73);

				addOffset("singLEFT", 171, 71);
				addOffset("singRIGHT", 171, 70);
				addOffset("singDOWN", 171, 69);
				addOffset("singUP", 171, 74);

				addOffset('spooked', 171, 70);

				setGraphicSize(Std.int(width * 0.6));
				updateHitbox();

				playAnim('danceRight');
			case 'bf-ayana':
				frames = Paths.getSparrowAtlas('characters/other/playableexGF');
				iconColor = 'FF64FFC1';

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -10, 50);
				addOffset("singUP", -10, 50);
				addOffset("singRIGHT", -10, 50);
				addOffset("singLEFT", -10, 50);
				addOffset("singDOWN", -10, 50);
				addOffset("singUPmiss", -10, 50);
				addOffset("singRIGHTmiss", -10, 50);
				addOffset("singLEFTmiss", -10, 50);
				addOffset("singDOWNmiss", -10, 50);

				playAnim('idle');

				flipX = true;
			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets');
				iconColor = 'FFF5DD07';
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
			case 'monster-christmas' | 'annie-drunk' | 'annie-drunk-bw':
				switch (curCharacter)
				{
					case 'monster-christmas':
						frames = Paths.getSparrowAtlas('characters/monsterChristmas');
						iconColor = 'FFF5DD07';
					case 'annie-drunk':
						frames = Paths.getSparrowAtlas('characters/other/annie_Drunk');
						iconColor = 'FFFF2043';
					case 'annie-drunk-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/annie_Drunk');
						iconColor = 'FF676767';
				}
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

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');
			case 'bf-pico':
				frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				iconColor = 'FFB7D855';
				flipX = true;
				
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", 20, 20);
				addOffset("singRIGHT", -45, 0);
				addOffset("singLEFT", 80, -15);
				addOffset("singDOWN", 95, -90);
				addOffset("singUPmiss", 20, 60);
				addOffset("singRIGHTmiss", -40, 40);
				addOffset("singLEFTmiss", 80, 20);
				addOffset("singDOWNmiss", 105, -48);

				playAnim('idle');
			case 'nene':
				frames = Paths.getSparrowAtlas('characters/other/NENE');
				iconColor = 'FFFF6690';

				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'PICO NOTE LEFT0', 24, false);

				addOffset('idle');
				addOffset("singUP", -65, 35);
				addOffset("singRIGHT", -5, 0);
				addOffset("singLEFT", -120, 5);
				addOffset("singDOWN", -125, -75);
			
			case 'bf' | 'luckyGuy' | 'unidentified' | 'BOCHEN' | 'nenechi' | 'aloe' | 'sonic' | 'sonic-bw' | 'lexi' | 'lexi-bw' | 'bf-bw' | 'girlfriend-playable' | 'girlfriend-playable-bw' | 'ena' | 'ǝna' | 'jena' | 'ina' | 'enna' | 'ayna' | 'chaina':
				switch (curCharacter)
				{
					case 'bf' | 'BOCHEN' | 'nenechi' | 'aloe' | 'sonic' | 'sonic-bw' | 'lexi' | 'lexi-bw' | 'bf-bw' | 'girlfriend-playable' | 'girlfriend-playable-bw' | 'ena' | 'ǝna' | 'jena' | 'ina' | 'enna' | 'ayna' | 'chaina':
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
						addOffset('firstDeath', 37, 11);
						addOffset('deathLoop', 37, 5);
						addOffset('deathConfirm', 37, 69);
						addOffset('scared', -4);
						switch (curCharacter)
						{
							case 'bf':
								frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
								iconColor = 'FF0097C4';
							case 'BOCHEN': // i forgor why i wanted to add him
								frames = Paths.getSparrowAtlas('characters/other/BOUFCHEN');
								iconColor = 'FF00A2E8';
							case 'nenechi': // it's not my holofunk addiction i swear
								frames = Paths.getSparrowAtlas('characters/other/NaeNae');
								iconColor = 'FFFFF29E';
							case 'aloe': // it's not my holofunk addiction i swear
								frames = Paths.getSparrowAtlas('characters/other/Aloo');
								iconColor = 'FFEF71B1';
							case 'sonic':
								frames = Paths.getSparrowAtlas('characters/other/Sonic');
								iconColor = 'FF0028B2';
							case 'sonic-bw':
								frames = Paths.getSparrowAtlas('characters/other/bw/Sonic');
								iconColor = 'FF2B2B2B';
							case 'lexi':
								frames = Paths.getSparrowAtlas('characters/other/Lexi');
								iconColor = 'FFFE94EB';
							case 'lexi-bw':
								frames = Paths.getSparrowAtlas('characters/other/bw/Lexi');
								iconColor = 'FFBEBEBE';
							case 'bf-bw':
								frames = Paths.getSparrowAtlas('characters/other/bw/BOYFRIEND');
								iconColor = 'FF6F6F6F';
							case 'ena' | 'ǝna' | 'jena' | 'ina' | 'enna' | 'ayna' | 'chaina' /*added ƎNA's alsiases to code for easter egg purposes only*/:
								frames = Paths.getSparrowAtlas('characters/other/E_na');
								iconColor = 'FF8DA270';
							case 'girlfriend-playable':
								frames = Paths.getSparrowAtlas('characters/other/Playable_GF');
								iconColor = 'FFA5004D';
							case 'girlfriend-playable-bw':
								frames = Paths.getSparrowAtlas('characters/other/bw/Playable_GF');
								iconColor = 'FF3A3A3A';
						}
					case 'luckyGuy' | 'unidentified':
						frames = Paths.getSparrowAtlas('characters/arts_and_crafters_from_baldis_basics');
						iconColor = 'FF7AAEA6';
						addOffset('idle', 149, 162);
						addOffset("singUP", 342, 181);
						addOffset("singRIGHT", 342, 181);
						addOffset("singLEFT", 342, 180);
						addOffset("singDOWN", 293, 162);

						addOffset("singUPmiss", -29, 27);
						addOffset("singRIGHTmiss", -30, 21);
						addOffset("singLEFTmiss", 12, 24);
						addOffset("singDOWNmiss", -11, -19);

						addOffset("hey", 7, 4);

						addOffset("firstDeath", -24, -6);
						addOffset("deathLoop", -28, -10);
						addOffset("deathConfirm", -28, -9);

						addOffset("scared", -4, 0);
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
			case 'bf-bbpanzu':
				frames = Paths.getSparrowAtlas('characters/other/bb');
				iconColor = 'FF009933';

				animation.addByPrefix('idle', 'bb idle', 24, false);
				animation.addByPrefix('singUP', 'bb up0', 24, false);
				animation.addByPrefix('singDOWN', 'bb down0', 24, false);
				animation.addByPrefix('singLEFT', 'bb left0', 24, false);
				animation.addByPrefix('singRIGHT', 'bb right0', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singRIGHT", 0, 0);

				playAnim('idle');

				flipX = true;
			case 'bbdead':
				frames = Paths.getSparrowAtlas('characters/other/bbdead');
				iconColor = 'FF009933';

				animation.addByPrefix('singUP', "bb deadfirst", 24, false); // to not get null object reference'd
				animation.addByPrefix('firstDeath', "bb deadfirst", 24, false);
				animation.addByPrefix('deathLoop', "bb deadloop", 24, false);
				animation.addByPrefix('deathConfirm', "bb deadconfirm", 24, false);

				addOffset("singUP", 0, 0);
				addOffset("firstDeath", 0, 0);
				addOffset("deathLoop", 0, 0);
				addOffset("deathConfirm", 0, 0);

				playAnim('firstDeath');
				/*
				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				*/

				flipX = true;
			case 'bf-demoncesar':
				frames = Paths.getSparrowAtlas('characters/other/demonCesar');
				iconColor = 'FFE353C8';
				// noteSkin = 'fever';

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
				animation.addByPrefix('transition', 'BF Transition', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -61, 13);
				addOffset("singRIGHT", -75, -10);
				addOffset("singLEFT", -15, -3);
				addOffset("singDOWN", -39, -84);
				addOffset("singUPmiss", -64, 6);
				addOffset("singRIGHTmiss", -74, -19);
				addOffset("singLEFTmiss", -16, -4);
				addOffset("singDOWNmiss", -36, -84);
				addOffset("hey", -54, 1);
				addOffset("transition", -54, 1);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -54, -12);

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
			case 'tankman':
				frames = Paths.getSparrowAtlas('characters/tankmanCaptain');
				iconColor = 'FF2C2D41';
				animation.addByPrefix('idle', "Tankman Idle Dance instance 1", 24, true);
				animation.addByPrefix('singUP', 'Tankman UP note instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note instance 1', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Tankman Note Left instance 1', 24, false);
					animation.addByPrefix('singRIGHT', 'Tankman Right Note instance 1', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Tankman Right Note instance 1', 24, false);
					animation.addByPrefix('singRIGHT', 'Tankman Note Left instance 1', 24, false);
				}
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH instance 1', 24);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD tankman instance 1', 24);
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;
			case 'kaskudek':
				frames = Paths.getSparrowAtlas('characters/Kaskud'); // his short name
				iconColor = 'FF00109A';
				// noteSkin = 'kaskudekNotes';
				animation.addByPrefix('idle', 'Kaskud afk', 24, true);
				animation.addByPrefix('singUP', 'Kaskud tord_up', 24, false);
				animation.addByPrefix('singRIGHT', 'Kaskud rights_of_kaskudek', 24, false);
				animation.addByPrefix('singDOWN', 'Kaskud down_note', 24, false);
				animation.addByPrefix('singLEFT', 'Kaskud lefty', 24, false);

				setGraphicSize(Std.int(width * .9));

				addOffset('idle', 0, 0);
				addOffset("singUP", 30, -5);
				addOffset("singRIGHT", -10, -25);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", -10, -30);
				playAnim('idle');
			case 'paps': //ƎNA & Papyrus are probably going to have their own mod, like Blantados' Senpai and Tankman mod.
				// https://www.youtube.com/watch?v=HXELhoDV5Kg
				frames = Paths.getSparrowAtlas('characters/other/Papyrus_assets');
				iconColor = 'FFFF0100';
				animation.addByPrefix('idle', 'Papyrus Idle', 24, false);
				animation.addByPrefix('singUP', 'Papyrus Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Papyrus Right', 24, false);
				animation.addByPrefix('singDOWN', 'Papyrus Down', 24, false);
				animation.addByPrefix('singLEFT', 'Papyrus Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 3, 20);
				addOffset("singRIGHT", -10, 1);
				addOffset("singLEFT", 11, -5);
				addOffset("singDOWN", 0, -13);

				playAnim('idle');
			case 'zardy' | 'zardyButDark': 
				// Kaskudek told me to chart a Zardy custom song, Corn Maze
				// He found this song on Reddit. No idea who made it. If you know who made it please give me the information.
				switch (curCharacter)
				{
					case 'zardy':
						frames = Paths.getSparrowAtlas('characters/other/Zardy');
					case 'zardyButDark':
						frames = Paths.getSparrowAtlas('characters/other/ZardyDark');
				}
				iconColor = 'FF2C253B';
				animation.addByPrefix('idle', 'Zardy the Idle dance animation', 14, true);
				animation.addByPrefix('singUP', 'Zardy Singin Up animation', 24, false);
				animation.addByPrefix('singRIGHT', 'Zardy Singin Right animation', 24, false);
				animation.addByPrefix('singDOWN', 'Zardy Singin Down animation', 24, false);
				animation.addByPrefix('singLEFT', 'Zardy Singin Left animation', 24, false);

				addOffset('idle');
				addOffset("singUP", -80, -10);
				addOffset("singRIGHT", -65, 5);
				addOffset("singLEFT", 130, 5);
				addOffset("singDOWN", -2, -26);

				playAnim('idle');
			case 'kb':
				frames = Paths.getSparrowAtlas('characters/other/robot');
				iconColor = 'FF505050';

				animation.addByPrefix('danceRight', "KB_DanceRight", 26, false);
				animation.addByPrefix('danceLeft', "KB_DanceLeft", 26, false);
				animation.addByPrefix('singUP', "KB_Up", 24, false);
				animation.addByPrefix('singDOWN', "KB_Down", 24, false);
				animation.addByPrefix('singLEFT', 'KB_Left', 24, false);
				animation.addByPrefix('singRIGHT', 'KB_Right', 24, false);


				//Positive = goes to left / Up. -Haz
				//Negative = goes to right / Down. -Haz
				//wise words.

				addOffset('danceRight', 119, -96);
				addOffset('danceLeft', 160, -105);
				addOffset("singLEFT", 268, 37);
				addOffset("singRIGHT", -110, -161);
				addOffset("singDOWN", 184, -182);
				addOffset("singUP", 173, 52);
			case 'arch':
				frames = Paths.getSparrowAtlas('characters/other/arch');
				iconColor = 'FF666666';

				animation.addByPrefix('idle', 'arch i', 24, false);
				animation.addByPrefix('singUP', 'arch u', 24, false);
				animation.addByPrefix('singDOWN', 'arch d', 24, false);
				animation.addByPrefix('singLEFT', 'arch l' , 24, false);
				animation.addByPrefix('singRIGHT', 'arch r', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singDOWN", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singRIGHT", 0, 0);

				playAnim('idle');
			case 'girlfriend-christmas' | 'girlfriend' | 'girlfriend-bw':
				// DAD ANIMATION LOADING CODE
				switch (curCharacter)
				{
					case 'girlfriend-christmas':
						frames = Paths.getSparrowAtlas('characters/other/GirlfriendChristmas');
						iconColor = 'FFA5004D';
					case 'girlfriend':
						frames = Paths.getSparrowAtlas('characters/other/Girlfriend');
						iconColor = 'FFA5004D';
					case 'girlfriend-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/Girlfriend');
						iconColor = 'FF3A3A3A';
				}
				animation.addByPrefix('idle', 'Girlfriend idle dance', 24);
				animation.addByPrefix('singUP', 'Girlfriend Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Girlfriend Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Girlfriend Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Girlfriend Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
			case 'tord' | 'tom': // Yes, I know they hate themselves, I watched Eddsworld, and?
				// DAD ANIMATION LOADING CODE
				switch (curCharacter)
				{
					case 'tord':
						frames = Paths.getSparrowAtlas('characters/other/tord_assets');
						iconColor = 'FFC11200';
						animation.addByPrefix('idle', 'garcellotired idle dance', 24);
						animation.addByPrefix('singUP', 'garcellotired Sing Note UP', 24);
						animation.addByPrefix('singRIGHT', 'garcellotired Sing Note RIGHT', 24);
						animation.addByPrefix('singDOWN', 'garcellotired Sing Note DOWN', 24);
						animation.addByPrefix('singLEFT', 'garcellotired Sing Note LEFT', 24);
						animation.addByPrefix('singUP-alt', 'garcellotired Sing Note UP', 24);
						animation.addByPrefix('singRIGHT-alt', 'garcellotired Sing Note RIGHT', 24);
						animation.addByPrefix('singLEFT-alt', 'garcellotired Sing Note LEFT', 24);
						animation.addByPrefix('singDOWN-alt', 'garcellotired cough', 24);
						addOffset("singUP-alt", 0, 0);
						addOffset("singRIGHT-alt", 0, 0);
						addOffset("singLEFT-alt", 0, 0);
						addOffset("singDOWN-alt", 0, 0);
					case 'tom':
						frames = Paths.getSparrowAtlas('characters/other/tom_assets');
						iconColor = 'FF265D86';
						animation.addByPrefix('idle', 'garcello idle dance', 24);
						animation.addByPrefix('singUP', 'garcello Sing Note UP', 24);
						animation.addByPrefix('singRIGHT', 'garcello Sing Note RIGHT', 24);
						animation.addByPrefix('singDOWN', 'garcello Sing Note DOWN', 24);
						animation.addByPrefix('singLEFT', 'garcello Sing Note LEFT', 24);
						animation.addByPrefix('lame', 'garcello coolguy', 24);
						addOffset("lame", 0, 0);
				}
				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);

				playAnim('idle');
			case 'sadmouse' | 'sadminnie' | 'happymouse' | 'happymouse2' | 'sadmouse-painted' | 'happymouse-painted' | 'happymouse2-painted' | 'happymouse3-painted': 
				// suicide mouse. haha i can't say it on youtube but while coding i can :P. i think so.
				switch (curCharacter)
				{
					case 'sadmouse' | 'sadminnie' | 'happymouse' | 'happymouse2':
						iconColor = 'FFAFAFAF';
							switch (curCharacter)
							{
								case 'sadmouse':
									frames = Paths.getSparrowAtlas('characters/other/bw/sadmouse_assets');
								case 'sadminnie':
									frames = Paths.getSparrowAtlas('characters/other/bw/sadminnie_assets');
								case 'happymouse':
									frames = Paths.getSparrowAtlas('characters/other/bw/happymouse_assets');
								case 'happymouse2':
									frames = Paths.getSparrowAtlas('characters/other/bw/happymouse2_assets');
									animation.addByPrefix('laugh', 'Laugh', 24, false);
									addOffset("singUP", 0, 40);
							}
					case 'sadmouse-painted' | 'happymouse-painted' | 'happymouse2-painted' | 'happymouse3-painted':
						iconColor = 'FFFAFAFA';
							switch (curCharacter)
							{
								case 'sadmouse-painted':
									frames = Paths.getSparrowAtlas('characters/other/sadmouse_assets');
								case 'happymouse-painted':
									frames = Paths.getSparrowAtlas('characters/other/happymouse_assets');
								case 'happymouse2-painted':
									frames = Paths.getSparrowAtlas('characters/other/happymouse2_assets');
									animation.addByPrefix('laugh', 'Laugh', 24, false);
									addOffset("singUP", 0, 40);
								case 'happymouse3-painted':
									frames = Paths.getSparrowAtlas('characters/other/happymouse3_assets');
									animation.addByPrefix('laugh', 'Laugh', 24, false);
									addOffset("singUP", 0, 40);
							}
				}
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Sing Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sing Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sing Left', 24, false);
				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, 0);
				addOffset("singDOWN", 0, 0);
			case 'sarvente':
				frames = Paths.getSparrowAtlas('characters/other/sarvente_sheet');
				iconColor = 'FFF691C5';

				animation.addByPrefix('idle', "SarventeIdle", 24, false);
				animation.addByPrefix('singUP', "SarventeUp", 24, false);
				animation.addByPrefix('singDOWN', "SarventeDown", 24, false);
				animation.addByPrefix('singLEFT', 'SarventeLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SarventeRight', 24, false);
				animation.addByPrefix('idle-alt', "SarvDarkIdle", 24, false);
				animation.addByPrefix('singUP-alt', "SarvDarkUp2", 24, false);
				animation.addByPrefix('singLEFT-alt', 'SarvDarkLeft2', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'SarvDarkRight2', 24, false);
				animation.addByPrefix('singDOWN-alt', "SarvDarkDown2", 24, false);
				animation.addByPrefix('idle-alt2', "SarvDarkIdle", 24, false);
				animation.addByPrefix('singUP-alt2', "SarvDarkUp0", 24, false);
				animation.addByPrefix('singLEFT-alt2', 'SarvDarkLeft0', 24, false);
				animation.addByPrefix('singRIGHT-alt2', 'SarvDarkRight0', 24, false);
				animation.addByPrefix('singDOWN-alt2', "SarvDarkDown0", 24, false);

				addOffset('idle', -10, -15);
				addOffset("singUP", -80, 45);
				addOffset("singRIGHT", -20, -7);
				addOffset("singLEFT", 30, -32);
				addOffset("singDOWN", 40, -83);
				addOffset('idle-alt', -10, -15);
				addOffset("singUP-alt", -90, 40);
				addOffset("singRIGHT-alt", -60, -19);
				addOffset("singLEFT-alt", 0, -38);
				addOffset("singDOWN-alt", 40, -83);
				addOffset('idle-alt2', -10, -15);
				addOffset("singUP-alt2", -80, 45);
				addOffset("singRIGHT-alt2", -20, -7);
				addOffset("singLEFT-alt2", 30, -32);
				addOffset("singDOWN-alt2", 40, -83);

				playAnim('idle');
			case 'ruv':
				frames = Paths.getSparrowAtlas('characters/other/ruv_sheet');
				iconColor = 'FF978AA6';

				animation.addByPrefix('idle', "RuvIdle", 24, false);
				animation.addByPrefix('idle-alt', "RuvIdle", 24, false);
				animation.addByPrefix('singUP', "RuvUp", 24, false);
				animation.addByPrefix('singDOWN', "RuvDown", 24, false);
				animation.addByPrefix('singLEFT', 'RuvLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'RuvRight', 24, false);

				if (isPlayer)
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", 160, 0);
					addOffset("singRIGHT", 20, -60);
					addOffset("singLEFT", 90, 0);
					addOffset("singDOWN", 110, 5);
				}
				else
				{
					addOffset('idle');
					addOffset('idle-alt');
					addOffset("singUP", -10, 0);
					addOffset("singRIGHT", -30, 0);
					addOffset("singLEFT", 90, -60);
					addOffset("singDOWN", 40, 5);
				}	

				playAnim('idle');
			case 'tord-r' | 'tom-r' | 'edd-r' | 'matt-r': // Eddsworld crew :)
				switch (curCharacter)
				{
					case 'tord-r':
						frames = Paths.getSparrowAtlas('characters/other/tord_remastered_assets');
						iconColor = 'FFC11200';
					case 'tom-r':
						frames = Paths.getSparrowAtlas('characters/other/tom_remastered_assets');
						iconColor = 'FF265D86';
					case 'edd-r':
						frames = Paths.getSparrowAtlas('characters/other/edd_remastered_assets');
						iconColor = 'FF029835';
					case 'matt-r':
						frames = Paths.getSparrowAtlas('characters/other/matt_ew_remastered_assets');
						iconColor = 'FFA55BA0';
				}

				animation.addByPrefix('idle', "tord idle", 24, false);
				animation.addByPrefix('singUP', "tord up", 24, false);
				animation.addByPrefix('singDOWN', "tord down", 24, false);
				animation.addByPrefix('singLEFT', 'tord left', 24, false);
				animation.addByPrefix('singRIGHT', 'tord right', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", -4, -21);
				addOffset("singRIGHT", -30, -13);
				addOffset("singLEFT", 9, 21);
				addOffset("singDOWN", 20, -17);

				playAnim('idle');
			case 'sonic-exe':
				frames = Paths.getSparrowAtlas('characters/other/Sonic_EXE_Assets');
				iconColor = 'FF001366';
				animation.addByPrefix('idle', 'SONICmoveIDLE', 24);
				animation.addByPrefix('singUP', 'SONICmoveUP', 24);
				animation.addByPrefix('singRIGHT', 'SONICmoveRIGHT', 24);
				animation.addByPrefix('singDOWN', 'SONICmoveDOWN', 24);
				animation.addByPrefix('singLEFT', 'SONICmoveLEFT', 24);
				animation.addByPrefix('iamgod', 'sonicImmagetya', 24, false);

				animation.addByPrefix('singDOWN-alt', 'SONIClaugh', 24);

				animation.addByPrefix('singLAUGH', 'SONIClaugh', 24);

				addOffset('idle');
				addOffset('iamgod', 127, 10);
				addOffset("singUP", 14, 47);
				addOffset("singRIGHT", 16, 14);
				addOffset("singLEFT", 152, -15);
				addOffset("singDOWN", 77, -12);
				addOffset("singLAUGH", 50, -10);

				addOffset("singDOWN-alt", 50, -10);

				playAnim('idle');
			case 'sunday':
				iconColor ='FF5E9499';
				frames = Paths.getSparrowAtlas('characters/other/sunday_assets');
				animation.addByPrefix('idle-alt', 'sunday alt idle', 24, true);
				animation.addByPrefix('idle', 'sunday idle', 24, true);
				animation.addByPrefix('singUP', 'sunday up', 24, false);
				animation.addByPrefix('singUP-alt', 'sunday alt up', 24, false);
				animation.addByPrefix('singDOWN', 'sunday down', 24, false);
				animation.addByPrefix('singLEFT', 'sunday left', 24, false);
				animation.addByPrefix('singRIGHT', 'sunday right', 24, false);

				addOffset('idle',1,1);
				addOffset('idle-alt',1,1);
				addOffset("singDOWN", 157, -27);
				addOffset("singRIGHT", -71,-10);
				addOffset("singUP", 137, 147);
				addOffset("singUP-alt", 137, 147);
				addOffset("singLEFT", 39, -1);
				
				if (PlayState.SONG.song.toLowerCase() == "valentine"){
					playAnim('idle-alt');
				}else{
					playAnim('idle');
				}
			case 'bf-sunday':
				iconColor ='FF5E9499';
				frames = Paths.getSparrowAtlas('characters/other/sunday_assets');
				animation.addByPrefix('idle-alt', 'sunday alt idle', 24, true);
				animation.addByPrefix('idle', 'sunday idle', 24, true);
				animation.addByPrefix('singUP', 'sunday up', 24, false);
				animation.addByPrefix('singUP-alt', 'sunday alt up', 24, false);
				animation.addByPrefix('singDOWN', 'sunday down', 24, false);
				animation.addByPrefix('singLEFT', 'sunday left', 24, false);
				animation.addByPrefix('singRIGHT', 'sunday right', 24, false);

				addOffset('idle', 1, 1);
				addOffset('idle-alt', 28, 3);
				addOffset("singDOWN", 117, -27);
				addOffset("singRIGHT", -11, -1);
				addOffset("singUP", 125, 147);
				addOffset("singUP-alt", 125, 147);
				addOffset("singLEFT", 30, -10);
			case 'sky-happy':
				frames = Paths.getSparrowAtlas('characters/other/sky_assets');
				iconColor = 'FF9C6ECC';

				animation.addByIndices('danceLeft', 'sky idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'sky idle', [8, 10, 12, 14], "", 12, false);

				animation.addByPrefix('singUP', 'sky up', 24, false);
				animation.addByPrefix('singDOWN', 'sky down', 24, false);
				animation.addByPrefix('singLEFT', 'sky left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky right', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0,  0);
				
				if (isPlayer)
				{
					addOffset("singUP", 46, 10);
					addOffset("singDOWN", -5, -35);
				}
				else
				{
					addOffset("singUP", -54, 10);
					addOffset("singDOWN", 5, -35);
				}
				
				playAnim('danceRight');
			case 'sky-annoyed' | 'sky-annoyed-bw':
				switch (curCharacter)
				{
					case 'sky-annoyed':
						frames = Paths.getSparrowAtlas('characters/other/sky_annoyed_assets');
						iconColor = 'FF9C6ECC';
					case 'sky-annoyed-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/sky_annoyed_assets');
						iconColor = 'FF868686';
				}

				animation.addByIndices('danceRight', 'sky annoyed idle', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('danceLeft', 'sky annoyed idle', [8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
				animation.addByPrefix('singUP', 'sky annoyed up', 24, false);
				animation.addByPrefix('singDOWN', 'sky annoyed down', 24, false);
				animation.addByPrefix('singLEFT', 'sky annoyed left', 24, false);
				animation.addByPrefix('singRIGHT', 'sky annoyed right', 24, false);
				
				animation.addByPrefix('oh', 'sky annoyed oh', 24, true);
				animation.addByPrefix('grr', 'sky annoyed grr', 24, true);
				animation.addByPrefix('huh', 'sky annoyed huh', 24, true);
				animation.addByPrefix('ugh', 'sky annoyed ugh', 24, false);
				animation.addByPrefix('manifest', 'sky annoyed manifest', 24, false);
				
				animation.addByIndices('danceRight-alt', 'sky annoyed alt idle', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('danceLeft-alt', 'sky annoyed alt idle', [8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
				animation.addByPrefix('singUP-alt', 'sky annoyed alt up', 24, false);
				animation.addByPrefix('singDOWN-alt', 'sky annoyed alt down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'sky annoyed alt left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sky annoyed alt right', 24, false);
				
				addOffset('danceRight');
				addOffset('danceLeft');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				
				addOffset("oh");
				addOffset("grr");
				addOffset("huh");
				addOffset("ugh");
				addOffset("manifest");
				
				addOffset('danceRight-alt');
				addOffset('danceLeft-alt');
				addOffset("singUP-alt");
				addOffset("singRIGHT-alt");
				addOffset("singLEFT-alt");
				addOffset("singDOWN-alt");
				
				
				playAnim('danceRight');
			case 'huggy': // I had to read the json myself.
				// I really need to add Psych Engine character adding. It will be much easier.
				// It's bad, but at least it's not a nightmare, copy-pasting is faster.
				frames = Paths.getSparrowAtlas('characters/other/huggy');
				iconColor = 'FFD8558E'; // converting decimals to hex is not that bad. At least I have paint.net :)
				animation.addByPrefix('idle', 'huggyidle', 24);
				animation.addByPrefix('singUP', 'huggyup', 24);
				animation.addByPrefix('singDOWN', 'huggydown', 24);
				animation.addByPrefix('singLEFT', 'huggyleft', 24);
				animation.addByPrefix('singRIGHT', 'huggyright', 24);

				addOffset('idle', 30, 220);
				// up
				addOffset("singDOWN", 110, -180);
				// left
				// right

				if (isPlayer)
				{
					addOffset("singUP", 114, 231);
					addOffset("singLEFT", 230, 197);
					addOffset("singRIGHT", -10, 166);
				}
				else
				{
					addOffset("singUP", 224, 221);
					addOffset("singLEFT", 80, 157);
					addOffset("singRIGHT", 80, 196);
				}

				playAnim('idle');
			case 'baldi' | 'baldi-bw':
				switch (curCharacter)
				{
					case 'baldi':
						frames = Paths.getSparrowAtlas('characters/other/BALDI', 'shared');
						iconColor = 'FF00DD3B';
					case 'baldi-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/BALDI', 'shared');
						iconColor = 'FF888888';
				}

				animation.addByPrefix('idle', 'idle', 24);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);

				addOffset('idle');
				addOffset("singUP", 265, 83);
				addOffset("singRIGHT", 91, -106);
				addOffset("singLEFT", 79, 30);
				addOffset("singDOWN", 36, -397);

				playAnim('idle');
			case 'monika-real' | 'monika-real-bw':
				// I love my wife - SirDuSterBuster
				switch (curCharacter)
				{
					case 'monika-real':
						frames = Paths.getSparrowAtlas('characters/other/Doki_MonikaNonPixel_Assets');
						iconColor = 'FF8CD465';
					case 'monika-real-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/Doki_MonikaNonPixel_Assets');
						iconColor = 'FFB2B2B2';
				}
				animation.addByPrefix('idle', 'Monika Returns Idle', 24, false);
				animation.addByPrefix('singUP', 'Monika Returns Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Monika Returns Right', 24, false);
				animation.addByPrefix('singDOWN', 'Monika Returns Down', 24, false);
				animation.addByPrefix('singLEFT', 'Monika Returns Left', 24, false);

				animation.addByPrefix('singUP-alt', 'Monika Returns Up', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Monika Returns Right', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Monika Returns Down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Monika Returns Left', 24, false);

				addOffset('idle');
				addOffset("singDOWN", -23, -57);
				addOffset("singRIGHT", -35, -10);
				addOffset("singUP", -103, 17);
				addOffset("singLEFT", -22, 42);
				addOffset("singDOWN-alt", -23, -57);
				addOffset("singRIGHT-alt", -35, -10);
				addOffset("singUP-alt", -103, 17);
				addOffset("singLEFT-alt", -22, 42);
				

				setGraphicSize(Std.int(width * .9));
				playAnim('idle');
			case 'sayori' | 'sayori-bw':
				// and the blind forest
				switch (curCharacter)
				{
					case 'sayori':
						frames = Paths.getSparrowAtlas('characters/other/Doki_Sayo_Assets');
						iconColor = 'FF95E0FA';
					case 'sayori-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/Doki_Sayo_Assets');
						iconColor = 'FFCDCDCD';
				}
				animation.addByIndices('danceLeft', 'Sayo Idle nrw test', [25, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceRight', 'Sayo Idle nrw test', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24], "", 24, false);
				// animation.addByPrefix('idle', 'Sayo Idle', 24, false);
				animation.addByPrefix('singUP', 'Sayo Sing Note Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Sayo Sing Note Right', 24, false);
				animation.addByPrefix('singDOWN', 'Sayo Sing Note Down', 24, false);
				animation.addByPrefix('singLEFT', 'Sayo Sing Note Left', 24, false);
				animation.addByPrefix('nara', 'Sayo Nara animated', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				addOffset("singUP", -31, 43);
				addOffset("singRIGHT", -92, -8);
				addOffset("singLEFT", -22, -2);
				addOffset("singDOWN", -52, -44);
				addOffset("nara", -21, 1);

				playAnim('danceRight');
			case 'agoti' | 'agoti-bw' | 'bf-agoti' | 'bf-agoti-bw':
				iconColor = 'FF494949';
				switch (curCharacter)
				{
					case 'agoti' | 'bf-agoti':
						frames = Paths.getSparrowAtlas('characters/other/AGOTI');
					case 'agoti-bw' | 'bf-agoti-bw':
						frames = Paths.getSparrowAtlas('characters/other/bw/AGOTI');
				}
				animation.addByPrefix('idle', 'Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Agoti_Left', 24);

				switch (curCharacter)
				{
					case 'agoti' | 'agoti-bw':
						addOffset('idle', 0, 140);
						addOffset("singUP", 90, 220);
						addOffset("singRIGHT", 130, 90);
						addOffset("singLEFT", 240, 170);
						addOffset("singDOWN", 70, -50);
					case 'bf-agoti' | 'bf-agoti-bw':
						addOffset('idle', 0, 0);
						addOffset("singUP", -5, 60);
						addOffset("singRIGHT", 160, 25);
						addOffset("singLEFT", 243, -52);
						addOffset("singDOWN", 106, -190);
				}

				playAnim('idle');
			case 'eteled1' | 'eteled1-bw':
				switch (curCharacter)
				{
					case 'eteled1':
						iconColor = 'FFFFFFFF';
						frames = Paths.getSparrowAtlas('characters/other/eteled1_assets');
					case 'eteled1-bw':
						iconColor = 'FF949494';
						frames = Paths.getSparrowAtlas('characters/other/bw/eteled1_assets');
				}
				animation.addByPrefix('idle', 'eteled idle dance', 24);
				animation.addByPrefix('singUP', 'eteled Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'eteled Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'eteled Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'eteled Sing Note LEFT', 24);
				animation.addByPrefix('intro', 'eteled INTRO', 24);

				addOffset('idle', 0, 0);
				addOffset("singUP", 4, 8);
				addOffset("singRIGHT", 10, -13);
				addOffset("singLEFT", 66, 5);
				addOffset("singDOWN", 4, -35);
				addOffset("intro", 0, 0);

				playAnim('idle');
			case 'hd-senpai-giddy':
				frames = Paths.getSparrowAtlas('characters/other/HD_SENPAI_GIDDY');
				iconColor = 'FFFFAA6F';
							
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Dad Die', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Dad UGH', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singDOWN-alt", -8, -32);
				addOffset("singDOWN", -9, -33);
				addOffset("singRIGHT", -26, 17);
				addOffset("singLEFT-alt", -20, 10);
				addOffset("singUP", -4, 50);
				addOffset("singLEFT", -20, 10);

				playAnim('idle');
			case 'whitty':
				frames = Paths.getSparrowAtlas('characters/other/WhittySprites');
				iconColor = 'FF1D1E35';
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);

				addOffset('idle', 0,0 );
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
			case 'taki':
				frames = Paths.getSparrowAtlas('characters/other/taki_assets');
				iconColor = 'FFD34470';
				// noteSkin = 'taki';

				animation.addByPrefix('idle', 'takiidle', 24, true);
				animation.addByPrefix('singUP', 'takiup', 24, false);
				animation.addByPrefix('singDOWN', 'takidown', 24, false);
				animation.addByPrefix('singLEFT', 'takileft', 24, false);
				animation.addByPrefix('singRIGHT', 'takiright', 24, false);

				addOffset("idle", 0, 0);
				addOffset("singUP", -5, -13);
				addOffset("singRIGHT", 10, -10);
				addOffset("singLEFT", 0, -10);
				addOffset("singDOWN", 30, -50);

				playAnim('idle');
			case 'majin':
				frames = Paths.getSparrowAtlas('characters/other/SonicFunAssets');
				iconColor = 'FF3C008A';
				animation.addByPrefix('idle', 'SONICFUNIDLE', 24);
				animation.addByPrefix('singUP', 'SONICFUNUP', 24);
				animation.addByPrefix('singRIGHT', 'SONICFUNRIGHT', 24);
				animation.addByPrefix('singDOWN', 'SONICFUNDOWN', 24);
				animation.addByPrefix('singLEFT', 'SONICFUNLEFT', 24);

				addOffset('idle', -21, 66);
				addOffset("singUP", 21, 70);
				addOffset("singRIGHT", -86, 15);
				addOffset("singLEFT", 393, -60);
				addOffset("singDOWN", 46, -80);

				playAnim('idle');
			case 'jeff':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/other/jeffsprite','shared');
				iconColor = 'FFFFAA6F';
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing note UP', 24);
				animation.addByPrefix('singRIGHT', 'dad sing note right', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				
				addOffset('idle', 0, -51);
				addOffset("singUP", 7, 135);
				addOffset("singRIGHT", 132, -116);
				addOffset("singLEFT", -10, -102);
				addOffset("singDOWN", 32, -42);

				playAnim('idle');
			case 'lexi-new' | 'aoki-new' | 'oswald' | 'oswald-happy' | 'lodger' | 'freddy':
				// New Lexi doesn't work for some reason. No idea why. I only checked new Aoki and Lodger for test purposes only.
				// bcuz sometimes i just wanna use the psych jsons without the lag. was totally worth implementing.
				isCustom = true;
				
				var characterPath:String = 'images/characters/' + curCharacter + '/' + curCharacter;
				var path:String = Paths.jsonNew(characterPath);

				if (!FileSystem.exists(path))
				{
					trace('nvm we usin bf');
					path = Paths.jsonNew('images/characters/bf/bf'); //If a character couldn't be found, change him to BF just to prevent a crash
				}
					
				var rawJson = File.getContent(path);

				var json:CharacterFile = cast Json.parse(rawJson);

				var txtToFind:String = Paths.txtNew('images/' + json.image);

				if(FileSystem.exists(txtToFind))
					frames = Paths.getPackerAtlas(json.image);
				else 
					frames = Paths.getSparrowAtlas(json.image);

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

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

				trace(colorPreCut);

				iconColor = colorPreCut.substring(2);

				antialiasing = !noAntialiasing;

				animationsArray = json.animations;
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
					}
				} else {
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
				}

			//using the psych method instead of modding plus. main reason is to make it easier for me to port them here
			default:
				isCustom = true;
				
				var characterPath:String = 'images/characters/' + curCharacter + '/' + curCharacter;
				var path:String = Paths.jsonNew(characterPath);
				trace('found '+ curCharacter);

				if (!FileSystem.exists(path))
				{
					trace('nvm we usin bf');
					path = Paths.jsonNew('images/characters/bf/bf'); //If a character couldn't be found, change him to BF just to prevent a crash
				}
					
				var rawJson = File.getContent(path);

				var json:CharacterFile = cast Json.parse(rawJson);

				var txtToFind:String = Paths.txtNew('images/' + json.image);
				var rawPic = BitmapData.fromFile(Paths.image(json.image));
				var rawXml:String;

				if(FileSystem.exists(txtToFind))
				{
					rawXml = sys.io.File.getContent(Paths.txtNew('images/' + json.image));
					frames = FlxAtlasFrames.fromSpriteSheetPacker(rawPic,rawXml);
				}
				else 
				{
					rawXml = sys.io.File.getContent(Paths.xmlNew('images/' + json.image));
					frames = FlxAtlasFrames.fromSparrow(rawPic,rawXml);
				}

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

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

				trace(colorPreCut);

				iconColor = colorPreCut.substring(2);

				antialiasing = !noAntialiasing;

				animationsArray = json.animations;
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
							trace('added '+animAnim+' animation');
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
					}
				} else {
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
				}
		}

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
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'speakers' | 'nothing' | 'speakers-bw' | 'gf-bf-bw' | 'gf-bw' | 'gf-and-bf' | 'gf-and-bf-bw':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky' | 'kb' | 'sky-happy' | 'sky-annoyed' | 'sky-annoyed-bw' | 'sayori' | 'sayori-bw' | 'oswald-happy' | 'oswald' | 'dad-gf-judgev2':
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
					playAnim('idle');
			}
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

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
