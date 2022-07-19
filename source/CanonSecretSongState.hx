package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

#if GAMEJOLT
import GameJolt;
import GameJolt.GameJoltAPI;
#end

using StringTools;

class CanonSecretSongState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var textNumber1:FlxText;
	var textNumber2:FlxText;
	var naughtyKaskudek:FlxSprite;

	override public function create():Void
	{
		FlxG.sound.playMusic(Paths.music('youve_been_trolled'));

		var naughtyKaskudek:FlxSprite = new FlxSprite().loadGraphic(Paths.image('characters/jsons/kaskudekTheNaughtyBoy'));
		add(naughtyKaskudek);

		textNumber1 = new FlxText(0, 0, FlxG.width, 20);
		textNumber1.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
		textNumber1.text = "Nu-uh-uh! Ya ain't accessing the third song. Sorry bro, wait until 2.0 update comes out. If you really want something REAL secret that you can play, I'll give a hint for you:\n
		Go back, Don't turn back and stay, Type a word with your modern pen. Follow the sound.\n
		I've probably told you too much already";
		textNumber1.borderColor = FlxColor.BLACK;
		textNumber1.borderSize = 3;
		textNumber1.borderStyle = FlxTextBorderStyle.OUTLINE;
		textNumber1.screenCenter();
		add(textNumber1);

		textNumber2 = new FlxText(0, 0, FlxG.width, 28);
		textNumber2.setFormat(Paths.font("lyrics.ttf"), 28, FlxColor.WHITE, CENTER);
		textNumber2.text = '\n \n \n \n \n \n \n \n \n \n \n \nPress Enter to go back to the Main Menu.\nPress Space to see song in playing the background.';
		textNumber2.borderColor = FlxColor.BLACK;
		textNumber2.borderSize = 3;
		textNumber2.borderStyle = FlxTextBorderStyle.OUTLINE;
		textNumber2.screenCenter();
		add(textNumber2);

		blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.BLACK);
		blackScreen.scrollFactor.set();
		add(blackScreen);

		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				blackScreen.alpha -= 0.05;

					if (blackScreen.alpha > 0)
					{
						tmr.reset(0.03);
					}
			});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new MainMenuState());
		}
        if (FlxG.keys.justPressed.SPACE)
        {
            fancyOpenURL("https://www.youtube.com/watch?v=OLpeX4RRo28/"); // STFU
        }
	}


	override function beatHit()
	{
		super.beatHit();
	}
}