extends Node

var width = 200

var adjust

var p1hp
var p1con

var p2hp
var p2con

var timer


# Called when the node enters the scene tree for the first time.
func _ready():
	p1hp = get_node("p1hp")
	p1con = get_node("p1con")

	p2hp = get_node("p2hp")
	p2con = get_node("p2con")
	p2con.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	timer = get_node("timer_temp")


func adjust_health(p1: bool, perc: float):
	adjust = (p1hp if p1 else p2hp).get_node("have")

	adjust.scale.x = max(0, perc)


func tick_timer():
	var time = int(timer.text)
	if time > 1:
		timer.text = str(time - 1)
	#elif time == 0:
	#call manager timeout function


func update_console(p1: bool, combo, state, direction, input, cx, sx, grounded, jumps):
	var text = "Combo: " + str(combo)
	text += "\nState: " + str(en.State.keys()[state])
	text += "\nMovement: " + str(direction)
	text += "\nCur x: " + str(cx) + " Stored x: " + str(sx)
	text += "\nGrounded: " + str(grounded)
	text += "\nJumps Remaining: " + str(jumps)
	text += "\nInput: " + input.report(10, false, true)

	(p1con if p1 else p2con).text = text

# func decompose(node:String)

# func to make lose shrink to have's size

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
