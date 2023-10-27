extends Node


enum State {
	FREE,
	STRT,
	CURR,
	NEND,
	STUN,
	BUSY, 
	JMPS, 
	JMPC}




enum Level {
	# For reports that occur once per sub-tick (eg movement_tick)
	TICK, 
	# For reports that occur once per frame (eg Tick)
	FRAME, 
	# For reports that occur ocassionally (eg player dying/taking damage)
	EVENT, 
	# For reports on something that shouldnt happen
	ERROR, 
	# For unspecified events, for debugging
	DEBUG}
