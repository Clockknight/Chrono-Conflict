extends Node


enum State {
	FREE, # Non-active
	STRT, # Startup 
	ACTV, # Active
	RECV, # Recovery
	STUN, # Stun/ Histun
	BLCK, # Blockstun
	JMPS, # Jumpsquat
	JMPB, # Jump begin
	JMPR} # Jump Recovery
 



enum Level {
	# For reports that occur once per sub-tick (eg movement_tick's calculations)
	CALC, 
	# For reports that occur once per frame (eg Tick and Tick varients)
	FRAME, 
	# For reports that occur ocassionally (eg player dying/taking damage)
	EVENT, 
	# For reports on something that shouldnt happen
	ERROR, 
	# For unspecified events, for debugging
	DEBUG}
