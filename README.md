# awake-mod

v1.0.7
Expands on the original Awake app for Norns by adding pages/features:
MOD - per-step transpose “scheduling” on every 2nd/3rd/etc. time the step is active
XPLSN - set fuse and various ‘end of sequence’ mod effects are available
FNDTN - establish a foundational sequence preset and reset to that foundation later

note: I do not have a grid so I didnt touch any of the Grid code

Documentation
See regular Awake for typical functionality. These two pages have been added:

-OPTION-

K2/K3 octave down/octave up

–MOD–

E2 selects which mod step to edit

E3 selects the mod value for the step:

off - mod step not active
1 to 8 - transpose note up when mod step is active
-1 to -7 - transpose note down when mod step is active
mute - mutes current step when mod step is active

K3 increases the trig division/K2 decreases

/1 to activate mod step every time the step is active (useful for ‘auditioning’ the transpose)
/2 for every other time the step is active
etc
up to /8 for every 8th time the step is active

Hold K1 + K2 to clear all active mod steps
Hold K1 + K3 to randomize all mod steps

Notes:
mod steps are indicated by a grey ‘step’ underneath the LOOP line
when a mod step is activated it will turn from grey to white and a small dot will appear above the step

Neat trick: if a regular step is inactive (i.e. no note), you can trigger a note to play using the mod step. Ex: mod = 1
trig = /2
Every other time the step is active, it will trigger the first note in the scale.

–XPLSN–
K2 light fuse/snuff fuse
K3 light quick fuse
E2 set fuse timer or rpt
E3 set type

fuse timer (once lit) decreases by 1 at the end of each loop
once timer reaches 0, sequence modification activates
set fuse timer to “rpt” to activate mod at the end of each sequence

types:

morph1 - top sequence is morphed
morph2 - bottom sequence is morphed
stp-rnd - top/bottom sequences are randomized
mod-rnd - mod steps are randomized
fndtn1-4 - sequence resets to foundation preset 1-4
mirror - all step positions are mirror image
oct-up - shift seq up 1 oct
oct-down - shift seq down 1 oct
fractal - controlled variation of fndtn 1 

–FNDTN–
K2 to set foundation
K3 to reset all steps and lengths to foundation
E2 select foundation preset 1-4

Keyboard controls:

F1 to F7 - mapped to each of the pages (STEP, LOOP, etc..)
F9 to F12 - reset to FNDTN 1 - 4 
Shift + F9 to F12 - set FNDTN 1 - 4

alt - K1
< - K2
> - K3

Left/right arrow - E2
Up/down arrow - E3

delete - disable step/mod step
- (dash) - oct down
= (equal) - oct up

