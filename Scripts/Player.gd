class_name player
extends KinematicBody2D

# external classes
const Move_Data = preload('./data/Move_Data.gd')
const e = preload('./data/Enums.gd')

# Constants
const BUFFER_WINDOW = 3

# Assets
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
	

	
# enums


# nodes
var collision : CollisionShape2D 
var SFx_Audio 

# 2d Vectors
var directional_input  = Vector2.ZERO

# inputs
var _up_string = "ui_p1up"
var _down_string = "ui_p1down"
var _left_string = "ui_p1left"
var _right_string = "ui_p1right"
var _a_string = "ui_p1a"
var _b_string = "ui_p1b"
var _c_string = "ui_p1c"
var _d_string = "ui_p1d"
var _input_dict = {}
var _cur_input 

# configurations 
var _debug = false
var _other
var _p1_side = true
var _flipped = false
var _grounded = false
var _state = e.State.FREE

# integers
var _state_frames_left = 1
var _bottom_pos = 0
var _base_scaley
var _base_scalex 
var _stage_bounds 
var _stored_x = 0
var _cur_x = 0
var _health
var _jumps_max =2 
var _jumps

# floats
var horizontal_speed 
var vertical_speed 
var gravity 
var terminal_speed 
var _friction
var _deceleration_max

# queues
var _move_queue = []
var _state_queue = []
var _input_queue = []
var _input_history = []

func _ready():
	_base_scaley = scale.y
	_base_scalex = scale.x
	_cur_input = _read_input(true)
	_friction = .1
	_deceleration_max = .05
	collision = self.get_node("Collision_Box")
	SFx_Audio = self.get_node("SFx_Audio")


func _configure(other_player, bounds):
	# player object assumes it's player 1 until otherwise stated
	_other = other_player
	_jumps = _jumps_max
	self._stage_bounds = bounds

	_sidecheck()
	
	_up_string = update_dictionary(_up_string, "ui_p2up")
	_down_string= update_dictionary(_down_string, "ui_p2down")
	_left_string =update_dictionary(_left_string, "ui_p2left")
	_right_string=update_dictionary(_right_string, "ui_p2right")
	_a_string=update_dictionary(_a_string, "ui_p2a")
	_b_string=update_dictionary(_b_string, "ui_p2b")
	_c_string=update_dictionary(_c_string,  "ui_p2c")
	_d_string=update_dictionary(_d_string, "ui_p2d")
		
	_debug_message(str(_input_dict))
	_debug_message(str(InputMap.get_action_list("ui_p1up")[0].scancode))
	_debug_message(str(InputMap.get_action_list("ui_p1down")[0].scancode))

func _unhandled_input(event):
	if event is InputEventKey:
		_input_queue.append([event, event.pressed])
		_debug_message(str(_input_queue[-1]))
		_debug_message(str(event.scancode))

func update_dictionary(player1_option:String, player2_option:String):
	var res
	
	if _p1_side:
		res = player1_option
	
	else:
		res = player2_option
	
#	_debug_message(res)
#	_debug_message(str(InputMap.get_action_list(res)))
	_input_dict[InputMap.get_action_list(res).pop_front().scancode] = res
	
	return res
	
func tick():
	_debug_message(e.Level.FRAME, 'Tick Start ============')
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
	_debug_message(e.Level.FRAME, 'Input Tick')
	_cur_input = _read_input()

	_interpret_inputs(_cur_input)
#		todo
#		refactor other functions to use an input variable to figure out what to do
	
	

func _read_input(new:bool = false):
	var x_sum = Input.get_axis(_left_string, _right_string)
	var y_sum = Input.get_axis(_up_string, _down_string)
	
	var a = false
	var b = false
	var c = false
	var d = false
	if not new: 
		var _new_input
		var _ninput_event
		var _ninput_state
		
		a = _cur_input.a
		b= _cur_input.b
		c= _cur_input.c
		d = _cur_input.d
		if _input_queue != []:
			_debug_message(e.Level.FRAME, "Processing input queue...")
			
		
		while _input_queue != []:
			_new_input = _input_queue.pop_front()
			_ninput_event = _new_input[0]
			_ninput_state = _new_input[1]
			
			_ninput_event.is_action(_a_string)
			
			#_debug_message(str(_new_input))
		
		
	
	
	return {"x":x_sum, "y":y_sum, "a":a, "b":b, "c":c, "d":d}.duplicate()

func _interpret_inputs(values:Dictionary):
	
	if _state == e.State.FREE or (_state_frames_left <= BUFFER_WINDOW and _state_queue == []):
		if Input.is_action_pressed(_up_string):
			_parse_states(['JMPS|5'])
			_cur_x = _stored_x
			_stored_x = _cur_input['x']
		

		
func _state_tick():
	_debug_message(e.Level.FRAME, 'State Tick')
	# this tick is for dealing with the players' state. More specifically, a frame by frame check to see if the current state has expired, and if so, which state should be next?
	_debug_message(e.Level.FRAME, 'empty _state_queue: ' + str(_state_queue != []))
	if _move_queue != []:
		_debug_message(e.Level.FRAME, "Interactions: " + str(_move_queue))
		_debug_message(e.Level.FRAME, "Processing interaction... " + str(_move_queue[0]))
		var cur_move = _move_queue.pop_front()
		
		while _move_queue != []:
			if cur_move.priority < _move_queue[0].priority:
				cur_move = _move_queue.pop_front()
		
		
		_debug_message(e.Level.FRAME, "Damage incoming: " + str(cur_move.damage) )
		self._health -= cur_move.damage
		if self._health <= 0:
			self._health = 0
			self.die()
		
		self._state = cur_move.state
		directional_input = cur_move.influence * -1 if _p1_side else 1
		
		_parse_states([], cur_move.state, cur_move.duration)
		
		
		
	if _state == e.State.FREE and _state_queue == []:
		_state_frames_left = 1
		
		
	else:
		_state_frames_left -= 1
		if _state_frames_left <= 0:
			var new_state = _state_queue.pop_front()
			_debug_message( e.Level.FRAME, "new_state: " + str(new_state))
			_debug_message(e.Level.FRAME, "_state_queue: " + str(_state_queue))
			if new_state == null:
				_debug_message(e.Level.FRAME, 'state queue empty - returning to free')
				_state = e.State.FREE
			else:
				if _state == e.State.JMPS and _jumps > 0:
					_debug_message(e.Level.FRAME, 'jump started')
					directional_input.y = -1 * self.vertical_speed
					_cur_x = _stored_x
					_jumps -= 1
					
				
				_state = new_state[0]
				_state_frames_left = new_state[1]
					
		
				
		
		

func _move_tick():
	_debug_message(e.Level.FRAME, 'Move Tick')
	
	_calc_bottom_y()
	
	if _grounded:
		if _state != e.State.JMPS:
			_jumps = _jumps_max
		
		if _state == e.State.FREE:
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
	
	if(not _grounded):
		$Collision_Box.disable(true)
		#get_node("Collision_Box").disabled = true
		directional_input.y = min(gravity + directional_input.y , terminal_speed)
		
		# clause for landing
		if directional_input.y >= -1 * _bottom_pos:
			directional_input.y = -1 * _bottom_pos
			directional_input.x =  100 
		
			
		
		#todo fix double jumping
		directional_input.x = _cur_x * self.horizontal_speed
			
	if(_state == e.State.STUN):
		directional_input.x = directional_input.x * (1-_friction) 
		

	if (_bottom_pos > 0):
		_debug_message( e.Level.ERROR, "Player's position is below the floor! Adjusting...")
		directional_input.y = -1 * _bottom_pos


	if(abs(directional_input.x + self.position.x) > _stage_bounds):
		directional_input.x -= (abs(directional_input.x + self.position.x) - _stage_bounds) * sign(self.position.x)	


	var collision_report = move_and_collide(directional_input)
#	if collision_report:
#		print_debug("collided with: "+ str(collision.collider.name))
	
	_sidecheck()
	
	return directional_input

func _box_tick():
	_debug_message(e.Level.FRAME, 'Box Tick')
	if _state == e.State.FREE:
		if Input.is_action_just_pressed(_a_string):
			spawn_box()
			_state_frames_left = 15
			_state = e.State.CURR

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
			
func _interact_tick():
	_debug_message(e.Level.FRAME, 'Interact Tick')
	for _i in self.get_children():
		if _i is Box:
			_i.tick()

func _process_tick():
	_debug_message(e.Level.FRAME, 'Process Tick')
	# look at list of interactions, compare highest priority value on list of interactions against other
	# if the number is uneven, process the lowest value of priorities, until all interactions are settled
		#in the case of multiple, prioritize preserving the one with the highest amount first, then duration
	
	#TODO how to tell if previous state was free or stun?
	# if bool check for if state just changed?
	$Sprite.set_texture(_state_sprites[_state])
	#_debug_message(e.Level.EVENT, "_state value: " + str(_state))
	#if _state == e.State.FREE:
	
	#elif _state == e.State.STUN:
	#	$Sprite.set_texture()


func damage(incoming_move: Move_Data):
	_move_queue.append(incoming_move)

func clash(e1: Hit_Box, e2:Hit_Box):
	if not _p1_side:
		_debug_message(e.Level.EVENT, "Clash detected")

func _debug_message(level, msg:String=""):
	if level is String:
		msg= level
		level = e.Level.DEBUG
	elif 2 != typeof(level):
		msg = "Misconfigured _Debug String..." + str(level)
		level = e.Level.DEBUG
	self.get_parent()._debug_message( level, msg, _p1_side)


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


func _parse_states(incoming: Array = [], incoming_state: int=e.State.FREE, incoming_duration: int = 0):
	
	#if _state_queue != []:
		#_debug_message(e.Level.EVENT, '_parse_states() called when _state_queue not empty')
	if incoming != []:
		for s in incoming:
#			_debug_message('State being parsed!!')
			s = s.split('|')
			s = [e.State[s[0]], int(s[1])]
			_state_queue.append(s)
			
#	_debug_message(str(incoming_state))
#	_debug_message(str(incoming_duration))
	if incoming_state != e.State.FREE and incoming_duration >= 0:
		if(incoming_duration) <= 0:
			_debug_message( e.Level.ERROR, 'State with duration of 0 passed in!')
		_state_queue.append([incoming_state, incoming_duration])
			
	_debug_message(e.Level.ERROR, 'Empty state passed to parse_states')
	return
		
		
func die():
	_debug_message(e.Level.EVENT, 'I am Defeated!.')
