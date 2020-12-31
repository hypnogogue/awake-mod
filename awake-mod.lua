-- awake-mod
-- 1.0.4 @shoggoth
-- llllllll.co/t/awake-mod
-- based off 
-- 2.4.0 awake by @tehn
--
-- top loop plays notes
-- transposed by bottom loop
--
-- (grid optional)
--
-- E1 changes modes:
-- STEP/LOOP/SOUND
-- OPTION/MOD
-- XPLSN/FNDTN
--
-- K1 held is alt *
--
-- STEP
-- E2/E3 move/change
-- K2 toggle *clear
-- K3 morph *rand
--
-- LOOP
-- E2/E3 loop length
-- K2 reset position
-- K3 jump position
--
-- SOUND
-- K2/K3 selects
-- E2/E3 changes
--
-- OPTION
-- *toggle
-- E2/E3 changes
--
-- MOD
-- K2 incr trig *clear all mod
-- K3 decr trig mod *rand mod
-- E2 select step
-- E3 mod value
--
-- XPLSN
-- K2 set fuse
-- K3 set type
--
-- FNDTN
-- K2 set foundation
-- K3 reset to foundation


engine.name = 'PolyPerc'

hs = include('lib/halfsecond')

MusicUtil = require "musicutil"

options = {}
options.OUTPUT = {"audio", "midi", "audio + midi", "crow out 1+2", "crow ii JF"}

g = grid.connect()

alt = false

mode = 1
mode_names = {"STEP","LOOP","SOUND","OPTION","MOD","XPLSN","FNDTN"}

xplsn_types = {"morph1","morph2","stp-rnd","mod-rnd","fndtn"}
xplsn_type = 1
display_explosion = false

one = {
  pos = 0,
  length = 8,
  data = {1,0,3,5,6,7,8,7,0,0,0,0,0,0,0,0}
}

two = {
  pos = 0,
  length = 7,
  data = {5,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
}

three = {
  note_mod = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  note_mod_trig = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  note_mod_trig_count = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
}

function clear_note_mod()
  three = {
    note_mod = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    note_mod_trig = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    note_mod_trig_count = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  }
  for i=1,16 do
    params:set("note_mod_"..i, 0)
    params:set("mod_trig_"..i, 0)
  end
end

function set_random_note_mod()
  for i=1,16 do
    r1 = math.random(-7,9)
    params:set("note_mod_"..i, r1)
    three.note_mod[i] = r1
    --coin flip if mod is active, if active choose a division of 2 or higher
    if math.random(0,1) == 1 then
      r2 = math.random(2,8)
    else
      r2 = 0
    end
    params:set("mod_trig_"..i, r2)
    three.note_mod_trig[i] = r2
  end
end

function add_pattern_params() 
  params:add_separator()
  params:add_group("pattern 1",17)
  
  params:add{type = "number", id = "one_length", name = "length", min=1, max=16, 
    default = one.length,
    action=function(x) one.length = x end }

  for i=1,16 do
    params:add{type = "number", id= ("one_data_"..i), name = ("data "..i), min=0, max=8, 
      default = one.data[i],
      action=function(x)one.data[i] = x end }
  end

  params:add_group("pattern 2",17)
  
  params:add{type = "number", id = "two_length", name = "length",  min=1, max=16, 
    default = two.length,
    action=function(x)two.length = x end}
  
  for i=1,16 do
    params:add{type = "number", id= "two_data_"..i, name = "data "..i,  min=0, max=8, 
      default = two.data[i],
      action=function(x) two.data[i] = x end }
  end
  
  params:add_group("pattern 1 mod",32)
  for i=1,16 do
    params:add{type = "number", id= ("note_mod_"..i), name = ("note mod "..i), min=-7, max=9, 
      default = 0,
      action=function(x)three.note_mod[i] = x end }
    params:add{type = "number", id= ("mod_trig_"..i), name = ("mod trig "..i), min=0, max=8,
      default = 0,
      action=function(x)three.note_mod_trig[i] = x end }
  end
  
  
end

set_loop_data = function(which, step, val)
  params:set(which.."_data_"..step, val)
end

function set_foundation()
  foundation_one = {
    pos = 0,
    length = one.length,
    data = {}
  }
  foundation_two = {
    pos = 0,
    length = two.length,
    data = {}
  }
  foundation_three = {
    note_mod = {},
    note_mod_trig={},
    note_mod_trig_count={}
  }
  for i=1,16 do
    foundation_one.data[i]=one.data[i]
    foundation_two.data[i]=two.data[i]
    foundation_three.note_mod[i]=three.note_mod[i]
    foundation_three.note_mod_trig[i]=three.note_mod_trig[i]
  end
  
  foundation_set = true
end


function reset_to_foundation()
  reset_foundation = false
  if foundation_set==false then return end
  --start_foundation_animation = true
  --fndtn_frame=10
  one.pos = 0
  one.length = foundation_one.length
  two.pos = 0
  two.length = foundation_two.length
  three.note_mod_trig_count = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  for i=1,16 do
    one.data[i]=foundation_one.data[i]
    two.data[i]=foundation_two.data[i]
    three.note_mod[i]=foundation_three.note_mod[i]
    three.note_mod_trig[i]=foundation_three.note_mod_trig[i]
  end
    for i=1,16 do
    params:set("one_length",one.length)
    params:set("two_length",two.length)
    params:set("one_data_"..i,one.data[i])
    params:set("two_data_"..i,two.data[i])
    params:set("note_mod_"..i,three.note_mod[i])
    params:set("mod_trig_"..i,three.note_mod_trig[i])
  end
end

local midi_out_device
local midi_out_channel

local scale_names = {}
local notes = {}
local active_notes = {}

local edit_ch = 1
local edit_pos = 1

snd_sel = 1
snd_names = {"cut","gain","pw","rel","fb","rate", "pan", "delay_pan"}
snd_params = {"cutoff","gain","pw","release", "delay_feedback","delay_rate", "pan", "delay_pan"}
NUM_SND_PARAMS = #snd_params

notes_off_metro = metro.init()

function build_scale()
  notes = MusicUtil.generate_scale_of_length(params:get("root_note"), params:get("scale_mode"), 16)
  local num_to_add = 16 - #notes
  for i = 1, num_to_add do
    table.insert(notes, notes[16 - num_to_add])
  end
end

function all_notes_off()
  if (params:get("output") == 2 or params:get("output") == 3) then
    for _, a in pairs(active_notes) do
      midi_out_device:note_off(a, nil, midi_out_channel)
    end
  end
  active_notes = {}
end

function morph(loop, which)
  for i=1,loop.length do
    if loop.data[i] > 0 then
      set_loop_data(which, i, util.clamp(loop.data[i]+math.floor(math.random()*3)-1,1,8))
    end
  end
end

function explosion()
  if xplsn_type == 1 then
    morph(one,"one")
  elseif xplsn_type == 2 then
    morph(two,"two")
  elseif xplsn_type == 3 then
    random()
  elseif xplsn_type == 4 then
    set_random_note_mod()
  elseif xplsn_type == 5 then
    reset_foundation = true
  end
  if fuse_repeat==false then
    fuse_lit=false
  end
  display_explosion=true
end

function random()
  for i=1,one.length do set_loop_data("one", i, math.floor(math.random()*9)) end
  for i=1,two.length do set_loop_data("two", i, math.floor(math.random()*9)) end
end

function step()
  while true do
    clock.sync(1/params:get("step_div"))

    all_notes_off()
    if reset_foundation == true then reset_to_foundation() end


    one.pos = one.pos + 1
    if one.pos > one.length then 
      one.pos = 1 
      if fuse_repeat then
        explosion()
      elseif fuse_lit then 
        params:delta("fuse",-1) 
        if fuse == 0 then explosion() end
      end
    end
    two.pos = two.pos + 1
    if two.pos > two.length then two.pos = 1 end
    
    three.note_mod_trig_count[one.pos] = three.note_mod_trig_count[one.pos] + 1
    if three.note_mod_trig_count[one.pos] > three.note_mod_trig[one.pos] then three.note_mod_trig_count[one.pos] = 1 end
    
    
    mod_play = 0
    note_mod=0
    --if there is no step but mod would trigger a note this step
    if three.note_mod[one.pos] ~= 0 and three.note_mod_trig_count[one.pos] == three.note_mod_trig[one.pos] then
      mod_play = 1
      note_mod=three.note_mod[one.pos]
    end
    mod_mute=0
    if three.note_mod[one.pos] ==9 and three.note_mod_trig_count[one.pos] == three.note_mod_trig[one.pos] then
      mod_mute=1
    end
    

      

    if (one.data[one.pos] > 0 or mod_play==1) and mod_mute==0 then
      note_sum=one.data[one.pos]+two.data[two.pos]+note_mod
      if note_sum > 16 then
        note_sum = note_sum - 16 --mods exceeds scale, wraparound note
      elseif note_sum <= 0 then
        note_sum = note_sum + 16 --mods under scale threshold, wraparound note
      end
      local note_num = notes[note_sum]
      local freq = MusicUtil.note_num_to_freq(note_num)
      -- Trig Probablility
      if math.random(100) <= params:get("probability") then
        -- Audio engine out
        if params:get("output") == 1 or params:get("output") == 3 then
          engine.hz(freq)
        elseif params:get("output") == 4 then
          crow.output[1].volts = (note_num-60)/12
          crow.output[2].execute()
        elseif params:get("output") == 5 then
          crow.ii.jf.play_note((note_num-60)/12,5)
        end

        -- MIDI out
        if (params:get("output") == 2 or params:get("output") == 3) then
          midi_out_device:note_on(note_num, 96, midi_out_channel)
          table.insert(active_notes, note_num)

          --local note_off_time = 
          -- Note off timeout
          if params:get("note_length") < 4 then
            notes_off_metro:start((60 / params:get("clock_tempo") / params:get("step_div")) * params:get("note_length"), 1)
          end
        end
      end
    end

    if g then
      gridredraw()
    end
    redraw()
  end
end

function stop()
  all_notes_off()
end


function init()
  for i = 1, #MusicUtil.SCALES do
    table.insert(scale_names, string.lower(MusicUtil.SCALES[i].name))
  end
  
  midi_out_device = midi.connect(1)
  midi_out_device.event = function() end
  
  notes_off_metro.event = all_notes_off
  
  params:add{type = "option", id = "output", name = "output",
    options = options.OUTPUT,
    action = function(value)
      all_notes_off()
      if value == 4 then crow.output[2].action = "{to(5,0),to(0,0.25)}"
      elseif value == 5 then
        crow.ii.pullup(true)
        crow.ii.jf.mode(1)
      end
    end}
  params:add{type = "number", id = "midi_out_device", name = "midi out device",
    min = 1, max = 4, default = 1,
    
    action = function(value) midi_out_device = midi.connect(value) end}
  params:add{type = "number", id = "midi_out_channel", name = "midi out channel",
    min = 1, max = 16, default = 1,
    action = function(value)
      all_notes_off()
      midi_out_channel = value
    end}
  params:add_separator()
  
  params:add{type = "number", id = "step_div", name = "step division", min = 1, max = 16, default = 4}

  params:add{type = "option", id = "note_length", name = "note length",
    options = {"25%", "50%", "75%", "100%"},
    default = 4}
  
  params:add{type = "option", id = "scale_mode", name = "scale mode",
    options = scale_names, default = 5,
    action = function() build_scale() end}
  params:add{type = "number", id = "root_note", name = "root note",
    min = 0, max = 127, default = 60, formatter = function(param) return MusicUtil.note_num_to_name(param:get(), true) end,
    action = function() build_scale() end}
  params:add{type = "number", id = "probability", name = "probability",
    min = 0, max = 100, default = 100,}
  params:add_separator()

  cs_AMP = controlspec.new(0,1,'lin',0,0.5,'')
  params:add{type="control",id="amp",controlspec=cs_AMP,
    action=function(x) engine.amp(x) end}

  cs_PW = controlspec.new(0,100,'lin',0,50,'%')
  params:add{type="control",id="pw",controlspec=cs_PW,
    action=function(x) engine.pw(x/100) end}

  cs_REL = controlspec.new(0.1,3.2,'lin',0,1.2,'s')
  params:add{type="control",id="release",controlspec=cs_REL,
    action=function(x) engine.release(x) end}

  cs_CUT = controlspec.new(50,5000,'exp',0,800,'hz')
  params:add{type="control",id="cutoff",controlspec=cs_CUT,
    action=function(x) engine.cutoff(x) end}

  cs_GAIN = controlspec.new(0,4,'lin',0,1,'')
  params:add{type="control",id="gain",controlspec=cs_GAIN,
    action=function(x) engine.gain(x) end}
  
  cs_PAN = controlspec.new(-1,1, 'lin',0,0,'')
  params:add{type="control",id="pan",controlspec=cs_PAN,
    action=function(x) engine.pan(x) end}
  
  foundation_set = false

  hs.init()
  
  add_pattern_params()
  params:add_separator()
  params:add{type = "number", id= "fuse", name = "fuse", min=0, max=17, 
      default = 0,
      action=function(x) fuse = x end }
  
  
  params:default()
  set_foundation()

  clock.run(step)

  norns.enc.sens(1,8)
end

function g.key(x, y, z)
  local grid_h = g.rows
  if z > 0 then
    if (grid_h == 8 and edit_ch == 1) or (grid_h == 16 and y <= 8) then
      if one.data[x] == 9-y then
        set_loop_data("one", x, 0)
      else
        set_loop_data("one", x, 9-y)
      end
    end
    if (grid_h == 8 and edit_ch == 2) or (grid_h == 16 and y > 8) then
      if grid_h == 16 then y = y - 8 end
      if two.data[x] == 9-y then
        set_loop_data("two", x, 0)
      else
        set_loop_data("two", x, 9-y)
      end
    end
    gridredraw()
    redraw()
  end
end

function gridredraw()
  local grid_h = g.rows
  g:all(0)
  if edit_ch == 1 or grid_h == 16 then
    for x = 1, 16 do
      if one.data[x] > 0 then g:led(x, 9-one.data[x], 5) end
    end
    if one.pos > 0 and one.data[one.pos] > 0 then
      g:led(one.pos, 9-one.data[one.pos], 15)
    else
      g:led(one.pos, 1, 3)
    end
  end
  if edit_ch == 2 or grid_h == 16 then
    local y_offset = 0
    if grid_h == 16 then y_offset = 8 end
    for x = 1, 16 do
      if two.data[x] > 0 then g:led(x, 9-two.data[x] + y_offset, 5) end
    end
    if two.pos > 0 and two.data[two.pos] > 0 then
      g:led(two.pos, 9-two.data[two.pos] + y_offset, 15)
    else
      g:led(two.pos, 1 + y_offset, 3)
    end
  end
  g:refresh()
end

function enc(n, delta)
  if n==1 then
    mode = util.clamp(mode+delta,1,7)
    if mode == 5 then 
      local p = one.length
      edit_pos = util.clamp(edit_pos+delta,1,p) 
    end
  elseif mode == 1 then --step
    if n==2 then
      if alt then
        params:delta("probability", delta)
      else
        local p = (edit_ch == 1) and one.length or two.length
        edit_pos = util.clamp(edit_pos+delta,1,p)
      end
    elseif n==3 then
      if edit_ch == 1 then
        params:delta("one_data_"..edit_pos, delta)
      else
        params:delta("two_data_"..edit_pos, delta)
      end
    end
  elseif mode == 2 then --loop
    if n==2 then
      params:delta("one_length", delta)
    elseif n==3 then
      params:delta("two_length", delta)
    end
  elseif mode == 3 then --sound
    if n==2 then
      params:delta(snd_params[snd_sel], delta)
    elseif n==3 then
      params:delta(snd_params[snd_sel+1], delta)
    end
  elseif mode == 4 then --option
    if n==2 then
      if alt==false then
        params:delta("clock_tempo", delta)
      else
        params:delta("step_div",delta)
      end
    elseif n==3 then
      if alt==false then
        params:delta("root_note", delta)
      else
        params:delta("scale_mode", delta)
      end
    end
  elseif mode == 5 then --mod
    if n==2 then
      --delta 1 or 2 when moved to the right, -1 or -2 when moved to the left
      local p = one.length
      edit_pos = util.clamp(edit_pos+delta,1,p)
    elseif n==3 then
      params:delta("note_mod_"..edit_pos, delta)
    end
  elseif mode == 6 then --xplsn
    if fuse==0 then fuse_lit=false end
      if n==2 then
        params:delta("fuse", delta)
      elseif n==3 then
        xplsn_type=util.clamp(xplsn_type+delta,1,5)
      end
    if fuse_lit == false and fuse > 0 then
      fuse_lit=true 
    elseif fuse_lit == true and fuse == 0 then
      fuse_lit=false
    end
    if fuse == 17 then 
      fuse_repeat = true
    else
      fuse_repeat = false
    end
  end
  redraw()
end

function key(n,z)
  if n==1 then
    alt = z==1

  elseif mode == 1 then --step
    if n==2 and z==1 then
      if not alt==true then
        -- toggle edit
        if edit_ch == 1 then
          edit_ch = 2
          if edit_pos > two.length then edit_pos = two.length end
        else
          edit_ch = 1
          if edit_pos > one.length then edit_pos = one.length end
        end
      else
        -- clear
        for i=1,one.length do params:set("one_data_"..i, 0) end
        for i=1,two.length do params:set("two_data_"..i, 0) end

      end
    elseif n==3 and z==1 then
      if not alt==true then
        -- morph
        if edit_ch == 1 then morph(one, "one") else morph(two, "two") end
      else
        -- random
        random()
        gridredraw()
      end
    end
  elseif mode == 2 then --loop
    if n==2 and z==1 then
      one.pos = 0
      two.pos = 0
    elseif n==3 and z==1 then
      one.pos = math.floor(math.random()*one.length)
      two.pos = math.floor(math.random()*two.length)
    end
  elseif mode == 3 then --sound
    if n==2 and z==1 then
      snd_sel = util.clamp(snd_sel - 2,1,NUM_SND_PARAMS-1)
    elseif n==3 and z==1 then
      snd_sel = util.clamp(snd_sel + 2,1,NUM_SND_PARAMS-1)
    end
  elseif mode == 4 then --option
    if n==2 then
    elseif n==3 then
    end
  elseif mode == 5 then --mod
    if not alt==true then
      if n==2 and z==1 then
        --z is 1 when pressed, 0 when let go
        params:delta("mod_trig_"..edit_pos, -1)
      elseif n==3 and z==1 then
        params:delta("mod_trig_"..edit_pos, 1)
      end
    else
      if n==2 and z==1 then
        clear_note_mod()
      elseif n==3 and z==1 then
        set_random_note_mod()
      end
    end
  elseif mode == 7 then --fndtn
    if n==2 and z==1 then
      set_foundation()
    elseif n==3 and z==1 then
      reset_foundation = true
    end
  end

  redraw()
end

function redraw()
  screen.clear()
  screen.line_width(1)
  screen.aa(0)
  if display_explosion==true then
      for i=1,7 do
        x=math.random(0,128)
        y=math.random(0,64)
        r=math.random(5,25)
        screen.move(x+r,y)
        screen.circle(x,y,r)
        screen.level(1)
      end
      display_explosion = false
      screen.stroke()
  end
  -- edit point
  if mode==1 then
    screen.move(26 + edit_pos*6, edit_ch==1 and 33 or 63)
    screen.line_rel(4,0)
    screen.level(15)
    if alt then
      screen.move(0, 30)
      screen.level(1)
      screen.text("prob")
      screen.move(0, 45)
      screen.level(15)
      screen.text(params:get("probability"))
    end
    screen.stroke()
  end  
  if mode==5 then
    screen.move(26 + edit_pos*6, 33)
    screen.line_rel(4,0)
    screen.level(15)
    screen.stroke()
  end

  -- loop lengths
  screen.move(32,30)
  screen.line_rel(one.length*6-2,0)
  screen.move(32,60)
  screen.line_rel(two.length*6-2,0)
  screen.level(mode==2 and 6 or 1)
  screen.stroke()
  -- steps
  for i=1,one.length do
    screen.move(26 + i*6, 30 - one.data[i]*3)
    screen.line_rel(4,0)
    screen.level(i == one.pos and 15 or ((edit_ch == 1 and one.data[i] > 0) and 4 or (mode==2 and 6 or 1)))
    screen.stroke()
  end
  for i=1,two.length do
    screen.move(26 + i*6, 60 - two.data[i]*3)
    screen.line_rel(4,0)
    screen.level(i == two.pos and 15 or ((edit_ch == 2 and two.data[i] > 0) and 4 or (mode==2 and 6 or 1)))
    screen.stroke()
  end
  --mod
    for i=1,one.length do
    mod_active = 0
    if three.note_mod[i] ~= 0 and three.note_mod_trig[i] > 0 then
      screen.move(26 + i*6, 31)
      screen.line_rel(4,0)
    end
    screen.level((i == one.pos and mod_play == 1) and 15 or  (mode==2 and 6 or 1))
    if i == one.pos and mod_play == 1 then
      screen.move(26 + i*6, 28 - one.data[i]*3)
      screen.text(".")
    end
    screen.stroke()
  end

  screen.level(4)
  screen.move(0,10)
  screen.text(mode_names[mode])

  if mode==3 then
    screen.level(1)
    screen.move(0,30)
    screen.text(snd_names[snd_sel])
    screen.level(15)
    screen.move(0,40)
    screen.text(params:string(snd_params[snd_sel]))
    screen.level(1)
    screen.move(0,50)
    screen.text(snd_names[snd_sel+1])
    screen.level(15)
    screen.move(0,60)
    screen.text(params:string(snd_params[snd_sel+1]))
  elseif mode==4 then
    screen.level(1)
    screen.move(0,30)
    screen.text(alt==false and "bpm" or "div")
    screen.level(15)
    screen.move(0,40)
    screen.text(alt==false and params:get("clock_tempo") or params:string("step_div")) 
    screen.level(1)
    screen.move(0,50)
    screen.text(alt==false and "root" or "scale")
    screen.level(15)
    screen.move(0,60)
    screen.text(alt==false and params:string("root_note") or params:string("scale_mode"))
  elseif mode==5 then
    screen.level(1)
    screen.move(0,30)
    screen.text("mod")
    if three.note_mod[edit_pos]==9 then
      mod_display = "mute"
      mod_screen_level = 15
    elseif three.note_mod[edit_pos]==0 then
      mod_display = "off"
      mod_screen_level = 2
    else
      mod_display = three.note_mod[edit_pos]
      mod_screen_level = 15
    end
    screen.level(mod_screen_level)
    screen.move(0,40)
    screen.text(mod_display) 
    screen.level(1)
    screen.move(0,50)
    screen.text("trig")
    if three.note_mod_trig[edit_pos] == 0 then
      trig_display = "off"
    else
      trig_display = "/"..three.note_mod_trig[edit_pos]
    end
    if mod_display=="off" or trig_display == "off" then
      trig_screen_level = 2
    else
      trig_screen_level = 15
    end
    screen.level(trig_screen_level)
    screen.move(0,60)
    screen.text(trig_display)
  elseif mode==6 then
    screen.level(1)
    screen.move(0,30)
    screen.text("fuse")
    if fuse ==17 then
      fuse_display = "rpt"
      fuse_screen_level = 15
    elseif fuse==0 then
      fuse_display = "off"
      fuse_screen_level = 2
    else
      fuse_display = fuse
      fuse_screen_level = 15
    end
    screen.level(fuse_screen_level)
    screen.move(0,40)
    screen.text(fuse_display) 
    screen.move(0,50)
    screen.level(1)
    screen.text("type")
    screen.move(0,60)
    screen.level(15)
    screen.text(xplsn_types[xplsn_type])
  elseif mode==7 then --fndtn
    screen.level(1)
    screen.move(0,30)
    screen.line(foundation_one.length,30)
    for i=1,foundation_one.length do
      if foundation_one.data[i] > 0 then
        screen.move(i-1,30 - foundation_one.data[i])
        screen.line_rel(1,0)
      end
      if foundation_three.note_mod[i] ~= 0 and foundation_three.note_mod_trig[i] > 0 then
        screen.move(0 + i, 31)
        screen.line_rel(1,0)
      end
    end
    screen.move(0,60)
    screen.line(foundation_two.length,60)
    for i=1,foundation_two.length do
      if foundation_two.data[i] > 0 then
        screen.move(i-1,60 - foundation_two.data[i])
        screen.line_rel(1,0)
      end
    end
    

    
  end
  screen.update()
end

function cleanup ()
end
