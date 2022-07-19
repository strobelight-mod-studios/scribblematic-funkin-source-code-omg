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
#if GAMEJOLT
import GameJolt.GameJoltAPI;
#end

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
		lolText.text = "Hi, there! After some long time, we finally we released the 1.5 update.\n
		Sorry that you had to wait some time. We took a break from modding, due to school, work etc.\n
		As this update releases (19th July) it's my 16th birthday! Yay!\n
		Also, we changed the mod name from Some Trio to Scribblematic Funkin', since the old mod name was going likely to change later.\n
		We're gonna switch to Psych in 2.0 update. Btw some things are unfinished, but we'll fix that in 1.5.5 patch, so don't worry\n
		Have a nice day - teotm\n\n\n\n\n\n";
		lolText.borderColor = FlxColor.BLACK;
		lolText.borderSize = 3;
		lolText.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText.screenCenter();
		add(lolText);

        lolText2 = new FlxText(0, 200, FlxG.width, 24);
		lolText2.setFormat(Paths.font("lyrics.ttf"), 24, FlxColor.WHITE, CENTER);
		lolText2.text = "\n\n\n\n\n\n\n\n\nLil' bit of info:\nEmerald got replaced by chill grunt in the lore due to our agreement.\nAlso, I'll post somewhere the playable BETADCIUs and Covers somewhere else as a Psych modpack, so if you wanna play 'em, you'll have to wait some time.";
		lolText2.borderColor = FlxColor.BLACK;
		lolText2.borderSize = 3;
		lolText2.borderStyle = FlxTextBorderStyle.OUTLINE;
		lolText2.screenCenter();
		lolText2.y += 50;
		add(lolText2);

		lolText3 = new FlxText(0, 200, FlxG.width, 48);
		lolText3.setFormat(Paths.font("sonic1.ttf"), 48, FlxColor.WHITE, CENTER);
		lolText3.text = '\n\n\n\n\n\n\n\n\n\nPress Enter to continue.';
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
	}

	override function beatHit()
	{
		super.beatHit();
	}
}