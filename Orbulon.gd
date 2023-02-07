extends KinematicBody2D

export(float) var horizontal_speed = 25.0
export(float) var vertical_speed = 80.0
export(float) var gravity = 5
var directional_input = Vector2.ZERO
var _bottom
var bottom_pos = 0
var grounded = true

func _ready():
	_bottom = self.get_node("char_bottom")
	

func _physics_process(delta):
	directional_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	directional_input.x *= horizontal_speed
	
	directional_input.y += gravity
	bottom_pos = (_bottom.get_global_position().y)
	print(bottom_pos)
	grounded = bottom_pos >= 0
	if (grounded):
		directional_input.y = 0
		directional_input.y -=  Input.get_action_strength("ui_up")
		directional_input.y *= vertical_speed
		if (directional_input.y == 0):
			directional_input.y -= bottom_pos
	
	

	move_and_collide(directional_input)
