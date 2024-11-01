extends Node

enum State {
	FREE = 0,  # Non-active
	STRT = 1,  # Startup
	ACTV = 2,  # Active
	RECV = 3,  # Recovery
	STUN = 4,  # Stun/ Histun
	BLCK = 5,  # Blockstun
	JMPB = 6,  # Jump Begin
	JMPF = 7,  # Jump FREE
	JMPS = 8,  # Jump STRT
	JMPA = 9,  # Jump ACTV
	JMPR = 10, # Jump RECV
	JMPJ = 11  # Jump Jumping
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
	DEBUG
}

enum Type { LOW = 0, MID = 1, HIG = 2, GRB = 3, UNB = 4 }

enum Hit { BLCK = 0, HURT = 1, CNTR = 2, GRAB = 3 }

enum Elem { HEALTH = 0, CONSOLE = 1 }

enum Load { SCENE = 0, BUNDLE = 1, ASSET = 2 }

enum AudioTypes { MASTER = 0, SFX = 1, DIA = 2, MUS = 3, CAL = 4 }

enum Constants { BUFFER_WINDOW = 3, SIMULTANEOUS_WINDOW = 2, HISTORY_WINDOW = 30 }

var Directions = {"2": "123", "4": "147", "6": "369", "8": "789"}
