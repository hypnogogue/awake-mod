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