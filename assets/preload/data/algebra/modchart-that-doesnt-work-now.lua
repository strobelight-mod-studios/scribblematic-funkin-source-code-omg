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
	if curStep == 640 then
		changeDadCharacter('mom', 100, 100);
	end

	if curStep == 1664 then
		changeDadCharacter('dad', 100, 100);
	end

	if curStep == 2144 then
		changeDadCharacter('mom', 100, 100);
	end

	if curStep == 2208 then
		changeDadCharacter('blantad', 100, 100);
	end

	if curStep == 2784 then
		changeDadCharacter('kaskudek', 20, -70);
	end

	if curStep == 5376 then -- lags so I separated them :P
		changeDadCharacter('BOCHEN', 100, 400);
	end

	if curStep == 6784 then
		changeDadCharacter('ena', 100, 400)
	end

	if curStep == 7424 then
		changeDadCharacter('aloe', 100, 400)
	end

	if curStep == 7984 then
		changeDadCharacter('blantad', 100, 100)
	end
end