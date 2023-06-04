class_name player
extends KinematicBody2D

export(float) var horizontal_speed 
export(float) var vertical_speed 
export(float) var gravity 
export(float) var terminal_speed 
var directional_input  = Vector2.ZERO

var preloadHitBox = preload("res://Scenes/Boxes/Hit_Box.tscn")
var preloadHurtBox = preload("res://Scenes/Boxes/Hurt_Box.tscn")
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

var _grounded = false
var _base_scaley

func _ready():
	_base_scaley = scale.y

func _calc_bottom_y():
	_bottom_pos = self.position.y + abs($Collision_Box.shape.extents.y) * scale.y
	_grounded = _bottom_pos >= 0

func _sidecheck():
	if _p1_side != (self.position.x < _other.position.x):
		_p1_side = not _p1_side
		if _grounded:
			$Sprite.set_flip_h(true)

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
	_interact_tick()
	
func _move_tick():
	var x_sum = Input.get_axis(_left_string, _right_string)
	var y_sum = Input.get_axis(_up_string, _down_string)
	
	_calc_bottom_y()
	
	if (_grounded):		
		get_node("Collision_Box").disabled = false
		#X movement
		directional_input.x = x_sum
		directional_input.x *= horizontal_speed
		
		#Y movement
		self.scale.y = _base_scaley 
		directional_input.y = 0
		
		if (_bottom_pos > 0):
			directional_input.y = -1 * _bottom_pos
		
		if (y_sum > 0):
			self.scale.y = _base_scaley * .5
			directional_input.x = 0
			directional_input.y += self._base_scaley
			
		elif (y_sum < 0):
			directional_input.y = y_sum * vertical_speed
	
	else:
		get_node("Collision_Box").disabled = true
		directional_input.y += gravity
		if (directional_input.y > terminal_speed):
			directional_input.y = terminal_speed
	


	var collision = move_and_collide(directional_input)
	if collision:
		print_debug("collided with: "+ str(collision.collider.name))
		print_debug("(discarded) remaining motion: " + str(collision.remainder))
		print_debug("(discarded) remaining motion: " + str(collision.travel))
	
	if(_other):
		_sidecheck()
		
func _box_tick():
	_debug_message("Box_Tick Not Inherited")

func _interact_tick():
	_debug_message("Interact_Tick Not Inherited")
	
func damage(amount: int):
	_debug_message("DMG: "+str(amount))
	
func _debug_message(msg: String):
	if (_p1_side):
		print(msg)
	
	
# func spawn_boxes(framedata: 2dArray):
# take in 2d array and repeatedly call below box spawning func

#func spawn_box(framedata: 1dArray):
func spawn_box():
	#spawn box given array of variables describing it
	_debug_message("Test")
	var collision : CollisionShape2D = self.get_node("Collision_Box")
	var newBox : Box = preloadHitBox.instance()
	self.add_child(newBox)
	newBox.set_box(128, 0, 10, 10, 15)
	#newBox.position = Vector2(self.scale.x * self.get_node("Collision_Box").get_shape().get_extents()[0], 0)
	

