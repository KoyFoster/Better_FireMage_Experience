local UnitAuraEventHandlerFrame = CreateFrame("frame") --private

local validChannels = {
    ["Master"] = "Master",
    ["Music"] = "Music",
    ["SFX"] = "SFX",
    ["Ambience"] = "Ambience",
    ["Dialog"] = "Dialog",
}

local rootPath = "Interface\\AddOns\\Better_FireMage_Experience"
local function getFullPath(path)
    return string.format("%s\\%s", rootPath, path)
end

local defaultAudioChannel = "SFX"
-- message("-PlayCues Loaded-")

local heatingUp = false;
local hotStreak = false;
local curHeatingUp = false;
local curHotStreak = false;

local function heatCallback(name, icon, _, _, duration, expirationTime, _, _, _, spellId, _, _, _, _, _, _, _, _, _,
                            timeMod, ...)
    -- Heating Up
    if spellId == 48107 then
        -- do stuff
        curHeatingUp = true;
        -- print(string.format("KAC: Heating Up!: %f", expirationTime - GetTime()))
        -- return true
        -- Hot streak
    elseif spellId == 48108 then
        -- do stuff
        curHotStreak = true;
        -- print(string.format("KAC: Hot Streak !: %f", expirationTime - GetTime()))
        -- return true
    elseif curHeatingUp and curHotStreak then
        -- print("KAC: Searching...");
        return true;
    else
        return false
    end
end

local function OnEvent(self, event, ...)
    -- print("KAC: ...");
    if event == "UNIT_AURA" then
        curHeatingUp = false;
        curHotStreak = false;
        AuraUtil.ForEachAura("player", "HELPFUL", nil, heatCallback);

        -- Heating Up Trigger
        if curHeatingUp and not (heatingUp) then
            local willPlay = PlaySoundFile(getFullPath("sound\\c3_grab.ogg"), defaultAudioChannel);
            if willPlay then
                print("Started heating up!")
            end
            -- PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_2, defaultAudioChannel);
            -- PlaySoundFile("Interface\\AddOns\\KoysAudioCues\\sound\\c3_mus_sfx_a_grab.ogg", defaultAudioChannel);
        elseif not (curHeatingUp) and heatingUp then
            if not (curHotStreak) then
                local willPlay = PlaySoundFile(getFullPath("sound\\b2_grab.ogg"), defaultAudioChannel);
                if willPlay then
                    print("You cooled off!")
                end
                -- PlaySound(SOUNDKIT.PUT_DOWN_GEMS, defaultAudioChannel);
                -- PlaySoundFile(rootPath + "sound\\b2_grab.ogg", defaultAudioChannel);
            end
        end

        if curHotStreak and not (hotStreak) then
            local willPlay = PlaySoundFile(getFullPath("sound\\c4_grab.ogg"), defaultAudioChannel);
            if willPlay then
                print("Started hot streak!")
            end
            -- PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, defaultAudioChannel);
            -- PlaySoundFile(rootPath + "sound\\c4_grab.ogg", defaultAudioChannel);
        elseif not (curHotStreak) and hotStreak then
            local willPlay = PlaySoundFile(getFullPath("sound\\b3_grab.ogg"), defaultAudioChannel);
            if willPlay then
                print("Hot streak ended!")
            end
            -- PlaySound(SOUNDKIT.UI_73_ARTIFACT_OVERLOADED_ORB_HIGHEST, defaultAudioChannel);
            -- PlaySoundFile(rootPath + "sound\\b3_grab.ogg", defaultAudioChannel);
        end

        -- update buffered state
        heatingUp = curHeatingUp;
        hotStreak = curHotStreak;
    end
end

UnitAuraEventHandlerFrame:RegisterEvent("UNIT_AURA")
UnitAuraEventHandlerFrame:SetScript("OnEvent", OnEvent)
