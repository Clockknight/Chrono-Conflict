class_name player
extends KinematicBody2D

export(float) var horizontal_speed = 25.0
export(float) var vertical_speed = 80.0
export(float) var gravity = 5.0
export(float) var terminal_speed = gravity * 20
var directional_input  = Vector2.ZERO


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
var _bottom



func configure(other_player):
	# player object assumes it's player 1 until otherwise stated
	_other = other_player
	print("_other_player assigned" + _other)
	_sidecheck()
	print("config sidecheck() ran")
	
	if not _p1_side:
		_up_string = "ui_p2up"
		_down_string = "ui_p2down"
		_left_string = "ui_p2left"
		_right_string = "ui_p2right"
		_a1_string = "ui_p2a1"
		_a2_string = "ui_p2a2"
		_a3_string = "ui_p2a3"
		_a4_string = "ui_p2a4"


func _sidecheck():
	_p1_side = self.position.x < _other.position.x

func tick():
	_move_tick()
	# check box interactions
	_box_tick()
	# then spawn new boxes
	
	

func _move_tick():
	var x_sum = Input.get_axis(_left_string, _right_string)
	var y_sum = Input.get_axis(_up_string, _down_string)
	
	bottom_pos = (_bottom.get_global_position().y)
	var grounded = bottom_pos >= 0
	
	if (grounded):		
		#X movement
		directional_input.x = x_sum
		directional_input.x *= horizontal_speed
		
		#Y movement
		self.scale.y = 1
		directional_input.y = 0
		
		if (y_sum == 0):
			if (bottom_pos > 0):
				directional_input.y = -1 * bottom_pos
			
		elif (y_sum > 0):
			self.scale.y = .5
			directional_input.x = 0
			
		elif (y_sum < 0):
			directional_input.y += y_sum * vertical_speed
		
	
	elif (not grounded):
		directional_input.y += gravity
		if (directional_input.y > terminal_speed):
			directional_input.y = terminal_speed
	
	
	#Should only collide if im on the ground and not moving up
	move_and_collide(directional_input)
	
	if(_other):
		_sidecheck()
		
func _box_tick():
	print("box_tick")
