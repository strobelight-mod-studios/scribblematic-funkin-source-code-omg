@echo off
color 0a
title Haxe gaming
goto haxeupdate

:haxeupdate
haxelib remove hscript-ex
haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
pause