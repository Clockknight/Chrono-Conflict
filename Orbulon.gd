extends KinematicBody2D

export(float) var horizontal_speed = 10.0
export(float) var vertical_speed = 50.0
var directional_input = Vector2.ZERO
var gravity = .1
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
	grounded = bottom_pos >= 0
	if (grounded):
		directional_input.y = 0
		directional_input.y -=  Input.get_action_strength("ui_up")
	directional_input.y *= vertical_speed
	
	

	move_and_collide(directional_input)
