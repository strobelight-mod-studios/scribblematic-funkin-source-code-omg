package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var voiceline:FlxSound; // fuck this, i'm running out of time. scrapping it till 2.0

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'luckyGuy' | 'unidentified':
				daBf = 'luckyGuy';
			case 'BOCHEN':
				daBf = 'BOCHEN';
			case 'bf-bw':
				daBf = 'bf-bw';
			case 'nene':
				daBf = 'nene';
			case 'aloe':
				daBf = 'aloe';
			case 'sonic':
				daBf = 'sonic';
			case 'lexi':
				daBf = 'lexi';
			case 'girlfriend':
				daBf = 'girlfriend';
			case 'girlfriend-bw':
				daBf = 'girlfriend-bw';
			case 'bf-demoncesar':
				daBf = 'bf-demoncesar';
			case 'lexi-new':
				daBf = 'lexi-new';
			case 'bf-pibby':
				daBf = 'bf-pibby';
			case 'bf-cesar':
				daBf = 'bf-cesar';
			case 'spongebob-tiky':
				daBf = 'spongebob-tiky';
			case 'red3':
				daBf = 'red3';
			case 'kaskudekActualPlayer':
				daBf = 'kaskudekActualPlayer';
			case 'bf-evil':
				daBf = 'bf-evil';
			case 'ena' | 'ǝna' | 'jena' | 'ina' | 'enna' | 'ayna' | 'chaina' /*easter egg purposes only*/:
				daBf = 'ena';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		voiceline = new FlxSound();

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			var pre:String = "";
			var suf:String = "";

			if (FlxG.save.data.langPlEn)
			{
				suf = '-PL';
			}

			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			/*
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'vault':
					playVoiceLine(StringTools.replace(Paths.sound(pre+'KaskudekDeathQuotes'+suf, 'vsSomeTrioweek'), '.ogg', ''), 4); // death quotes let's go
				case 'shining':
					playVoiceLine(StringTools.replace(Paths.sound('EmeraldDeathQuotes', 'vsSomeTrioweek'), '.ogg', ''), 3);
			}
			*/
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	function playVoiceLine(path:String, num:Int = 0) // scrapped, but still coded in
	{
		FlxTween.tween(FlxG.sound.music, {volume: 0.4}, 0.3);

		var rng = Std.string(FlxG.random.int(1, num));

		voiceline.loadEmbedded(path + '/' + rng + '.ogg');
		voiceline.play();
		voiceline.onComplete = function()
		{
			FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.3);
		}
		FlxG.sound.list.add(voiceline);
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			voiceline.volume = 0;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
