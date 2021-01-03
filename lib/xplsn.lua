xplsn_types = {"morph1","morph2","stp-rnd","mod-rnd","fndtn1","fndtn2","fndtn3","fndtn4"}
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