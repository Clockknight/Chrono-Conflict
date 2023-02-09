extends KinematicBody2D

export(float) var horizontal_speed = 25.0
export(float) var vertical_speed = 80.0
export(float) var gravity = 5
export(float) var terminal_speed = gravity * 20
var directional_input  = Vector2.ZERO
var bottom_pos = 0

var _bottom

func _ready():
	_bottom = self.get_node("char_bottom")
	

func _physics_process(delta):
	var x_sum = Input.get_axis("ui_left", "ui_right")
	var y_sum = Input.get_axis("ui_up", "ui_down")
	
	bottom_pos = (_bottom.get_global_position().y)
	var grounded = bottom_pos >= 0
	
	print(bottom_pos)
	
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
