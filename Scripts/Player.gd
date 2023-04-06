class_name player
extends KinematicBody2D

export(float) var horizontal_speed 
export(float) var vertical_speed 
export(float) var gravity 
export(float) var terminal_speed 
var directional_input  = Vector2.ZERO

var preloadedBoxes := [
	"res://Nodes/Boxes/box.gd"
]
var preloadedAssets

var _up_string = "ui_p1up"
var _down_string = "ui_p1down"
var _left_string = "ui_p1left"
var _right_string = "ui_p1right"
var _a1_string = "ui_p1a1"
var _a2_string = "ui_p1a2"
var _a3_string = "ui_p1a3"
var _a4_string = "ui_p1a4"

var _other
var _p1_side = true
var _bottom_pos = 0


func _calc_bottom_y():
	_bottom_pos = self.position.y + abs($Collision_Box.shape.extents.y)

func _sidecheck():
	_p1_side = self.position.x < _other.position.x

func _configure(other_player):
	# player object assumes it's player 1 until otherwise stated
	_other = other_player

	_sidecheck()

	
	if not _p1_side:
		_up_string = "ui_p2up"
		_down_string = "ui_p2down"
		_left_string = "ui_p2left"
		_right_string = "ui_p2right"
		_a1_string = "ui_p2a1"
		_a2_string = "ui_p2a2"
		_a3_string = "ui_p2a3"
		_a4_string = "ui_p2a4"

func tick():
	#move self and move projectiles, which should move child boxes as well
	_move_tick()
	# tick box lifespans, and spawn new ones as needed
	_box_tick()
	# check box interactions
	# _interact_tick()
	
func _move_tick():
	var x_sum = Input.get_axis(_left_string, _right_string)
	var y_sum = Input.get_axis(_up_string, _down_string)
	
	_calc_bottom_y()
	
	if (_bottom_pos >= 0):		
		get_node("Collision_Box").disabled = false
		#X movement
		directional_input.x = x_sum
		directional_input.x *= horizontal_speed
		
		#Y movement
		self.scale.y = 1
		directional_input.y = 0
		
		if (_bottom_pos > 0):
			directional_input.y = -1 * _bottom_pos
		
		if (y_sum > 0):
			self.scale.y = .5
			directional_input.x = 0
			
		elif (y_sum < 0):
			directional_input.y = y_sum * vertical_speed
	
	else:
		get_node("Collision_Box").disabled = true
		directional_input.y += gravity
		if (directional_input.y > terminal_speed):
			directional_input.y = terminal_speed
	

	move_and_collide(directional_input)
	
	if(_other):
		_sidecheck()
		
func _box_tick():
	_bottom_pos = _bottom_pos

func _interact_tick():
	print("Interactions")
	
func damage(amount: int):
	_debug_message(())
	
func _debug_message(msg: String):
	if (_p1_side):
		print(msg)
	
