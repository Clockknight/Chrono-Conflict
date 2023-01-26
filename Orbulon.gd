extends KinematicBody2D

export(float) var speed = 100


func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	var directional_input = Vector2.ZERO
	directional_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	directional_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	move_and_collide(directional_input * speed)
