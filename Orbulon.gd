extends KinematicBody2D

export(float) var speed = 10.0
var directional_input = Vector2.ZERO
var gravity = .1


func _ready():
	var _bottom = self.get_node("char_bottom")	
	





func _physics_process(delta):
	directional_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	directional_input.y -=  Input.get_action_strength("ui_up")
	directional_input.y += gravity

	move_and_collide(directional_input * speed)
