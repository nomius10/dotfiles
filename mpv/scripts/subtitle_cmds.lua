--- ___Usage___:
--- ab-loop-sub [autopause]: Set ab-loop to current subtitle. Specify 'autopause' arg to pause before every loop

_G.abloopavoidjankpause = false

--- platform detection taken from: github.com/rossy/mpv-repl/blob/master/repl.lua
function detect_platform()
    local o = {}
    if mp.get_property_native('options/vo-mmcss-profile', o) ~= o then
        return 'windows'
    elseif mp.get_property_native('options/cocoa-force-dedicated-gpu', o) ~= o then
        return 'macos'
    end
    return 'linux'
end

_G.platform = detect_platform()
if _G.platform == 'windows' then
    _G.utils = require 'mp.utils'
end
--- end platform detection code

function round(num, numdecimalplaces)
  local mult = 10^(numdecimalplaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function pause_on_sub_loop(prop, value)
    if _G.abloopavoidjankpause == true then
        _G.abloopavoidjankpause = false
        return
    end
    if value and value ~= '' then
        local startloop = round(mp.get_property("ab-loop-a"), 1)
        local substart = round(mp.get_property("sub-start") + mp.get_property("sub-delay"), 1)
        if substart and startloop and substart == startloop then
            mp.set_property("pause", "yes")
        end
    end
end

function ab_loop_sub(autopause)
    local existingloop = mp.get_property_number("ab-loop-b")
    if existingloop then
        mp.osd_message("Clear A-B Loop", 0.5)

        mp.set_property("ab-loop-a", "no")
        mp.set_property("ab-loop-b", "no")
        
        mp.unobserve_property(pause_on_sub_loop)
        mp.set_property("pause", "no")
    else        
        local substart = mp.get_property("sub-start")
        local subend = mp.get_property("sub-end")    

        if substart and subend then
            mp.osd_message("A-B Loop Subtitle", 0.5)

            local suboffset = mp.get_property("sub-delay")
            mp.set_property_number("ab-loop-a", substart  + suboffset)
            mp.set_property_number("ab-loop-b", subend + suboffset + 0.075)
            
            _G.abloopavoidjankpause = true
            if autopause then mp.observe_property("sub-text", "native", pause_on_sub_loop) end
        else
            mp.osd_message("No subtitles present", 0.5)
        end
    end
    
end

mp.add_key_binding(nil, "ab-loop-sub", ab_loop_sub)