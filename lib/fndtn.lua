--todo: add all fndtn values to params 
function add_fndtn_params()
    params:add_separator()
    params:add_group("fndtn 1",17)
    
    params:add{type = "number", id = "fndtn_one_length", name = "length", min=1, max=16, 
      default = one.length }
  
    for i=1,16 do
      params:add{type = "number", id= ("fndtn_one_data_"..i), name = ("fndtn_one_data "..i), min=0, max=8, 
        default = one.data[i]}
    end
  end
  
  
  function set_foundation(p)
    fndtn_preset ={}
    fndtn_preset.one = deepcopy(one)
    fndtn_preset.two = deepcopy(two)
    three.note_mod_trig_count = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    fndtn_preset.three = deepcopy(three)
    foundations[p] = deepcopy(fndtn_preset)
  end
  
  function deepcopy(orig)
      local orig_type = type(orig)
      local copy
      if orig_type == 'table' then
          copy = {}
          for orig_key, orig_value in next, orig, nil do
              copy[deepcopy(orig_key)] = deepcopy(orig_value)
          end
          setmetatable(copy, deepcopy(getmetatable(orig)))
      else -- number, string, boolean, etc
          copy = orig
      end
      return copy
  end
  
  function reset_to_foundation(fndtn_num)
  foundations[fndtn_num].one.pos=one.pos
  foundations[fndtn_num].two.pos=two.pos
  one = deepcopy(foundations[fndtn_num].one)
  two = deepcopy(foundations[fndtn_num].two)
  three = deepcopy(foundations[fndtn_num].three)
    for i=1,16 do
      params:set("one_length",one.length)
      params:set("two_length",two.length)
      params:set("one_data_"..i,one.data[i])
      params:set("two_data_"..i,two.data[i])
      params:set("note_mod_"..i,three.note_mod[i])
      params:set("mod_trig_"..i,three.note_mod_trig[i])
    end
  end