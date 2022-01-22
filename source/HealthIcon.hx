package;

import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

#if windows
import Sys;
import sys.FileSystem;
#end

#if sys
import sys.io.File;
import haxe.io.Path;
import openfl.utils.ByteArray;
import flash.display.BitmapData;
import sys.FileSystem;
#end

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var char:String = 'bf';
	public var isPlayer:Bool = false;
	public var isOldIcon:Bool = false;

	public function new(?char:String = 'bf', ?isPlayer:Bool = false)
	{
		super();

		this.char = char;
		this.isPlayer = isPlayer;

		useOldSystem(char);
		scrollFactor.set();
	}

	public function changeIcon(char:String)
	{
		if (!FileSystem.exists(Paths.image('icons/icon-' + char)))
			char = 'face';

		var rawPic = BitmapData.fromFile(Paths.image('icons/icon-'+char));
		loadGraphic(rawPic, true, 150, 150);

		/*
		if (char.endsWith('-pixel') || char.startsWith('senpai') || char.startsWith('spirit'))
			antialiasing = false;
		else
			antialiasing = true;
		*/

		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);
	}

	public function useOldSystem(char:String)
	{
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf',                     [0, 1],     0, false, isPlayer);
		animation.add('bf-car',                 [0, 1],     0, false, isPlayer);
		animation.add('bf-christmas',           [0, 1],     0, false, isPlayer);
		animation.add('spooky',                 [2, 3],     0, false, isPlayer);
		animation.add('pico',                   [4, 5],     0, false, isPlayer);
		animation.add('bf-pico',                [4, 5],     0, false, isPlayer);
		animation.add('mom',                    [6, 7],     0, false, isPlayer);
		animation.add('mom-car',                [6, 7],     0, false, isPlayer);
		animation.add('tankman',                [8, 9],     0, false, isPlayer);
		animation.add('face',                   [10, 11],   0, false, isPlayer);
		animation.add('dad',                    [12, 13],   0, false, isPlayer);
		animation.add('bf-old',                 [14, 15],   0, false, isPlayer);
		animation.add('gf',                     [16, 31],   0, false, isPlayer);
		animation.add('gf-christmas',           [16, 31],   0, false, isPlayer);
		animation.add('gf-car',                 [16, 31],   0, false, isPlayer);
		animation.add('gf-pixel',               [16, 31],   0, false, isPlayer);
		animation.add('speakers',               [16, 31],   0, false, isPlayer);
		animation.add('nothing',                [16, 31],   0, false, isPlayer);
		animation.add('speakers-bw',            [16, 31],   0, false, isPlayer);
		animation.add('girlfriend-christmas',   [16, 31],   0, false, isPlayer);
		animation.add('girlfriend-playable',    [16, 31],   0, false, isPlayer);
		animation.add('gf-judgev2',             [16, 31],   0, false, isPlayer);
		animation.add('dad-gf-judgev2',         [16, 16],   0, false, isPlayer);
		animation.add('parents-christmas',      [17, 18],   0, false, isPlayer);
		animation.add('monster',                [19, 20],   0, false, isPlayer);
		animation.add('bf-pixel',               [21, 26],   0, false, isPlayer);
		animation.add('huh',                    [21, 26],   0, false, isPlayer);
		animation.add('senpai',                 [22, 24],   0, false, isPlayer);
		animation.add('senpai-angry',           [27, 28],   0, false, isPlayer);
		animation.add('spirit',                 [23, 25],   0, false, isPlayer);
		animation.add('monster-christmas',      [29, 30],   0, false, isPlayer);
		animation.add('luckyGuy',               [32, 33],   0, false, isPlayer);
		animation.add('unidentified',           [34, 34],   0, false, isPlayer);
		animation.add('kaskudek',               [35, 36],   0, false, isPlayer);
		animation.add('blash',                  [37, 38],   0, false, isPlayer);
		animation.add('zardy',                  [39, 42],   0, false, isPlayer);
		animation.add('ena',                    [40, 41],   0, false, isPlayer);
		animation.add('paps',                   [43, 44],   0, false, isPlayer);
		animation.add('kb',                     [45, 46],   0, false, isPlayer);
		animation.add('zardyButDark',           [47, 48],   0, false, isPlayer);
		animation.add('BOCHEN',                 [64, 65],   0, false, isPlayer);
		animation.add('bf-bbpanzu',             [66, 67],   0, false, isPlayer);
		animation.add('bbdead',                 [67, 67],   0, false, isPlayer);
		animation.add('arch',                   [68, 69],   0, false, isPlayer);
		animation.add('aloe',                   [70, 71],   0, false, isPlayer);
		animation.add('nenechi',                [72, 73],   0, false, isPlayer);
		animation.add('sarvente',               [74, 75],   0, false, isPlayer);
		animation.add('ruv',                    [76, 77],   0, false, isPlayer);
		animation.add('sonic-exe',              [78, 79],   0, false, isPlayer);
		animation.add('sonic',                  [80, 81],   0, false, isPlayer);
		animation.add('nene',                   [82, 83],   0, false, isPlayer);
		animation.add('tord',                   [84, 85],   0, false, isPlayer);
		animation.add('tom',                    [86, 87],   0, false, isPlayer);
		animation.add('lexi',                   [88, 89],   0, false, isPlayer);
		animation.add('tabi',                   [90, 91],   0, false, isPlayer);
		animation.add('bf-ayana',               [92, 93],   0, false, isPlayer);
		animation.add('sunday',                 [94, 95],   0, false, isPlayer);
		animation.add('bf-sunday',              [94, 95],   0, false, isPlayer);
		animation.add('sky-happy',              [96, 97],   0, false, isPlayer);
		animation.add('sky-annoyed',            [96, 97],   0, false, isPlayer);
		animation.add('freddy',                 [98, 99],   0, false, isPlayer);
		animation.add('huggy',                  [100, 101], 0, false, isPlayer);
		animation.add('sadmouse',               [102, 103], 0, false, isPlayer);
		animation.add('happymouse',             [103, 138], 0, false, isPlayer);
		animation.add('bf-bw',                  [104, 105], 0, false, isPlayer);
		animation.add('gf-bf-bw',               [104, 105], 0, false, isPlayer);
		animation.add('sadminnie',              [106, 107], 0, false, isPlayer);
		animation.add('girlfriend-bw',          [108, 109], 0, false, isPlayer);
		animation.add('girlfriend-playable-bw', [108, 109], 0, false, isPlayer);
		animation.add('sky-annoyed-bw',         [110, 111], 0, false, isPlayer);
		animation.add('lexi-bw',                [112, 113], 0, false, isPlayer);
		animation.add('baldi-bw',               [114, 115], 0, false, isPlayer);
		animation.add('sonic-bw',               [116, 117], 0, false, isPlayer);
		animation.add('monika-real-bw',         [118, 119], 0, false, isPlayer);
		animation.add('sayori-bw',              [120, 121], 0, false, isPlayer);
		animation.add('tabi-bw',                [122, 123], 0, false, isPlayer);
		animation.add('agoti-bw',               [124, 125], 0, false, isPlayer);
		animation.add('bf-agoti-bw',            [124, 125], 0, false, isPlayer);
		animation.add('eteled1-bw',             [126, 127], 0, false, isPlayer);
		animation.add('annie-drunk-bw',         [128, 129], 0, false, isPlayer);
		animation.add('lexi-new',               [130, 131], 0, false, isPlayer);
		animation.add('aoki-new',               [132, 133], 0, false, isPlayer);
		animation.add('sadmouse-painted',       [134, 135], 0, false, isPlayer);
		animation.add('happymouse-painted',     [135, 136], 0, false, isPlayer);
		animation.add('happymouse2-painted',    [136, 137], 0, false, isPlayer);
		animation.add('happymouse3-painted',    [136, 136], 0, false, isPlayer);
		animation.add('happymouse2',            [138, 139], 0, false, isPlayer);
		animation.add('tord-r',                 [142, 143], 0, false, isPlayer);
		animation.add('edd-r',                  [146, 147], 0, false, isPlayer);
		animation.add('blantad',                [148, 149], 0, false, isPlayer);
		animation.add('lodger',                 [150, 151], 0, false, isPlayer);
		animation.add('oswald',                 [152, 153], 0, false, isPlayer);
		animation.add('oswald-happy',           [152, 153], 0, false, isPlayer);
		animation.add('eteled1',                [154, 155], 0, false, isPlayer);
		animation.add('monika-real',            [156, 157], 0, false, isPlayer);
		animation.add('sayori',                 [158, 159], 0, false, isPlayer);
		animation.add('agoti',                  [160, 161], 0, false, isPlayer);
		animation.add('bf-agoti',               [160, 161], 0, false, isPlayer);
		animation.add('hd-senpai-giddy',        [166, 166], 0, false, isPlayer);
		animation.add('jeff',                   [170, 171], 0, false, isPlayer);
		animation.add('bf-demoncesar',          [172, 173], 0, false, isPlayer);
		animation.add('taki',                   [174, 175], 0, false, isPlayer);
		animation.add('carol',                  [176, 177], 0, false, isPlayer);
		animation.add('whitty',                 [178, 179], 0, false, isPlayer);
		animation.add('majin',                  [180, 181], 0, false, isPlayer);

		// ENA's aliases:
		animation.add('ǝna',                  [40, 41],   0, false, isPlayer);
		animation.add('jena',                 [40, 41],   0, false, isPlayer);
		animation.add('ina',                  [40, 41],   0, false, isPlayer);
		animation.add('enna',                 [40, 41],   0, false, isPlayer);
		animation.add('ayna',                 [40, 41],   0, false, isPlayer);
		animation.add('chaina',               [40, 41],   0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
