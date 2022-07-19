@echo off
color 0a
title Haxe gaming
goto haxeupdate

:haxeupdate
haxelib remove discord_rpc
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
pause