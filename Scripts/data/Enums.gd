extends Node


enum State {
	FREE=0, # Non-active
	STRT=1, # Startup 
	ACTV=2, # Active
	RECV=3, # Recovery
	STUN=4, # Stun/ Histun
	BLCK=5, # Blockstun
	JMPS=6, # Jumpsquat
	JMPA=7, # Jump Airborne
	JMPR=8  # Jump Recovery
	}
 



enum Level {
	# For reports that occur once per sub-tick (eg movement_tick's calculations)
	CALC, 
	# For reports that occur once per frame (eg Tick and Sub Tick)
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

enum Hit{
	BLCK=0,
	HURT=1,
	CNTR=2,
	GRAB=3
}

enum Elem{
	HEALTH = 0
	CONSOLE = 1
}
