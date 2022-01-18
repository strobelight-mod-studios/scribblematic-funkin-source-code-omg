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
import GameJolt.GameJoltAPI;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class DemoState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var lolText:FlxText;
	var lolText2:FlxText;
    var lolText3:FlxText;
	var bg:FlxSprite;

	override public function create():Void
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuAllThree'));
		add(bg);

		lolText = new FlxText(0, 0, FlxG.width - 100, 26);
		lolText.setFormat(Paths.font("lyrics.ttf"), 26, FlxColor.WHITE, CENTER);
		lolText.text = "Hey there! It's a message from the coder (teotm).\n
        Please notice that you're playing the demo of the version of the mod. We need to add two more songs to Story Mode, and the mod will be complete (+bonus ones in Freeplay Mode).\n
        If you have any questions about the mod or something ask me on Discord: teotm#9506\n
        Oh, and also we're working on another mod Friday Night Knock-Knockin'! Vs. Edgar The Lodger from Knock-Knock (it's a video game) with SaraHericProductions, Kaskudek and chill grunt.\n
		I apologize for the huge delay, I hope you understand. Anyways, go enjoy the mod.\n\n\n
		
		
		";
		lolText.borderColor = FlxColor.BLACK;
		lolText.borderSize = 3;
		lolText.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText.screenCenter();
		add(lolText);

        lolText2 = new FlxText(0, 200, FlxG.width, 34);
		lolText2.setFormat(Paths.font("channels.ttf"), 34, FlxColor.WHITE, CENTER);
		lolText2.text = "\n \n \n \n \n \n \n \n \n \nPress Space to check out Knock-Knockin' mod we're working on.";
		lolText2.borderColor = FlxColor.BLACK;
		lolText2.borderSize = 3;
		lolText2.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText2.screenCenter();
		lolText2.y += 50;
		add(lolText2);

		lolText3 = new FlxText(0, 200, FlxG.width, 48);
		lolText3.setFormat(Paths.font("undertale.ttf"), 48, FlxColor.WHITE, CENTER);
		lolText3.text = '\n \n \n \n \n \n \n \n \n Press Enter to continue.';
		lolText3.borderColor = FlxColor.BLACK;
		lolText3.borderSize = 3;
		lolText3.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText3.screenCenter();
		lolText3.y += 50;
		add(lolText3);

		blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.BLACK);
		blackScreen.scrollFactor.set();
		add(blackScreen);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				blackScreen.alpha -= 0.05;

					if (blackScreen.alpha > 0)
					{
						tmr.reset(0.03);
					}
			});

		new FlxTimer().start(2.5, function(tmr2:FlxTimer)
			{
				lolText2.alpha = 1;

					if (lolText2.alpha == 1)
					{
						new FlxTimer().start(2.5, function(tmr3:FlxTimer)
						{
							lolText2.alpha = 0;
			
								if (lolText2.alpha == 0)
								{
									tmr2.reset(0.5);
								}
						});
					}
                lolText3.alpha = 1;

					if (lolText3.alpha == 1)
					{
						new FlxTimer().start(2.5, function(tmr3:FlxTimer)
						{
							lolText3.alpha = 0;
			
								if (lolText3.alpha == 0)
								{
									tmr2.reset(0.5);
								}
						});
					}
			});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(new MainMenuState());
		}
        if (FlxG.keys.justPressed.SPACE)
        {
            fancyOpenURL("https://gamejolt.com/games/knockknockmodyes/680521"); // sara heric productions
        }
	}

	override function beatHit()
	{
		super.beatHit();
	}
}