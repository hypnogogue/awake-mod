# awake-mod

Awake-mod
Expands on the original Awake app for Norns by adding a page for “Mod” - per-step transpose “scheduling” on every 2nd/3rd/etc. time the step is active

note: I do not have a grid so I didnt touch any of the Grid code
Requirements
Just a Norns!

Documentation
Use E1 to navigate to the MOD screen

E2 selects which MOD step to edit

E3 selects the mod value for the step:

off - mod not active
1 to 8 - transpose note up when mod step is active
-1 to -7 - transpose note down when mod step is active
mute - mutes current step when mod step is active
K3 increases the trig division/K2 decreases
-off/mod not active

/1 to activate MOD every time the step is active (useful for ‘auditioning’ the transpose)
/2 for every other time the step is active
etc
up to /8 for every 8th time the step is active
Hold K1 + K2 to clear all active MOD steps
Hold K1 + K3 to randomize all MOD steps

Notes:
MOD steps are indicated by a grey ‘step’ underneath the LOOP line
when a MOD step is activated it will turn from grey to white

Neat trick: if a regular step is inactive (i.e. no note), you can trigger a note to play using the MOD step. Ex: MOD = 1
trig = /2
Every other time the step is active, it will trigger the first note in the scale.
