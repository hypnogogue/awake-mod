local keyboard = hid.connect()
shift_active = false

function keyboard.event(type, code, val)

  if code == 59 and val==1 then --F1
    mode = 1
  elseif code == 60 and val ==1 then --F2
    mode = 2
  elseif code == 61 and val ==1 then --F3
    mode = 3
  elseif code == 62 and val ==1 then --F4
    mode = 4
  elseif code == 63 and val ==1 then --F5
    mode = 5
  elseif code == 64 and val ==1 then --F6
    mode = 6
  elseif code == 65 and val ==1 then --F7
    mode = 7
  elseif code == 67 and val ==1 then --F9
    fndtn_num=1
    kb_fndtn(fndtn_num)
  elseif code == 68 and val ==1 then --F10
    fndtn_num=2
    kb_fndtn(fndtn_num)
  elseif code == 87 and val ==1 then --F11
    fndtn_num=3
    kb_fndtn(fndtn_num)
  elseif code == 88 and val ==1 then --F12
    fndtn_num=4
    kb_fndtn(fndtn_num)
  elseif code == 82 then -- num pad 0
    key(1,(val == 0 and 0 or 1)) 
  elseif code == 79 then --num pad 1
    key(2,val)
  elseif code == 80 then -- num pad 2
    key(3,val)
  elseif code == 105 and val == 1 then --left arrow
    enc(2,-1)
  elseif code == 106 and val == 1 then --right arrow
    enc(2,1)
  elseif code == 103 and val == 1 then --up arrow
    enc(3,1)
  elseif code == 108 and val == 1 then --down arrow
    enc(3,-1)
  elseif code == 42 then --shift
    if val==0 then
      shift_active=false
    else
      shift_active=true
    end
  end
  
  print(type, code, val)
  
end

function kb_fndtn(fndtn_num)
    if shift_active then
      set_foundation(fndtn_num)
    else
      reset_to_foundation(fndtn_num)
    end
end

