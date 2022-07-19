@echo off
color 0a
title Haxe gaming
goto haxeupdate

:haxeupdate
haxelib remove faxe
haxelib git faxe https://github.com/uhrobots/faxe
pause