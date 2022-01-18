-- I wanted it to work, but it looks like despite my character positioning it doesn't want to work.
function start(song) -- arguments, the song name
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

-- this gets called every frame
function update(elapsed) -- arguments, how long it took to complete a frame
	local currentBeat = (songPos / 1000)*(bpm/60)
end

-- this gets called every beat
function beatHit(beat) -- arguments, the current beat of the song

end

-- this gets called every step
function stepHit(step) -- arguments, the current step of the song (4 steps are in a beat)
	if curStep == 192 then
		changeDadCharacter('mom', 100, 100);
	end

	if curStep == 224 then
		changeBoyfriendCharacter('dad', 770, 150);
	end

	if curStep == 256 then
		changeDadCharacter('nenechi', 0, 400);
	end

	if curStep == 288 then
		changeBoyfriendCharacter('aloe', 770, 450);
	end

	if curStep == 320 then
		changeDadCharacter('sarvente', 100, 100);
	end

	if curStep == 352 then
		changeBoyfriendCharacter('ruv', 770, 50);
	end

	if curStep == 384 then -- lags so I separated them :P
		changeDadCharacter('sonic-exe', 200, 250);
		changeBoyfriendCharacter('sonic', 770, 450);
	end

	if curStep == 448 then
		changeDadCharacter('nene', 0, 450)
		changeBoyfriendCharacter('bf-pico', 770, 450);
	end

	if curStep == 512 then
		changeDadCharacter('tord', 100, 100)
		changeBoyfriendCharacter('tom', 770, 100);
	end

	if curStep == 576 then
		changeDadCharacter('blantad', 100, 100)
		changeBoyfriendCharacter('lexi', 770, 450);
	end

	if curStep == 640 then
		changeDadCharacter('tabi', 100, 100);
	end

	if curStep == 672 then
		changeBoyfriendCharacter('bf-ayana', 770, 50);
	end

	if curStep == 704 then
		changeDadCharacter('sunday', 100, 400);
	end

	if curStep == 736 then
		changeBoyfriendCharacter('sky-happy', 770, 250);
	end

	if curStep == 768 then
		changeDadCharacter('freddy', 100, 100);
		changeBoyfriendCharacter('huggy', 770, 300);
	end
end