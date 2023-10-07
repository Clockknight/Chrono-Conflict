class_name player
extends KinematicBody2D



var preloadHitBox = preload("res://Scenes/Boxes/Hit_Box.tscn")
var preloadHurtBox = preload("res://Scenes/Boxes/Hurt_Box.tscn")
var preloadSprite = preload("res://Scenes/Boxes/Sprite_Box.tscn")
var sprites = [preload("res://sprites/pow.png")]
var sfxs = [preload("res://Sound/whiff.mp3"), preload("res://Sound/hit.mp3"), preload("res://Sound/block.mp3")]
var _base_sprite = preload("res://sprites/icon.png")
var _state_sprites = [
	_base_sprite,
	_base_sprite,
	_base_sprite,
	_base_sprite, 
	preload("res://sprites/stunned.png"),
	_base_sprite,
	_base_sprite,
	_base_sprite]
	
	
enum State {
	FREE,
	STRT,
	CURR,
	NEND,
	STUN,
	BUSY, 
	JMPS, 
	JMPC}

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

var _cur_input 

var _state_frames_left = 1
var _bottom_pos = 0
var _base_scaley
var _stage_bounds 

var horizontal_speed 
var vertical_speed 
var gravity 
var terminal_speed 

var _interactions = []
var _state_queue = []

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
	_debug_message('============ Tick Start ', 2)
	# Read Inputs and save the input for this frame for later use
	_input_tick()
	_other._input_tick()
	
	_state_tick()
	_other._state_tick()
	
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
	


func _input_tick():
	_debug_message('Input Tick', 2)
	_cur_input = _read_input()
		
	
	if _state == State.FREE:
		if Input.is_action_pressed("ui_p1a2"):
			_parse_states(['JMPS|15', 'JMPC|1'])
		
	
	# todo	
	#	refactor other functions to use an input variable to figure out what to do
	
		
	#TODO
	#Later, this function can send the current input to a stack of inputs, so motions can be read there instead of here
	
	
func _state_tick():
	_debug_message('State Tick',2)
	# this tick is for dealing with the players' state. More specifically, a frame by frame check to see if the current state has expired, and if so, which state should be next?
	_debug_message('empty _state_queue: ' + str(_state_queue != []), 2)
	if _state == State.FREE and _state_queue == []:
		_state_frames_left = 1
	else:
		_state_frames_left -= 1
		if _state_frames_left <= 0:
			var new_state = _state_queue.pop_front()
			_debug_message("new_state: " + str(new_state), 3)
			_debug_message("_state_queue: " + str(_state_queue), 3)
			if new_state == null:
				_state = State.FREE
			else:
				_debug_message(str(State[new_state[0]]), 3)
				_state = State[new_state[0]]
				_state_frames_left = int(new_state[1])
				
				if _state == State.JMPC:
					_debug_message('jump started', 3)
					directional_input.y = -1 * self.vertical_speed
					
					
				
				
			
func _move_tick():
	_debug_message('Move Tick', 2)
	
	_calc_bottom_y()
	
	if (_grounded and _state == State.FREE):		
		$Collision_Box.disable(false)
		#X movement
		directional_input.x = _cur_input.x
		directional_input.x *= horizontal_speed
		
		#Y movement
		directional_input.y = 0
		
		
		if (_cur_input.y > 0):
			self.scale.y = _base_scaley * .5
			directional_input.x = 0
			directional_input.y += self._base_scaley
			
		elif (_cur_input.y < 0):
			directional_input.y = _cur_input.y * vertical_speed
	
	elif(not _grounded):
		$Collision_Box.disable(true)
		#get_node("Collision_Box").disabled = true
		directional_input.y += gravity
		if (directional_input.y > terminal_speed):
			directional_input.y = terminal_speed
			
			
	else:
		directional_input.x = 0

	if (_bottom_pos > 0):
		directional_input.y = -1 * _bottom_pos


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
	_debug_message('Box Tick', 2)
	if _state == State.FREE:
		if Input.is_action_just_pressed(_a1_string):
			spawn_box()
			_state_frames_left = 15
			_state = State.CURR
			
		


func _interact_tick():
	_debug_message('Interact Tick', 2)
	for _i in self.get_children():
		if _i is Box:
			_i.tick()
			
			
func _process_tick():
	_debug_message('Process Tick', 2)
	# look at list of interactions, compare highest priority value on list of interactions against other
	# if the number is uneven, process the lowest value of priorities, until all interactions are settled
		#in the case of multiple, prioritize preserving the one with the highest amount first, then duration
	
	#TODO how to tell if previous state was free or stun?
	# if bool check for if state just changed?
	$Sprite.set_texture(_state_sprites[_state])
	#_debug_message("_state value: " + str(_state), 3)
	#if _state == State.FREE:
	
	#elif _state == State.STUN:
	#	$Sprite.set_texture()
	
func _read_input():
	var x_sum = Input.get_axis(_left_string, _right_string)
	var y_sum = Input.get_axis(_up_string, _down_string)
	
	return {"x":x_sum, "y":y_sum}.duplicate()
	

	
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


func _parse_states(incoming: Array):
	if _state_queue != []:
		_debug_message('_parse_states() called when _state_queue not empty', 4)
	for s in incoming:
		_state_queue.append(s.split('|'))
		
