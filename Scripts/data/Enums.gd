extends Node


enum State {
	FREE=0, # Non-active
	STRT=1, # Startup 
	ACTV=2, # Active
	RECV=3, # Recovery
	STUN=4, # Stun/ Histun
	BLCK=5, # Blockstun
	JMPS=6, # Jumpsquat
	JMPB=7, # Jump begin
	JMPR=8  # Jump Recovery
	}
 



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
	
enum Type{
	LOW=0,
	MID=1,
	HIG=2,
	GRB=3,
	UNB=4
}
