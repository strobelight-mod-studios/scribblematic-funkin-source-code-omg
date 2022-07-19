package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.animation.FlxBaseAnimation;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.FlxObject;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.text.FlxText;

using StringTools;

class PreloadStage extends MusicBeatState
{
	public var curStage:String = '';//
	public var camZoom:Float; // The zoom of the camera to have at the start of the game
	public var hideLastBG:Bool = false; // True = hide last BGs and show ones from slowBacks on certain step, False = Toggle visibility of BGs from SlowBacks on certain step
	// Use visible property to manage if BG would be visible or not at the start of the game
	public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
	public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
	// Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
	public var swagBacks:Map<String,
		Dynamic> = []; // Store BGs here to use them later (for example with slowBacks, using your custom stage event or to adjust position in stage debug menu(press 8 while in PlayState with debug build of the game))
	public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = []; // Store Groups
	public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup/swagBacks and script it in stepHit/beatHit function of this file!!)
	public var animatedBacks2:Array<FlxSprite> = []; //doesn't interrupt if animation is playing, unlike animatedBacks
	public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and technically also opponent since Haxe layering moment), fourth [3] in front of arrows and stuff 
	public var slowBacks:Map<Int,
		Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"
	public var toCamHUD:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toCamHUD.push(bgVar);"
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// All of the above must be set or used in your stage case code block!!

	var pre:String = ""; //lol
	var suf:String = ""; //lol2

	//moving the offset shit here too
	public var gfXOffset:Float = 0;
	public var dadXOffset:Float = 0;
	public var bfXOffset:Float = 0;
	public var gfYOffset:Float = 0;
	public var dadYOffset:Float = 0;
	public var bfYOffset:Float = 0;

	var fastCarCanDrive:Bool = false;

	public function new(daStage:String)
	{
		super();
		this.curStage = daStage;
		camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one --shouldn't this just be 0.9 since most use it then switch the zoom for halloween and school?
		pre = "";
		suf = "";
		fastCarCanDrive = false;

		switch (daStage)
		{
			/* Leavin' this one here but as comment, cause who knows? We might go back to this idea.
			case 'takiStage': 
			{
				camZoom = 0.6;

				var bg:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('fever/week2bgtaki'));
				bg.antialiasing = true;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var moreDark = new FlxSprite(0, 0).loadGraphic(Paths.image('fever/effectShit/evenMOREdarkShit'));
				moreDark.cameras = [PlayState.instance.camHUD];
				swagBacks['moreDark'] = moreDark;
				layInFront[2].push(moreDark);
			}
			*/
			case 'street1' | 'street2' | 'street3':
			{
				camZoom = 0.9;

				var bg = new FlxSprite(-500, -200).loadGraphic(Paths.image('sns/'+daStage));
				bg.setGraphicSize(Std.int(bg.width * 0.9));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;		
				swagBacks['bg'] = bg;
				toAdd.push(bg);
			}

			case 'eddhouse':
			{
				var sky:FlxSprite = new FlxSprite(-162.1, -386.1);
				sky.frames = Paths.getSparrowAtlas("tord/sky", "shared");
				sky.animation.addByPrefix("bg_sky1", "bg_sky1");
				sky.animation.addByPrefix("bg_sky2", "bg_sky2");
				sky.animation.play("bg_sky1");
				sky.scrollFactor.set(0.5, 0);
				sky.active = false;
				sky.updateHitbox();
				swagBacks['sky'] = sky;
				toAdd.push(sky);
				
				var bg:FlxSprite = new FlxSprite(-162.1, -386.1);
				bg.frames = Paths.getSparrowAtlas("tord/bgFront", "shared");
				bg.animation.addByPrefix("bg_normal", "bg_normal");
				bg.animation.play("bg_normal");
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				//bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				swagBacks['bg'] = bg;
				toAdd.push(bg);
			}

			case 'zardymaze' | 'fuckyouZardyTime':
			{
				camZoom = 0.9;

				var zardyBackground = new FlxSprite(-600, -200);
				zardyBackground.frames = Paths.getSparrowAtlas('zardy/Maze', 'shared');
				zardyBackground.animation.addByPrefix('Maze','Stage', 16);
				zardyBackground.antialiasing = true;
				zardyBackground.scrollFactor.set(0.9, 0.9);
				zardyBackground.animation.play('Maze');
				swagBacks['zardyBackground'] = zardyBackground;
				toAdd.push(zardyBackground);
			}

			case 'ohshitTheZardySequal':
			{
				camZoom = 0.7;

				var zardyBackground = new FlxSprite(-600, -200);
				zardyBackground.frames = Paths.getSparrowAtlas('zardy/five-minute-song/Zardy2BG', 'shared');
				zardyBackground.animation.addByPrefix('Maze','BG', 24);
				zardyBackground.antialiasing = true;
				zardyBackground.scrollFactor.set(0.9, 0.9);
				zardyBackground.animation.play('Maze');
				swagBacks['zardyBackground'] = zardyBackground;
				toAdd.push(zardyBackground);
			}

			case 'emptystage2':
			{
				camZoom = 0.8;
			
				var bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('emptystageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);
			}

			case 'motherland':
			{
				camZoom = 0.55;

				var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('holofunk/rushia/motherBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.setPosition(-705, -705);
				swagBacks['bg'] = bg;
				toAdd.push(bg);
				
				var bg2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('holofunk/rushia/motherFG'));
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.9, 0.9);
				bg2.active = false;
				bg2.setGraphicSize(Std.int(bg2.width * 1.1));
				bg2.updateHitbox();
				bg2.setPosition(-735, -670);
				swagBacks['bg2'] = bg2;
				toAdd.push(bg2);

				var plants:FlxSprite = new FlxSprite(-705, -705).loadGraphic(Paths.image('holofunk/rushia/plants'));
				plants.antialiasing = true;
				plants.scrollFactor.set(1.3, 1.3);
				plants.active = false;
				plants.setGraphicSize(Std.int(plants.width * 1.5));
				plants.updateHitbox();
				plants.setPosition(-1415, -1220);
				swagBacks['plants'] = plants;
				layInFront[2].push(plants);

				var blackScreen = new FlxSprite(-1000, -500).makeGraphic(Std.int(FlxG.width * 5), Std.int(FlxG.height * 5), FlxColor.BLACK);
				swagBacks['blackScreen'] = blackScreen;
				layInFront[2].push(blackScreen);
			}

			case 'trioStage': // i fixed the bgs and shit!!! - razencro part 1
			{
				// Not to be confused with Some Trio this is Sonic.Exe mod phase III stage :)
				camZoom = 0.9;

				var sSKY:FlxSprite = new FlxSprite(-621.1, -395.65).loadGraphic(Paths.image('exe/Phase3/Glitch'));
				sSKY.antialiasing = true;
				sSKY.scrollFactor.set(0.9, 1);
				sSKY.active = false;
				sSKY.scale.x = 1.2;
				sSKY.scale.y = 1.2;
				swagBacks['sSKY'] = sSKY;
				toAdd.push(sSKY);

				var p3staticbg = new FlxSprite(0, 0);
				p3staticbg.frames = Paths.getSparrowAtlas('exe/NewTitleMenuBG');
				p3staticbg.animation.addByPrefix('P3Static', 'TitleMenuSSBG instance 1', 24, true);
				p3staticbg.animation.play('P3Static');
				p3staticbg.screenCenter();
				p3staticbg.scale.x = 4.5;
				p3staticbg.scale.y = 4.5;
				p3staticbg.visible = false;
				swagBacks['p3staticbg'] = p3staticbg;
				toAdd.push(p3staticbg);

				var trees:FlxSprite = new FlxSprite(-607.35, -401.55).loadGraphic(Paths.image('exe/Phase3/Trees'));
				trees.antialiasing = true;
				trees.scrollFactor.set(0.95, 1);
				trees.active = false;
				trees.scale.x = 1.2;
				trees.scale.y = 1.2;
				swagBacks['trees'] = trees;
				toAdd.push(trees);
				
				var bg2:FlxSprite = new FlxSprite(-623.5, -410.4).loadGraphic(Paths.image('exe/Phase3/Trees2'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(1, 1);
				bg2.active = false;
				bg2.scale.x = 1.2;
				bg2.scale.y = 1.2;
				swagBacks['bg2'] = bg2;
				toAdd.push(bg2);

				var bg:FlxSprite = new FlxSprite(-630.4, -266).loadGraphic(Paths.image('exe/Phase3/Grass'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1.1, 1);
				bg.active = false;
				bg.scale.x = 1.2;
				bg.scale.y = 1.2;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var bgspec = new FlxSprite(-428.5 + 50, -449.35 + 25).makeGraphic(2199, 1203, FlxColor.BLACK);
				bgspec.antialiasing = true;
				bgspec.scrollFactor.set(1, 1);
				bgspec.active = false;
				bgspec.visible = false;

				bgspec.scale.x = 1.2;
				bgspec.scale.y = 1.2;
				swagBacks['bgspec'] = bgspec;
				toAdd.push(bgspec);
			}

			case 'rooftopDay':
			{
				camZoom = 0.8;

				var sky:FlxSprite = new FlxSprite(-450, -300).loadGraphic(Paths.image('scribblematicTrio/sky', 'vsSomeTrioweek'));
				sky.antialiasing = true;
				sky.scrollFactor.set(1, 1);
				swagBacks['sky'] = sky;
				toAdd.push(sky);

				var poster:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('scribblematicTrio/Morbius', 'vsSomeTrioweek'));
				poster.antialiasing = true;
				poster.scrollFactor.set(1, 1);
				swagBacks['poster'] = poster;
				toAdd.push(poster);

				var block:FlxSprite = new FlxSprite(-400, -250).loadGraphic(Paths.image('scribblematicTrio/block1', 'vsSomeTrioweek'));
				block.antialiasing = true;
				block.scrollFactor.set(1, 1);
				swagBacks['block'] = block;
				toAdd.push(block);

				var ground:FlxSprite = new FlxSprite(-450, -350).loadGraphic(Paths.image('scribblematicTrio/Main', 'vsSomeTrioweek'));
				ground.antialiasing = true;
				ground.scrollFactor.set(1, 1);
				swagBacks['ground'] = ground;
				toAdd.push(ground);
			}

			//the end of Blantad's? stuff
			case 'stage' | 'stage-evil' | 'SiIvaGunner':
			{
				camZoom = 0.9;
				var stageShit:String ='';
				var ayo:String ='';

				switch (daStage)
				{
					case 'stage':
						stageShit = '';
						ayo = '';
					case 'stage-evil':
						stageShit = 'evil/';
						ayo = '';
					case 'SiIvaGunner':
						stageShit = '';
						ayo = 'SiIvaGunner/';
				}

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image(stageShit+'stageback'));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image(stageShit+'stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = FlxG.save.data.antialiasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image(ayo+stageShit+'stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				swagBacks['stageCurtains'] = stageCurtains;
				layInFront[2].push(stageCurtains);
			}
			default:
			{
				camZoom = 0.9;
				curStage = 'stage';
				trace('oops. we usin default stage');
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = FlxG.save.data.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				swagBacks['bg'] = bg;
				toAdd.push(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = FlxG.save.data.antialiasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				swagBacks['stageFront'] = stageFront;
				toAdd.push(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = FlxG.save.data.antialiasing;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				swagBacks['stageCurtains'] = stageCurtains;
				layInFront[2].push(stageCurtains);
			}
		}

		switch (daStage)
		{	
			case 'rooftopDay':
				bfXOffset = 330;
				bfYOffset = -300;
				gfXOffset = 140;
			case 'zardymaze' | 'fuckyouZardyTime':
				dadYOffset = 140;
				gfYOffset = 140;
				bfXOffset = 80;
				bfYOffset = 140;	
			case 'motherland':
				bfXOffset = 60;
				bfYOffset = 100;
				gfXOffset = -150;
				gfYOffset = 90;
				dadXOffset = -255;
				dadYOffset = 90;
			case 'mall':
				bfXOffset = 230;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (curStage)
		{
			case 'zardymaze' | 'fuckyouZardyTime' | 'ohshitTheZardySequal':
				if (swagBacks['zardyBackground'].animation.finished){
					swagBacks['zardyBackground'].animation.play('Maze');
				}
			// idc idk
		}
	}

	override function stepHit()
	{
		super.stepHit();

		var array = slowBacks[curStep];
		if (array != null && array.length > 0)
		{
			if (hideLastBG)
			{
				for (bg in swagBacks)
				{
					if (!array.contains(bg))
					{
						var tween = FlxTween.tween(bg, {alpha: 0}, tweenDuration, {
							onComplete: function(tween:FlxTween):Void
							{
								bg.visible = false;
							}
						});
					}
				}
				for (bg in array)
				{
					bg.visible = true;
					FlxTween.tween(bg, {alpha: 1}, tweenDuration);
				}
			}
			else
			{
				for (bg in array)
					bg.visible = !bg.visible;
			}
		}
	}

	// Variables and Functions for Stages
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var walked:Bool = false;
	var walkingRight:Bool = true;
	var stopWalkTimer:Int = 0;
	var pastCurLight:Int = 1;

	override function beatHit()
	{
		super.beatHit();

		if (animatedBacks.length > 0)
		{
			for (bg in animatedBacks)
				bg.animation.play('idle', true);
		}

		if (animatedBacks2.length > 0)
		{
			for (bg in animatedBacks2)
				bg.animation.play('idle');
		}

		switch (curStage)
		{
			// case 'idk':
		}
	}

	var curLight:Int = 0;
	var danced:Bool = false;

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		swagBacks['halloweenBG'].animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if (PlayState.boyfriend.animOffsets.exists('scared')){
			PlayState.boyfriend.playAnim('scared', true);
		}
		if (PlayState.gf.animOffsets.exists('scared')){
		PlayState.gf.playAnim('scared', true);
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var trainSound:FlxSound;

	function trainStart():Void
	{
		trainMoving = true;
		trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			PlayState.gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			var phillyTrain = swagBacks['phillyTrain'];
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		PlayState.gf.playAnim('hairFall');
		swagBacks['phillyTrain'].x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	public function resetFastCar():Void
	{
		var fastCar = swagBacks['fastCar'];
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		if (fastCar.frames != null)
		{
			fastCar.velocity.x = 0;
		}		
		fastCarCanDrive = true;
	}

	public function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		swagBacks['fastCar'].velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if (curStage == 'limo' || curStage == 'limoholo')
			{
				resetFastCar();
			}			
		});
	}

	//airplane shenanigans
	public var graphMode:Int = 0;
	var graphMoveTimer:Int = -1;
	var graphMove:Float = 0;
	var neutralGraphPos:Float = 0;
	var graphBurstTimer:Int = 0;
	var graphPosition:Float;
	var shinyMode:Bool = false;
	var oldMode:Int = 0;

	public function updateGraph() 
	{
		var graphPointer = swagBacks['graphPointer'];
		var grpGraph = swagGroup['grpGraph'];

		graphPointer.y += graphMove;
		
		var theColor = FlxColor.ORANGE;

		if (shinyMode && graphMoveTimer == 1) {
			graphPointer.y += FlxG.random.float(4, 4.1, [0]);
			neutralGraphPos = graphPointer.y;
		}
		
		if (graphMoveTimer > 0) {
			graphMoveTimer--;
		} else if (graphMoveTimer == 0) {
			graphMove = 0;
			graphMoveTimer = -1;
			if (shinyMode) {
				shinyMode = false;
				graphMode = oldMode;
			}
		}
		switch (graphMode) {
			case 0:
				var a = FlxG.random.int(0, 150);
				
				if (graphBurstTimer > 0) {
					graphBurstTimer--;
				} else if (graphBurstTimer == 0) {
					graphBurstTimer = FlxG.random.int(90, 220);
					//graphBurstTimer = -1;
					if (graphMoveTimer <= 0) {
						graphMove = FlxG.random.float(-0.4, 0.4, [0]);
						graphMoveTimer = FlxG.random.int(8, 20);
					}
				}
				if (graphPointer.y < neutralGraphPos - 30)
					graphPointer.y = neutralGraphPos - 30;
				if (graphPointer.y > neutralGraphPos + 30)
					graphPointer.y = neutralGraphPos + 30;
				
			case 1:
				theColor = FlxColor.GREEN;
				var a = FlxG.random.int(0, 130);
				
				if (graphBurstTimer > 0) {
					graphBurstTimer--;
				} else if (graphBurstTimer == 0) {
					graphBurstTimer = FlxG.random.int(80, 180);
					//graphBurstTimer = -1;
					if (graphMoveTimer <= 0) {
						graphMove = FlxG.random.float(-0.6, 0.2, [0]);
						graphMoveTimer = FlxG.random.int(10, 20);
					}
				}
			case 2:
				theColor = FlxColor.RED;
				var a = FlxG.random.int(0, 130);

				if (graphBurstTimer > 0) {
					graphBurstTimer--;
				} else if (graphBurstTimer == 0) {
					graphBurstTimer = FlxG.random.int(80, 180);
					//graphBurstTimer = -1;
					if (graphMoveTimer <= 0) {
						graphMove = FlxG.random.float(-0.2, 0.5, [0]);
						graphMoveTimer = FlxG.random.int(10, 20);
					}
				}
		}

		if (graphPointer.y < -1)
			graphPointer.y = -1;
		if (graphPointer.y > 225)
			graphPointer.y = 225;
			
		var thePoint = new FlxSprite(graphPointer.x, graphPointer.y).makeGraphic(4, 4, theColor);
		swagBacks['thePoint'] = thePoint;
		grpGraph.add(thePoint);

		graphPosition = swagBacks['thePoint'].y;

		if (grpGraph.length > 0) {
			swagGroup['grpGraph'].forEach(function(spr:FlxSprite)
			{
				spr.x -= 0.5;
				if (spr.x < 676.15)
					grpGraph.remove(spr);
			}); 
		}
		if (FlxG.keys.justPressed.I) {
			switchGraphMode(0);
		}
		if (FlxG.keys.justPressed.O) {
			switchGraphMode(1);
		}
		if (FlxG.keys.justPressed.P) {
			switchGraphMode(2);
		}
	}
	function switchGraphMode(mode:Int) 
	{
		var grpGraphIndicators = swagBacks['grpGraphIndicators'];
		var graphPointer = swagBacks['graphPointer'];

		swagGroup['grpGraphIndicators'].forEach(function(spr:FlxSprite)
		{
			spr.visible = false;
		}); 

		grpGraphIndicators.members[mode].visible = true;
		graphMode = mode;
		switch (mode) {
			case 0:
				neutralGraphPos = graphPointer.y;
		}
	}
}