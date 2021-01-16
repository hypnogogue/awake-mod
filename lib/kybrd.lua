--local keyboard = hid.connect()
shift_active = false

function keyboard.code(code, val)
  print(code,val)
  screen.ping()

  if code == "F1" and val==1 then 
    mode = 1
  elseif code == "F2" and val ==1 then 
    mode = 2
  elseif code == "F3" and val ==1 then 
    mode = 3
  elseif code == "F4" and val ==1 then 
    mode = 4
  elseif code == "F5" and val ==1 then 
    mode = 5
  elseif code == "F6" and val ==1 then 
    mode = 6
  elseif code == "F7" and val ==1 then 
    mode = 7
  elseif code == "F9" and val ==1 then 
    fndtn_num=1
    kb_fndtn(fndtn_num)
  elseif code == "F10" and val ==1 then 
    fndtn_num=2
    kb_fndtn(fndtn_num)
  elseif code == "F11" and val ==1 then 
    fndtn_num=3
    kb_fndtn(fndtn_num)
  elseif code == "F12" and val ==1 then 
    fndtn_num=4
    kb_fndtn(fndtn_num)
  elseif code == "LEFTALT" or code == "RIGHTALT" then 
    key(1,(val == 0 and 0 or 1)) 
  elseif code == "COMMA" then --<
    key(2,val)
  elseif code == "DOT" then -- >
    key(3,val)
  elseif code == "LEFT" and val == 1 then 
    enc(2,-1)
  elseif code == "RIGHT" and val == 1 then
    enc(2,1)
  elseif code == "UP" and val == 1 then 
    enc(3,1)
  elseif code == "DOWN" and val == 1 then 
    enc(3,-1)
  elseif code == "RIGHTSHIFT" or code == "LEFTSHIFT" then 
    if val==0 then
      shift_active=false
    else
      shift_active=true
    end
  elseif code == "DELETE" and val == 1 then 
    if mode == 1 then
      if edit_ch == 1 then
        params:set("one_data_"..edit_pos, 0)
      else
        params:set("two_data_"..edit_pos, 0)
      end
    elseif mode == 5 then
      params:set("note_mod_"..edit_pos, 0)
    end
  elseif code == "MINUS" and val == 1 then 
    params:delta("root_note",-12)
  elseif code == "EQUAL" and val == 1 then 
    params:delta("root_note",12)
  elseif code == "RIGHTCTRL" then 
    if val==0 then
      trans_up_active=false
    else
      trans_up_active=true
    end
  elseif code == "LEFTCTRL" then 
    if val==0 then
      trans_down_active=false
    else
      trans_down_active=true
    end
  elseif code == "1" and val==1 then
    kb_transpose(1)
  elseif code == "2" and val==1 then
    kb_transpose(2)
  elseif code == "3" and val==1 then
    kb_transpose(3)
  elseif code == "4" and val==1 then
    kb_transpose(4)
  elseif code == "5" and val==1 then
    kb_transpose(5)
  elseif code == "6" and val==1 then
    kb_transpose(6)
  elseif code == "7" and val==1 then
    kb_transpose(7)
  elseif code == "8" and val==1 then
    kb_transpose(8)
  elseif code == "9" and val==1 then
    kb_transpose(9)
end
  
  
end

function kb_fndtn(fndtn_num)
    if shift_active then
      set_foundation(fndtn_num)
    else
      reset_to_foundation(fndtn_num)
    end
end

function kb_transpose(delta)
  if trans_up_active then
    params:delta("root_note", delta)
  elseif trans_down_active then
    params:delta("root_note", -delta)
  end
end
