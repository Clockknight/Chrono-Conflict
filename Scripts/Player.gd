class_name player
extends KinematicBody2D

# external classes
const Move_Data = preload('res://Scripts/Data/Move_Data.gd')
const i = preload('res://Scripts/Data/Input_Data.gd')

# Constants
const BUFFER_WINDOW = 3

# Assets
const SFx_Audio  =preload('res://Scenes/Assets/SFx_Audio.tscn')
const preloadHitBox = preload("res://Scenes/Boxes/Hit_Box.tscn")
const preloadHurtBox = preload("res://Scenes/Boxes/Hurt_Box.tscn")
var preloadSprite
var sprites 
var _base_sprite 
var sfxs 
var _state_sprites

# nodes
var collision : CollisionShape2D 

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
var _state = en.State.FREE

# integers
var _state_frames_left = 1
var _bottom_pos = 0
var _base_scaley
var _base_scalex 
var _stage_bounds 
var _stored_x = 0
var _cur_x = 0
var _max_health
var _health
var _jumps_max = 80
var _jumps
var combo = 0

# floats
const _friction = .5
const _deceleration_max = .05
var horizontal_speed 
var vertical_speed 
var gravity 
var terminal_speed 

# queues
var _move_queue = []
var _state_queue = []
var _input_queue = []
var _input_history = []

func _ready():
	_base_scaley = scale.y
	_base_scalex = scale.x
	collision = self.get_node("Collision_Box")
	_health = _max_health


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

func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode in _input_dict:
			_input_queue.append([event, event.pressed])

func update_dictionary(player1_option:String, player2_option:String):
	var res
	
	if _p1_side:
		res = player1_option
	
	else:
		res = player2_option
	
	if InputMap.get_action_list(res).pop_front().physical_scancode == 0:
		_input_dict[InputMap.get_action_list(res).pop_front().scancode] = res
	else:
		_input_dict[InputMap.get_action_list(res).pop_front().physical_scancode] = res
	
	return res
	

func tick():
	_debug_message(en.Level.FRAME, 'Tick Start ============')
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
	_other._process_tick()
	


func _input_tick():
	_debug_message(en.Level.FRAME, 'Input Tick')
	_cur_input = _read_input()
	_interpret_inputs(_cur_input)

#	_debug_message(_input_queue)
#		todo
#		refactor other functions to use an input variable to figure out what to do

#	_debug_message(_input_queue)
	
	

func _read_input():
	# Process all the queued inputs, and pass the resulting input to cur innput next
	var x = 0
	var y = 0
	
	var a = false
	var b = false
	var c = false
	var d = false
	
	var new_input
	var _ninput_event
	var _ninput_state

	if is_instance_valid(_cur_input):
		x = _cur_input.x
		y = _cur_input.y
		a = _cur_input.a
		b = _cur_input.b
		c = _cur_input.c
		d = _cur_input.d
		
	if _input_queue != []:
		_debug_message(en.Level.FRAME, "Processing input queue...")
	while _input_queue != []:
		new_input = _input_queue.pop_front()
		_ninput_event = new_input[0].scancode
		_ninput_state = new_input[1]
		
		
		# TODO add check for simultaneous l/R input
		match _input_dict[_ninput_event]:
			_up_string:
				y -=  int(_ninput_state) *2-1
			_down_string:
				y +=  int(_ninput_state)*2-1
			_left_string:
				x -=  int(_ninput_state) *2-1
			_right_string:
				x +=  int(_ninput_state) *2-1
			_a_string:
				a = _ninput_state
			_b_string:
				b = _ninput_state
			_c_string:
				c = _ninput_state
			_d_string:
				d = _ninput_state
		
		x = clamp(x, -1, 1)
		y = clamp(y, -1, 1)
	
	new_input = i.new(self, x, y, a,b,c,d)
	_cur_input = new_input.compare(_cur_input)
	
	return _cur_input

func _interpret_inputs(values:Input_Data):
	_debug_message(en.Level.ERROR, "_Interpret_inputs Not Inherited!")

		
func _state_tick():
	_debug_message(en.Level.FRAME, 'State Tick')
	# this tick is for dealing with the players' state. More specifically, a frame by frame check to see if the current state has expired, and if so, which state should be next?
	_debug_message(en.Level.FRAME, 'empty _state_queue: ' + str(_state_queue != []))
	if _move_queue != []:
		_debug_message(en.Level.FRAME, "Interactions: " + str(_move_queue))
		_debug_message(en.Level.FRAME, "Processing interaction... " + str(_move_queue[0]))
		var cur_move = _move_queue.pop_front()
		
		
		while _move_queue != []:
			if cur_move.priority < _move_queue[0].priority:
				cur_move = _move_queue.pop_front()
			else:
				_move_queue.pop_front()
		
		# block for being hit
		# TODO this should be its own function
		process_move(cur_move)
		
		
	
		
	if _state == en.State.FREE and _state_queue == []:
		_state_frames_left = 1
		
		
	else:
		_state_frames_left -= 1
		if _state_frames_left <= 0:
			var new_state = _state_queue.pop_front()
			_debug_message(en.Level.FRAME, "new_state: " + str(new_state))
			_debug_message(en.Level.FRAME, "_state_queue: " + str(_state_queue))
			if new_state == null:
				_debug_message(en.Level.FRAME, 'state queue empty - returning to free')
				_state = en.State.FREE
			else:
				if _state == en.State.JMPS and _jumps > 0:
					_debug_message(en.Level.FRAME, 'jump started')
					self.directional_input.y = -1 * self.vertical_speed
					_cur_x = _stored_x
					_jumps -= 1
				_state = new_state[0]
				_state_frames_left = new_state[1]
					
					
# todo rename test
func process_move(cur_move):
	match _block_check(cur_move):
		en.Hit.HURT:
			self._other.play_sound(cur_move.hit)
			_other._debug_message(en.Level.FRAME, "Damage incoming: " + str(cur_move.damage) )
			_other.combo +=1
			
			
			self._health -= cur_move.damage
			var pct = float( _health / _max_health)
			
			_adjust_ui(pct, en.Elem.HEALTH)
			
			
			if self._health <= 0:
				self._health = 0
				self.die()
			
			self._state = cur_move.state
			self.directional_input = cur_move.hit_influence * (-1 if _p1_side else 1)
		en.Hit.BLCK:
			#block for blocking
			self._other.play_sound(cur_move.block)
	_parse_states([], cur_move.state, cur_move.duration)
			
func _parse_states(incoming: Array = [], incoming_state: int=en.State.FREE, incoming_duration: int = 0):
	#if _state_queue != []:
		#_debug_message(en.Level.EVENT, '_parse_states() called when _state_queue not empty')
	if incoming != []:
		for s in incoming:
			s = s.split('|')
			s = [en.State[s[0]], int(s[1])]
			_state_queue.append(s)
		return
			
	if incoming_state != en.State.FREE and incoming_duration >= 0:
		if(incoming_duration) <= 0:
			_debug_message( en.Level.ERROR, 'State with duration of 0 passed in!')
		_state_queue.append([incoming_state, incoming_duration])
		return
			
	_debug_message(en.Level.ERROR, 'Empty state passed to parse_states')
	
	return
		

#todo player locks into horiz movement when attacking
func _move_tick():
	
	_debug_message(en.Level.FRAME, 'Move Tick')
	
	_calc_bottom_y()
	
	if _grounded:
			
		if _state != en.State.JMPS:
			_jumps = _jumps_max
		
		if _state == en.State.FREE:
			$Collision_Box.disable(false)
			#X movement
			self.directional_input.x = _cur_input.x
			self.directional_input.x *= horizontal_speed
			
			#Y movement
			self.directional_input.y = 0
		
		
		if (_cur_input.y > 0):
			self.scale.y = _base_scaley * .5
			self.directional_input.x = 0
			self.directional_input.y += self._base_scaley
			
		if _state == en.State.ACTV:
			self.directional_input.x = 0
	
		
	if(not _grounded):
		$Collision_Box.disable(true)
		#get_node("Collision_Box").disabled = true
		self.directional_input.y = min(gravity + self.directional_input.y , terminal_speed)
		
		# clause for landing
		if self.directional_input.y >= -1 * _bottom_pos:
			self.directional_input.y = -1 * _bottom_pos
		
	
			
	if(_state == en.State.STUN):
		self.directional_input.x = self.directional_input.x * _friction
		
	if (_bottom_pos > 0):
		_debug_message( en.Level.ERROR, "Player's position is below the floor! Adjusting...")
		self.directional_input.y = -1 * _bottom_pos

	
	#clause to stay in stage bounds
	if(abs(self.directional_input.x + self.position.x) > _stage_bounds):
		self.directional_input.x -= (abs(self.directional_input.x + self.position.x) - _stage_bounds) * sign(self.position.x)	


	var collision_report = move_and_collide(self.directional_input)
#	if collision_report:
#		print_debug("collided with: "+ str(collision.collider.name))
	
	_sidecheck()
	
	return self.directional_input

func _box_tick():
	_debug_message(en.Level.FRAME, 'Box Tick')

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
	_debug_message(en.Level.FRAME, 'Interact Tick')
	for _i in self.get_children():
		if _i is Box:
			_i.tick()

func _process_tick():
	_debug_message(en.Level.FRAME, 'Process Tick')
	# look at list of interactions, compare highest priority value on list of interactions against other
	# if the number is uneven, process the lowest value of priorities, until all interactions are settled
		#in the case of multiple, prioritize preserving the one with the highest amount first, then duration
	
	#TODO how to tell if previous state was free or stun?
	# if bool check for if state just changed?
	$Sprite.set_texture(_state_sprites[_state])
	#_debug_messageen.Level.EVENT, "_state value: " + str(_state))
	#if _state == en.State.FREE:
	
	#elif _state == en.State.STUN:
	#	$Sprite.set_texture()
	
	
	
	if _other._state != en.State.STUN:
		self.combo = 0
		
	
	self.get_parent().update_console(self, self.combo, self._state)

func hit(incoming_move: Move_Data):
	_move_queue.append(incoming_move)

func clash(e1: Hit_Box, e2:Hit_Box):
	if not _p1_side:
		e1.queue_free()
		e2.queue_free()
		_debug_message(en.Level.EVENT, "Clash detected")


# func spawn_boxes(framedata: 2dArray):
# take in 2d array and repeatedly call below box spawning func


func spawn_box( posx = 100, posy=0, scalex=10, scaley=10, lifetime=15, damage=5,framedata: Array =[]):
	#spawn box given array of variables describing it
	var newBox  = preloadHitBox.instance()
	self.add_child(newBox)
	self.play_sound(0)
	newBox.set_box(posx, posy, scalex,scaley, lifetime)

func play_sound(sound_id:int, duration:int = 1):
	var newSFX = SFx_Audio.instance(sound_id)
	newSFX.stream = sfxs[sound_id]
	self.add_child(newSFX)
	
	var t = Timer.new()
	t.set_wait_time(duration)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	
	newSFX.play()
	yield(t, "timeout")
	newSFX.queue_free()
	t.queue_free()

	
func spawn_sprite(displacement: Vector2, duration: int, asset_index: int):
	var newSprite : Sprite_Box = preloadSprite.instance()
	self.add_child(newSprite)
	newSprite.set_sprite(displacement, duration, sprites[asset_index])


func die():
	_debug_message(en.Level.EVENT, 'I am Defeated!.')
		

func _debug_message(level, msg:String=""):
	if level is String:
		msg= level
		level = en.Level.DEBUG
	elif typeof(level) != TYPE_INT:
		msg = "Misconfigured _Debug String..." + str(level)
		print(typeof(level) != TYPE_INT)
		level = en.Level.DEBUG
	
	self.get_parent()._debug_message( level, msg, _p1_side)



func _block_check(move:Move_Data):
	var hit 
	# if unblock hit = true
	
	if _state != en.State.FREE and _state != en.State.JMPA:
		hit = true
	elif int(self._cur_input.x) == 0:
		hit = true
	elif int(self._cur_input.x) == int((int(_p1_side ) -.5 )*-2):
		hit = false
	elif int(self._cur_input.x) == int((int(_p1_side ) -.5 )*2):
		hit = true
		
	if hit == false:
		if _low_check(move):
			return en.Hit.BLCK
		_debug_message("asd")
		hit=true
	if hit == true:
		if _state == en.State.STRT or _state == en.State.ACTV:
			return en.Hit.CNTR
		if _state == en.State.JMPS and move.type==en.Type.GRB:
			return en.Hit.BLCK
		return en.Hit.HURT
	# returns 1 if t is holding back, -1 if not
	#return int(self._cur_input.x) *   (1 - 2 * int(self._p1_side)) * _low_check(move)
	#int(self._cur_input.x)
#	 is -1, 0, or 1. If it's 0, then it's failed.
#
	
func _low_check(move):
	if (move.type == en.Type.LOW and self._cur_input.y == 1) or (move.type == en.Type.HIG and self._cur_input.y == -1):
		return false
	return true
	
func _adjust_ui(value, elem):
	self.get_parent().adjust_ui(self, value, elem)
