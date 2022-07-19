@echo off
color 0a
title Haxe gaming
goto haxeupdate

:haxeupdate
haxelib remove hxCodec
haxelib install hxCodec
pause