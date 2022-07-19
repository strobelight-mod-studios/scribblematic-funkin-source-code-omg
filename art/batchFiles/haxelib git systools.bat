@echo off
color 0a
title GameJolt FNF Integration libraries
goto installit

:installit
haxelib remove systools
haxelib git systools https://github.com/haya3218/systools
haxelib run lime rebuild systools windows
pause