function start(song)
    showOnlyStrums = true;
    strumLine1Visible = false;
    strumLine2Visible = false;
end

function update(elapsed)

end

function beatHit(beat)
    if (beat == 64) then
        showOnlyStrums = false;
        strumLine1Visible = true;
        strumLine2Visible = true;
    end
end

function stepHit(step)

end