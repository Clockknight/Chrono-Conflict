class_name player
extends KinematicBody2D

enum State {FREE, PRIOR, CURR, END, STUN}


var preloadHitBox = preload("res://Scenes/Boxes/Hit_Box.tscn")
var preloadHurtBox = preload("res://Scenes/Boxes/Hurt_Box.tscn")
var preloadSprite = preload("res://Scenes/Boxes/Sprite_Box.tscn")
var sprites = [preload("res://sprites/pow.png")]
var sfxs = [preload("res://Sound/whiff.mp3"), preload("res://Sound/hit.mp3"), preload("res://Sound/block.mp3")]

var collision : CollisionShape2D 
var SFx_Audio 

var directional_input  = Vector2.ZERO

var _up_string = "ui_p1up"
var _down_string = "ui_p1down"
var _left_string = "ui_p1left"
var _right_string = "ui_p1right"
var _a1_string = "ui_p1a1"
var _a2_string = "ui_p1a2"
var _a3_string = "ui_p1a3"
var _a4_string = "ui_p1a4"

var _debug = false
var _other
var _p1_side = true
var _flipped = false
var _grounded = false
var _state = State.FREE

var _bottom_pos = 0
var _base_scaley
var _stage_bounds 

var horizontal_speed 
var vertical_speed 
var gravity 
var terminal_speed 

var _interactions = []

func _ready():
	_base_scaley = scale.y
	collision = self.get_node("Collision_Box")
	SFx_Audio = self.get_node("SFx_Audio")

## Calls the collision box's method to figure out the bottom most pixel of this object
func _calc_bottom_y():
	_bottom_pos = self.position.y + $Collision_Box.calc_height() * abs(self.scale.y)
	_grounded = _bottom_pos >= 0

func _sidecheck():
	if _p1_side != (self.position.x < _other.position.x):
		_p1_side = not _p1_side
	
	if _grounded:
		if (_p1_side and _flipped) or (not _p1_side and not _flipped):
			self.scale.x *= -1
			self._flipped = not _flipped
#		$Sprite.set_flip_h(true)

func _configure(other_player, bounds):
	# player object assumes it's player 1 until otherwise stated
	_other = other_player
	self._stage_bounds = bounds

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
	_other._move_tick()
	# tick box lifespans, and spawn new ones as needed
	_box_tick()
	_other._box_tick()
	# check box interactions
	_interact_tick()
	_other._interact_tick()
	
	_process_tick()
	
func _move_tick(attempted_move = Vector2.ZERO):
	if(_state != State.FREE and _grounded):
		return
	var x_sum = Input.get_axis(_left_string, _right_string)
	var y_sum = Input.get_axis(_up_string, _down_string)
	
	_calc_bottom_y()
	
	if (_grounded):		
		$Collision_Box.disable(false)
		#X movement
		directional_input.x = x_sum
		directional_input.x *= horizontal_speed
		
		#Y movement
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
		$Collision_Box.disable(true)
		#get_node("Collision_Box").disabled = true
		directional_input.y += gravity
		if (directional_input.y > terminal_speed):
			directional_input.y = terminal_speed


	if(abs(directional_input.x + self.position.x) > _stage_bounds):
		directional_input.x -= (abs(directional_input.x + self.position.x) - _stage_bounds) * sign(self.position.x)	
	
		
#	else:
		
	# downbacking is irrelevant, just dont move camera if they dont agree on a move



	var collision_report = move_and_collide(directional_input)
#	if collision_report:
#		print_debug("collided with: "+ str(collision.collider.name))
	
	_sidecheck()
	
	return directional_input
		
func _box_tick():
	if Input.is_action_just_pressed(_a1_string):
		spawn_box()

func _interact_tick():
	for _i in self.get_children():
		if _i is Box:
			_i.tick()
			
			
func _process_tick():
	_debug_message("Process Tick not Implemented!")
	# look at list of interactions, compare highest priority value on list of interactions against other
	# if the number is uneven, process the lowest value of priorities, until all interactions are settled
		#in the case of multiple, prioritize preserving the one with the highest amount first, then duration
		
	

	
func damage(priority:int, amount: int, hit_location: Vector2, duration:int):
	_interactions.append([priority, amount, hit_location, duration])
	
func clash(e1: Hit_Box, e2:Hit_Box):
	if not _p1_side:
		_debug_message("Clash detected", 1)
	
func _debug_message(msg: String, level:int=0):
	self.get_parent()._debug_message(msg, level, _p1_side)
	
	
# func spawn_boxes(framedata: 2dArray):
# take in 2d array and repeatedly call below box spawning func

	
func spawn_box(framedata: Array =[], posx = 100, posy=0, scalex=10, scaley=10, lifetime=15, damage=5):
	#spawn box given array of variables describing it
	var newBox : Box = preloadHitBox.instance()
	self.add_child(newBox)
	SFx_Audio.stream = sfxs[0]
	newBox.set_box(posx, posy, scalex,scaley, lifetime)
	SFx_Audio.play()

	
func spawn_sprite(displacement: Vector2, duration: int, asset_index: int):
	var newSprite : Sprite_Box = preloadSprite.instance()
	self.add_child(newSprite)
	newSprite.set_sprite(displacement, duration, sprites[asset_index])

