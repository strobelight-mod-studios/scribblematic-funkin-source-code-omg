@echo off
color 0a
cd ..
@echo on
echo BUILDING GAME
lime test windows -release
echo UPLOADING 64 BIT VERSION TO ITCH
butler push ./export/release/windows/bin ninja-muffin24/funkin:windows-64bit
lime test windows -release -32
echo UPLOADING 32 BIT VERSION TO ITCH
butler push ./export/release/windows/bin ninja-muffin24/funkin:windows-32bit
butler status ninja-muffin24/funkin:windows-32bit
butler status ninja-muffin24/funkin:windows-64bit
echo ITCH SHIT UPDATED LMAOOOOO
pause