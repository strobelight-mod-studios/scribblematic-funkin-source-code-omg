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

function stepHit (step)
	if curStep == 104 then
		playActorAnimation('dad', 'lucky', true, false)
	end
	
	if curStep == 376 or curStep == 512 then
        addCamZoom(0.3)
    end

	if curStep == 545 then
        playActorAnimation('dad', 'oldtimey', true, false)
    end

	if curStep == 546 then
        playActorAnimation('gf', 'spooked', true, false)
    end

	if curStep == 560 then
        playActorAnimation('gf', 'danceLeft', true, false)
    end

	if curStep == 672 then
        playActorAnimation('dad', 'notold', true, false)
        addCamZoom(0.05);
    end
	
	if curStep == 676 then
        addCamZoom(0.1);
    end

    if curStep == 680 then
        addCamZoom(0.15);
    end

    if curStep == 684 then
        addCamZoom(0.01);
        shakeCam(0.05, 0.5)
    end

    if curStep == 688 then
        addCamZoom(0.015)
    end

    if curStep == 831 then
        playActorAnimation('dad', 'hah', true, false)
    end
end