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
	if curStep == 128 then
		changeDadCharacter('sadminnie', 100, 100);
	end

	if curStep == 192 then
		changeGFCharacter('gf-bf-bw', 400, 130);
		changeDadCharacter('sadminnie', 100, 100);
		changeBoyfriendCharacter('girlfriend-playable-bw', 770, 150);
	end

	if curStep == 256 then
		changeGFCharacter('gf-and-bf-bw', 400, 130);
		changeDadCharacter('sky-annoyed-bw', 100, 100);
		changeBoyfriendCharacter('lexi-bw', 770, 150);
	end

	if curStep == 320 then
		changeDadCharacter('baldi-bw', 100, 100);
		changeBoyfriendCharacter('sonic-bw', 770, 450);
	end

	if curStep == 384 then
		changeDadCharacter('monika-real-bw', 100, 100);
	end

	if curStep == 400 then
		changeBoyfriendCharacter('sayori-bw', 770, 200);
	end

	if curStep == 416 then -- lags so I separated them :P
		changeDadCharacter('tabi-bw', 100, 100);
	end

	if curStep == 424 then
		changeDadCharacter('bf-agoti-bw', 770, 100)
	end

	if curStep == 432 then
		changeDadCharacter('eteled1-bw', 205, 205)
		changeBoyfriendCharacter('annie-drunk-bw', 770, 175);
	end
end