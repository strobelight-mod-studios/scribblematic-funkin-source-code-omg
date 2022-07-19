package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	// NOTE!!!: If you build the mod in Debug version, dialogues won't work for some reason. They will be working fine in Release version.
	// - teotm

	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite; // GF (normal)
	var portraitRight:FlxSprite; // BF
	var portraitGF:FlxSprite;
	var portraitGFcheer:FlxSprite;
	var portraitKaskudek:FlxSprite;
	var portraitKaskudekAngry:FlxSprite; // not deleting these variables
	var portraitKaskudekScared:FlxSprite;
	var portraitKaskudekChill:FlxSprite;
	var portraitBFScribblematic:FlxSprite;
	var portraitGFScribblematic:FlxSprite;
	var portraitChillGrunt:FlxSprite;
//	var portraitTemplate:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (StringTools.replace(PlayState.SONG.song.toLowerCase()," ","-"))
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (StringTools.replace(PlayState.SONG.song.toLowerCase()," ","-"))
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'tutorial' | 'vault' | 'intense-training' | 'intense training' | 'velocity':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.width = 200;
				box.height = 200;
				box.x = 100;
				box.y = 375;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-1500, 10);
		portraitLeft.frames = Paths.getSparrowAtlas('portraits/gfPortrait', 'shared');
		portraitLeft.animation.addByPrefix('enter', 'Girlfiend Portrait Enter instance 1', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.175));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitGF = new FlxSprite(-1500, 10);
		portraitGF.frames = Paths.getSparrowAtlas('portraits/gfPortrait', 'shared');
		portraitGF.animation.addByPrefix('enter', 'Girlfiend Portrait Enter instance 1', 24, false);
		portraitGF.setGraphicSize(Std.int(portraitGF.width * PlayState.daPixelZoom * 0.175));
		portraitGF.updateHitbox();
		portraitGF.scrollFactor.set();
		add(portraitGF);
		portraitGF.visible = false;

		portraitKaskudek = new FlxSprite(-1500, 10);
		portraitKaskudek.frames = Paths.getSparrowAtlas('portraits/kaskudekPortrait', 'shared');
		portraitKaskudek.animation.addByPrefix('enter', 'Kaskudek Portrait Enter instance 1', 24, false);
		portraitKaskudek.setGraphicSize(Std.int(portraitKaskudek.width * PlayState.daPixelZoom * 0.175));
		portraitKaskudek.updateHitbox();
		portraitKaskudek.scrollFactor.set();
		add(portraitKaskudek);
		portraitKaskudek.visible = false;

		portraitChillGrunt = new FlxSprite(-1500, 10);
		portraitChillGrunt.frames = Paths.getSparrowAtlas('portraits/chillGruntPortrait', 'shared');
		portraitChillGrunt.animation.addByPrefix('enter', 'Chill Grunt Portrait Enter instance 1', 24, false);
		portraitChillGrunt.setGraphicSize(Std.int(portraitChillGrunt.width * PlayState.daPixelZoom * 0.175));
		portraitChillGrunt.updateHitbox();
		portraitChillGrunt.scrollFactor.set();
		add(portraitChillGrunt);
		portraitChillGrunt.visible = false;

		portraitKaskudekAngry = new FlxSprite(-1500, 10);
		portraitKaskudekAngry.frames = Paths.getSparrowAtlas('portraits/kaskudekAngeryPortrait', 'shared');
		portraitKaskudekAngry.animation.addByPrefix('enter', 'Kaskudek Angery Portrait Enter instance 1', 24, false);
		portraitKaskudekAngry.setGraphicSize(Std.int(portraitKaskudekAngry.width * PlayState.daPixelZoom * 0.175));
		portraitKaskudekAngry.updateHitbox();
		portraitKaskudekAngry.scrollFactor.set();
		add(portraitKaskudekAngry);
		portraitKaskudekAngry.visible = false;

		portraitKaskudekChill = new FlxSprite(-1500, 10);
		portraitKaskudekChill.frames = Paths.getSparrowAtlas('portraits/kaskudekChilledOut', 'shared');
		portraitKaskudekChill.animation.addByPrefix('enter', 'Kaskudek Chilled out Portrait Enter instance 1', 24, false);
		portraitKaskudekChill.setGraphicSize(Std.int(portraitKaskudekChill.width * PlayState.daPixelZoom * 0.175));
		portraitKaskudekChill.updateHitbox();
		portraitKaskudekChill.scrollFactor.set();
		add(portraitKaskudekChill);
		portraitKaskudekChill.visible = false;

		portraitKaskudekScared = new FlxSprite(-1500, 10);
		portraitKaskudekScared.frames = Paths.getSparrowAtlas('portraits/kaskudekScared', 'shared');
		portraitKaskudekScared.animation.addByPrefix('enter', 'Kaskudek Scared Portrait Enter instance 1', 24, false);
		portraitKaskudekScared.setGraphicSize(Std.int(portraitKaskudekScared.width * PlayState.daPixelZoom * 0.175));
		portraitKaskudekScared.updateHitbox();
		portraitKaskudekScared.scrollFactor.set();
		add(portraitKaskudekScared);
		portraitKaskudekScared.visible = false;

		portraitRight = new FlxSprite(-50, 40);
		portraitRight.frames = Paths.getSparrowAtlas('portraits/boyfriendPortrait', 'shared');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend Portrait Enter instance 1', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.15));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitGFcheer = new FlxSprite(-50, 40);
		portraitGFcheer.frames = Paths.getSparrowAtlas('portraits/gfCheerPortrait', 'shared');
		portraitGFcheer.animation.addByPrefix('enter', 'Cheering GF Portrait Enter instance 1', 24, false);
		portraitGFcheer.setGraphicSize(Std.int(portraitGFcheer.width * PlayState.daPixelZoom * 0.15));
		portraitGFcheer.updateHitbox();
		portraitGFcheer.scrollFactor.set();
		add(portraitGFcheer);
		portraitGFcheer.visible = false;

		portraitBFScribblematic = new FlxSprite(-50, 40);
		portraitBFScribblematic.frames = Paths.getSparrowAtlas('portraits/boyfriendScribblematicPortrait', 'shared');
		portraitBFScribblematic.animation.addByPrefix('enter', 'Scribblematic Boyfriend Portrait Enter instance 1', 24, false);
		portraitBFScribblematic.setGraphicSize(Std.int(portraitBFScribblematic.width * PlayState.daPixelZoom * 0.15));
		portraitBFScribblematic.updateHitbox();
		portraitBFScribblematic.scrollFactor.set();
		add(portraitBFScribblematic);
		portraitBFScribblematic.visible = false;

		portraitGFScribblematic = new FlxSprite(-50, 40);
		portraitGFScribblematic.frames = Paths.getSparrowAtlas('portraits/gfScribblematicPortrait', 'shared');
		portraitGFScribblematic.animation.addByPrefix('enter', 'Scribblematic Girlfriend Portrait Enter instance 1', 24, false);
		portraitGFScribblematic.setGraphicSize(Std.int(portraitGFScribblematic.width * PlayState.daPixelZoom * 0.15));
		portraitGFScribblematic.updateHitbox();
		portraitGFScribblematic.scrollFactor.set();
		add(portraitGFScribblematic);
		portraitGFScribblematic.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);
		portraitGF.screenCenter(X);
		portraitKaskudek.screenCenter(X);
		portraitKaskudekAngry.screenCenter(X);
		portraitKaskudekChill.screenCenter(X);
		portraitKaskudekScared.screenCenter(X);
		portraitChillGrunt.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('hand', 'shared'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Arial';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Arial';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitGF.visible = false;
						portraitKaskudek.visible = false;
						portraitKaskudekAngry.visible = false;
						portraitKaskudekChill.visible = false;
						portraitKaskudekScared.visible = false;
						portraitChillGrunt.visible = false;
						portraitRight.visible = false;
						portraitGFcheer.visible = false;
						portraitBFScribblematic.visible = false;
						portraitGFScribblematic.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekChill.visible = false;
				portraitKaskudekScared.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = true;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekChill.visible = false;
				portraitKaskudekScared.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekChill.visible = false;
				portraitKaskudekScared.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = true;
				if (!portraitGF.visible)
				{
					portraitGF.visible = true;
					portraitGF.animation.play('enter');
				}
			case 'gfCheer' | 'gfcheer':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekChill.visible = false;
				portraitKaskudekScared.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = false;
				if (!portraitGFcheer.visible)
				{
					portraitGFcheer.visible = true;
					portraitGFcheer.animation.play('enter');
				}
			case 'kaskudek':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekChill.visible = false;
				portraitKaskudekScared.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = true;
				if (!portraitKaskudek.visible)
				{
					portraitKaskudek.visible = true;
					portraitKaskudek.animation.play('enter');
				}
			case 'kaskudekAngry' | 'kaskudekangry':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekChill.visible = false;
				portraitKaskudekScared.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = true;
				if (!portraitKaskudekAngry.visible)
				{
					portraitKaskudekAngry.visible = true;
					portraitKaskudekAngry.animation.play('enter');
				}
			case 'kaskudekScared' | 'kaskudekscared':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekChill.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = true;
				if (!portraitKaskudekScared.visible)
				{
					portraitKaskudekScared.visible = true;
					portraitKaskudekScared.animation.play('enter');
				}
			case 'kaskudekChill' | 'kaskudekchill':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekScared.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = true;
				if (!portraitKaskudekChill.visible)
				{
					portraitKaskudekChill.visible = true;
					portraitKaskudekChill.animation.play('enter');
				}
			case 'cg' | 'chillgrunt':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekScared.visible = false;
				portraitKaskudekChill.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				box.flipX = true;
				if (!portraitChillGrunt.visible)
				{
					portraitChillGrunt.visible = true;
					portraitChillGrunt.animation.play('enter');
				}
			case 'bf2':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekScared.visible = false;
				portraitKaskudekChill.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = false;
				if (!portraitBFScribblematic.visible)
				{
					portraitBFScribblematic.visible = true;
					portraitBFScribblematic.animation.play('enter');
				}
			case 'gf2':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekScared.visible = false;
				portraitKaskudekChill.visible = false;
				portraitBFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				box.flipX = false;
				if (!portraitGFScribblematic.visible)
				{
					portraitGFScribblematic.visible = true;
					portraitGFScribblematic.animation.play('enter');
				}
			/*
			case 'template':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitGFcheer.visible = false;
				portraitKaskudek.visible = false;
				portraitKaskudekAngry.visible = false;
				portraitKaskudekScared.visible = false;
				portraitKaskudekChill.visible = false;
				portraitBFScribblematic.visible = false;
				portraitGFScribblematic.visible = false;
				portraitChillGrunt.visible = false;
				if (!portraitTemplate.visible)
				{
					portraitTemplate.visible = true;
					portraitTemplate.animation.play('enter');
				}
			*/
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
