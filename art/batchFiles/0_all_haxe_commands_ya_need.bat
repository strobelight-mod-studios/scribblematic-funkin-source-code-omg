@echo off
color 0a
title Haxe gaming
goto haxeupdate

:haxeupdate
haxelib install lime 7.9.0
haxelib install openfl
haxelib install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install flixel-addons
haxelib install tjson
haxelib install hxjsonast
haxelib git linc_luajit https://github.com/AndreiRudenko/linc_luajit
haxelib install hscript 
haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib install hxcpp-debug-server
haxelib git faxe https://github.com/uhrobots/faxe
haxelib install newgrounds
haxelib install actuate
haxelib git extension-webm https://github.com/KadeDev/extension-webm
lime rebuild extension-webm windows
haxelib git tentools https://github.com/TentaRJ/tentools.git
haxelib git systools https://github.com/haya3218/systools
haxelib run lime rebuild systools windows
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git
haxelib list
pause