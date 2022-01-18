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

using StringTools;

class IKnowWhatYouDidState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var caughtYouInFourK:FlxText;
	var textNumber2:FlxText;
	var sonicCD:FlxSprite;

	override public function create():Void
	{
		FlxG.sound.playMusic(Paths.music('MajinFun'));

		var sonicCD:FlxSprite = new FlxSprite().loadGraphic(Paths.image('MajinFun'));
		add(sonicCD);

        /*
		caughtYouInFourK = new FlxText(0, 0, FlxG.width, 32);
		caughtYouInFourK.setFormat(Paths.font("undertale.ttf"), 32, FlxColor.WHITE, CENTER);
		caughtYouInFourK.text = '\nYou tried to access one of the hidden songs by the chart editor.
        \nIf you really want to play the song, you better wait until the next update (or play the mod where it originates from).
        \nI know what you did and I caught you in 4k, so you better be careful. - teotm :) (the coder) \n \n \n \n \n \n';
		caughtYouInFourK.borderColor = FlxColor.BLACK;
		caughtYouInFourK.borderSize = 3;
		caughtYouInFourK.borderStyle = FlxTextBorderStyle.OUTLINE;
		caughtYouInFourK.screenCenter();
		add(caughtYouInFourK);

		textNumber2 = new FlxText(0, 0, FlxG.width, 28);
		textNumber2.setFormat(Paths.font("lyrics.ttf"), 28, FlxColor.WHITE, CENTER);
		textNumber2.text = '\n \n \n \n \n \n \n \n \n \n \nPress Enter to go back to the Main Menu.';
		textNumber2.borderColor = FlxColor.BLACK;
		textNumber2.borderSize = 3;
		textNumber2.borderStyle = FlxTextBorderStyle.OUTLINE;
		textNumber2.screenCenter();
		add(textNumber2);
        */

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
        if (FlxG.keys.justPressed.S)
        {
            fancyOpenURL("https://www.youtube.com/watch?v=_bF4f5sn5FQ/"); // you're on blast
        }
	}

	override function beatHit()
	{
		super.beatHit();
	}
}
