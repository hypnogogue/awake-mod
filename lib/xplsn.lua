xplsn_types = {"morph1","morph2","stp-rnd","mod-rnd","fndtn1","fndtn2","fndtn3","fndtn4","mirror","oct-up","oct-dwn","fractal"}
xplsn_max = #xplsn_types
xplsn_type = 1
display_explosion = false

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
    reset_to_foundation(1)
  elseif xplsn_type == 6 then
    reset_to_foundation(2)
  elseif xplsn_type == 7 then
    reset_to_foundation(3)
  elseif xplsn_type == 8 then
    reset_to_foundation(4)
  elseif xplsn_type == 9 then
    mirror_sequence()
  elseif xplsn_type == 10 then
    change_octave("up")
  elseif xplsn_type == 11 then
    change_octave("down")
  elseif xplsn_type == 12 then
    fractal()
  end
  if fuse_repeat==false then
    fuse_lit=false
  end
  display_explosion=true
end

function draw_explosion()
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

function mirror_sequence()
  local temp_one = {}
  local temp_two = {}
  local temp_three = {
    note_mod = {},
    note_mod_trig={},
    note_mod_trig_count={}
  }
  for i=1, one.length do
    temp_one[one.length+1-i] = one.data[i]
  end
  for i=1, two.length do
    temp_two[two.length+1-i] = two.data[i]
  end
  for i=1, one.length do
    temp_three.note_mod[one.length+1-i] = three.note_mod[i]
    temp_three.note_mod_trig[one.length+1-i] = three.note_mod_trig[i]
    temp_three.note_mod_trig_count[one.length+1-i] = three.note_mod_trig_count[i]
  end
  for i=1, one.length do
    set_loop_data("one",i,temp_one[i])
  end
  for i=1, two.length do
    set_loop_data("two",i,temp_two[i])
  end
  for i=1, one.length do
    params:set("note_mod_"..i,temp_three.note_mod[i])
    params:set("mod_trig_"..i,temp_three.note_mod_trig[i])
    three = deepcopy(temp_three)
  end
end


function change_octave(dir)
  if dir == "up" then
        params:delta("root_note",12)
    elseif dir == "down" then
     params:delta("root_note",-12)
  end
end

function fractal()
  reset_to_foundation(1)
  for i=1,one.length do
    params:set("one_data_"..i,get_chance_mod(one.data, i, one.length))
  end
end

function get_chance_mod(data, pos, length)
  chance = math.random(1,10)
  if chance == 1 then
    return one.data[math.random(1,length)] --shuffle
  elseif chance == 2 then
    return util.clamp(data[pos]+math.floor(math.random()*3)-1,1,8) --morph
  elseif chance == 3 then
    return util.clamp(data[pos]+math.floor(math.random()*5)-1,1,8) --bigmorph
  elseif chance == 4 then
    return data[length+1-pos] --mirror
  elseif chance >= 5 or chance <= 9 then
    return data[pos] --no change
  elseif chance == 10 then
    return 0 --mute
  end
end
    
    

    
    
  