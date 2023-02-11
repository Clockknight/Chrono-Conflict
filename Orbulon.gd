extends KinematicBody2D

export(float) var horizontal_speed = 25.0
export(float) var vertical_speed = 80.0
export(float) var gravity = 5
export(float) var terminal_speed = gravity * 20
var directional_input  = Vector2.ZERO
var bottom_pos = 0

var _up_string = "ui_p1up"
var _down_string = "ui_p1down"
var _left_string = "ui_p1left"
var _right_string = "ui_p1right"
var _p1_side = true
var _bottom

func _init():
	print("start")
	#if self.position.x > 0:
	#	_p1_side = false
		
	

func _ready():
	_bottom = self.get_node("char_bottom")
	

func _physics_process(delta):
	var x_sum = Input.get_axis(_left_string, _right_string)
	var y_sum = Input.get_axis(_up_string, _down_string)
	
	bottom_pos = (_bottom.get_global_position().y)
	var grounded = bottom_pos >= 0
	
	print(bottom_pos)
	print(directional_input)
	
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
	

	move_and_collide(directional_input)
