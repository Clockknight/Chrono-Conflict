class_name Player extends CharacterBody2D

# external classes
var i
var framedata

# Constants
const BUFFER_WINDOW = ENUM.Constants.BUFFER_WINDOW
const SIMULTANEOUS_WINDOW = ENUM.Constants.SIMULTANEOUS_WINDOW
const HISTORY_WINDOW = ENUM.Constants.HISTORY_WINDOW

# Assets
var audio_levels = []
var SFx_Audio
var preloadBoxHit
var preloadBoxHurt
var preloadSprite
var preloadBoxProjectile
var sprites
var _base_sprite
var sfxs
var _state_sprites

# nodes
var collision: CollisionShape2D
var container_normals: Node
var container_projectiles: Node
var container_hurts: Node

# 2d Vectors
var directional_input = Vector2.ZERO
var current_position = Vector2.ZERO

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
var _input_tree = {}
var _last_move = ""
var _last_interacted = false

# configurations
var _debug = false
var _other
var _p1_side = true
var _flipped = false
var _grounded = false
var _state = ENUM.State.FREE
var _last_state = ENUM.State.FREE

# integers
var _state_frames_left = 0
var _bottom_pos
var _base_scaley
var _base_scalex
var _stage_bounds
var _stored_x = 0
var _jump_x = 0
var _cur_x = 0
var _max_health
var _health
var _air_actions_max
var _air_actions = 0
var _jump_velocity
var combo = 0

# floats
const _friction = .5
const _deceleration_max = .05
var horizontal_speed
var vertical_speed
var gravity
var terminal_speed

# queues
var _harm_queue = []
var _box_queue = []
var _state_queue = []
var _input_queue = []
var _immediate_queue = []


func _ready():
	self._base_scaley = scale.y
	self._base_scalex = scale.x
	self.collision = $"Box_Collision"
	self._health = _max_health
	self.container_projectiles = $"../Projectiles"
	self.container_normals = $"./Normals"
	self.container_hurts = $"./Hurts"
	
	

	load_assets()


func load_assets():
	# Should be overwritten as part of character specific script
	self.i = preload("res://Data/Input_Data.gd")
	self.SFx_Audio = load("res://Scenes/Assets/Audio_SFx.tscn")
	self.preloadSprite = load("res://Scenes/Boxes/Box_Sprite.tscn")
	self.preloadBoxHit = load("res://Scenes/Boxes/Box_Hit.tscn")
	self.preloadBoxHurt = load("res://Scenes/Boxes/Box_Hurt.tscn")
	self.preloadBoxProjectile = load("res://Scenes/Boxes/Box_Projectile.tscn")
	self._input_tree = self.framedata["tree"]


func configure(other_player, bounds, levels, xdisp, ydisp):
	# player object assumes it's player 1 until otherwise stated
	_other = other_player
	_air_actions = _air_actions_max
	self._stage_bounds = bounds
	self.audio_levels = levels
	
	current_position = Vector2(xdisp, ydisp)
	move_and_collide(current_position)

	_calc_side()

	_up_string = update_dictionary("ui_p1up", "ui_p2up")
	_down_string = update_dictionary("ui_p1down", "ui_p2down")
	_left_string = update_dictionary("ui_p1left", "ui_p2left")
	_right_string = update_dictionary("ui_p1right", "ui_p2right")
	_a_string = update_dictionary("ui_p1a", "ui_p2a")
	_b_string = update_dictionary("ui_p1b", "ui_p2b")
	_c_string = update_dictionary("ui_p1c", "ui_p2c")
	_d_string = update_dictionary("ui_p1d", "ui_p2d")


func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode in _input_dict:
			_input_queue.append([event, event.pressed])


func update_dictionary(player1_option: String, player2_option: String):
	var res

	if _p1_side:
		res = player1_option

	else:
		res = player2_option

	if InputMap.action_get_events(res).pop_front().physical_keycode == 0:
		_input_dict[InputMap.action_get_events(res).pop_front().keycode] = res
	else:
		_input_dict[InputMap.action_get_events(res).pop_front().physical_keycode] = res

	return res


func tick():
	_debug_message(ENUM.Level.FRAME, "Tick Start ============")
	# Read Inputs and save the input for this frame for later use

	# Parse inputs
	_input_subtick()
	_other._input_subtick()

	# Assign state based on inputs / interactions
	_state_subtick()
	_other._state_subtick()

	# Spawn boxes based on inputs / State
	_box_subtick()
	_other._box_subtick()


	# Check interactions with boxes
	_interact_subtick()
	_other._interact_subtick()
	
	#move self and move projectiles, which should move child boxes as well
	_move_subtick()
	_other._move_subtick()

	# miscellaneous processing of various actions
	_process_subtick()
	_other._process_subtick()


func _input_subtick():
	_debug_message(ENUM.Level.FRAME, "Input Tick")
	_cur_input = _input_step_process()
	var move_name = _input_step_interpret(_cur_input)
	if move_name:
		_input_step_addon(move_name)
		
	else:
		_input_step_influence()
	


func _input_step_process():
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
		_debug_message(ENUM.Level.FRAME, "Processing input queue...")
	
		
	while _input_queue != []:
		new_input = _input_queue.pop_front()
		_ninput_event = new_input[0].keycode
		_ninput_state = new_input[1]

		match _input_dict[_ninput_event]:
			_up_string:
				y -= int(_ninput_state) * 2 - 1
			_down_string:
				y += int(_ninput_state) * 2 - 1
			_left_string:
				x -= int(_ninput_state) * 2 - 1
			_right_string:
				x += int(_ninput_state) * 2 - 1
			_a_string:
				a = _ninput_state
			_b_string:
				b = _ninput_state
			_c_string:
				c = _ninput_state
			_d_string:
				d = _ninput_state

	# TODO add check for player holding down the button on keyboard
		x = clamp(x, -1, 1)
		y = clamp(y, -1, 1)
	# this check doesnt right if the inputs read
	# 4
	# 46...
	# since  the new 6 held will overwrite both
	# instead of above solution, we should 
	# check each input to see if it is a change from the previous input.
	# eg if down is pressed, if down is already pressed, ignore. If not, then is up pressed? if yes, set both to false
	# if not, then set down to true.

	new_input = self.i.new(self, x, y, a, b, c, d)

	return new_input.compare(_cur_input)


# Return move if valid
# if no valid motion with inputs pressed, return 5x
# else return null
func _input_step_interpret(input: Input_Data):
	
	var tree = framedata["tree"]
	var framedata_name = null
	var down = ""
	var valid = ""
	
	if not input.input_new_button():
		var direction = int(input.get_direction(self._p1_side)[-1])
		if direction >= 7 and _air_actions > 0 and self._state != ENUM.State.JMPB:
			_stored_x = input.x
			_air_actions -= 1
			return 'jump'
		return null
	
	
	down = input.get_down().reverse()

	if down != "":
		for motion in tree:
			valid = _input_help_validate_attack(down, tree[motion], motion)
			if valid:
				framedata_name = motion + valid
				break
		if framedata_name == null:
			for c in down:
				framedata_name = "5" + c
				break

	# then, framedata_name will equal whatever entry exists in framedata for Mx
	return framedata_name


# function should return
func _input_help_validate_attack(down: String, valid: String, motion: String):
	for down_button in down:
		if valid.contains(down_button):
			if _input_help_get_motion(motion):
				return down_button

	return ""


# function checks if motion given was input
func _input_help_get_motion(motion: String):
	var history = self._cur_input.report(HISTORY_WINDOW, self._p1_side, true, false)
	var i = motion.length() - 1

	if not history.begins_with(motion[i]):
		return false

	for char in history:
		if int(motion[i]) % 2 == 0:
			if ENUM.Directions[motion[i]].contains(char):
				i -= 1
		else:
			if motion[i] == char:
				i -= 1

		if i < 0:
			return true

	return false
	# get a history
	# current input should be the same as the last input required
	# check the rest of the directions


# Step to cancel into or queue up frame data of given move
func _input_step_addon(move_name):
	# First check if the inputted move cancels into the next
	
	
	if _input_check_cancel(move_name):
		_input_queue_box(move_name)

		# check if the current state is active or recovery
		# check if the current move has landed a hit
		# check if the overwriting move level is higher or greater than the current move's
	# then check if the current move can be buffered in, or otherwise needs to create a box
	if _input_check_buffer():
		_input_queue_box(move_name)
		#_input_influence_move(move_name)


func _input_check_cancel(incoming_move):
	if _last_interacted and _state == ENUM.State.RECV:
		# return dict[cur_move].prio < dict[incoming_move].prio
		return framedata[_last_move].level < framedata[incoming_move].level

	return false


func _input_check_buffer():
	if _calc_frames_left() > BUFFER_WINDOW:
		return false
	return true


func _input_clear_queue():
	_box_queue = []
	_state = ENUM.State.FREE
	_state_frames_left = 1

func _input_step_influence():
	#This step assumes that the player is not attempting to use an attack
	_move_calc_bottom_y()
	if _grounded and self._state > ENUM.State.JMPB:
		_air_actions = _air_actions_max
		if _state == ENUM.State.FREE or  _state == ENUM.State.ACTV:
			#Y movement
			self.directional_input.x = 0
			self.directional_input.y = 0

		
#todo figure out jumping every frame

	if _state == ENUM.State.FREE:
		#X movement
		self.directional_input.x = _cur_input.x * horizontal_speed
		
	if _state == ENUM.State.STUN:
		self.directional_input.x = self.directional_input.x * _friction

	#clause to stay in stage bounds
	if abs(self.directional_input.x + self.position.x) > _stage_bounds:
		self.directional_input.x -= (
			(abs(self.directional_input.x + self.position.x) - _stage_bounds)
			* sign(self.position.x)
		)

# Should take in an id, and then pout it in the queue of boxes to create
# the queue should tick up the appearance value each time the ACTV state begins
# once a box in the queue has reached appearance 0, then it should build the box
#func _input_queue_box(posx = 100, posy=0, scalex=10, scaley=10, lifetime=15, damage=5):
func _input_queue_box(move_id):
	_last_move = move_id
	for item in framedata[move_id]["boxes"]:
		_box_queue.append(item + "|" + str(framedata[move_id]["boxes"][item]["queue"]))
	_state_step_interpret(framedata[move_id]["framedata"])
	
	# TODO should add changes to directional input based on the move (default should be 2dVector ZERO)
		
	
	# Ducking block
	#if _cur_input.y > 0:
	#elif _cur_input.y < 0 and _air_actions > 0:
		#self.directional_input.y =-1 * _jump_velocity
		#_air_actions -= 1
		

func _state_subtick():
	_debug_message(ENUM.Level.FRAME, "State Tick")
	# this tick is for dealing with the players' state. More specifically, a frameN by frame check to see if the current state has expired, and if so, which state should be next?
	_state_frames_left -= 1

	var new_state = _state_queue.pop_front()

	if _state_frames_left <= 0:
		_debug_message(ENUM.Level.FRAME, "new_state: " + str(new_state))
		_debug_message(ENUM.Level.FRAME, "_state_queue: " + str(_state_queue))

		if new_state == null:
			_debug_message(ENUM.Level.FRAME, "state queue empty - returning to free")
			if self._state >= ENUM.State.JMPB:
				_jump_x = _stored_x
				_stored_x = 0
				self._state = ENUM.State.JMPF
			else:
				self._state = ENUM.State.FREE
			_state_frames_left = 0
			return
			
		if new_state[0] != self._state:
			var occurences
			for i in range(0, _box_queue.size()):
				var move = _box_queue.pop_front().split("|")
				occurences = int(move[1]) - 1

				if occurences <= 0:
					_last_interacted = false
					_immediate_queue.append(move[0])
				else:
					_box_queue.append(move[0] + "|" + str(occurences))
					
		match new_state[0]:
				# new states should not be queued if they are not possible
				# this function should just be for making the actual changes
				ENUM.State.JMPS:
					if _air_actions > 0:
						_air_actions -= 1
						$Box_Collision.disable(true)
						_grounded = false
						_debug_message(ENUM.Level.FRAME, "jump started")
						self.directional_input.y = -1 * self.vertical_speed
						_state_step_adopt(new_state)
				ENUM.State.STUN:
					# If you're getting stunned, get rid of everything else.
					_box_queue = []
				_:
					_state_step_adopt(new_state)

	else:
		_state_queue.insert(ENUM.State.FREE, new_state)


func _state_step_adopt(new_state_array):
	_last_state = _state
	_state = new_state_array[0]
	_state_frames_left = new_state_array[1]


func _interact_step_process(cur_move):
	print(_state_check_block(cur_move))
	match _state_check_block(cur_move):
		# If the hit lands, take the damage
		ENUM.Hit.HURT:
			_other.acknowledge_hit(cur_move)
			self._health -= cur_move.damage
			var pct = float(_health / _max_health)
			_adjust_ui(pct, ENUM.Elem.HEALTH)

			if self._health <= 0:
				self._health = 0
				self.state_step_die()

			self._state = ENUM.State[cur_move.state]
			self._state_frames_left = cur_move.hitdur
			self.directional_input = Vector2(cur_move.hitx * (-1 if _p1_side else 1), cur_move.hity)
		ENUM.Hit.BLCK:
		# If blocked, let the other player know
		# TODO include data like chip damage, block pushback, etc
			_other.acknowledge_block(cur_move)
	_state_step_interpret([], ENUM.State[cur_move.state], cur_move.hitdur)


func _state_check_block(move):
	var hit
	# if unblock hit = true
	if _state != ENUM.State.FREE and _state != ENUM.State.JMPF:
		hit = true
	elif int(self._cur_input.x) == 0:
		hit = true
	elif int(self._cur_input.x) == int((int(_p1_side) - .5) * -2):
		hit = false
	elif int(self._cur_input.x) == int((int(_p1_side) - .5) * 2):
		hit = true

	if hit == false:
		if step_low_check(move):
			return ENUM.Hit.BLCK
		hit = true
	if hit == true:
		if _state == ENUM.State.STRT or _state == ENUM.State.ACTV:
			return ENUM.Hit.CNTR
		if _state == ENUM.State.JMPS and ENUM.Type[move.type] == ENUM.Type.GRB:
			return ENUM.Hit.BLCK
		return ENUM.Hit.HURT
	# returns 1 if t is holding back, -1 if not



func acknowledge_hit(cur_move):
	play_sound(cur_move.hitid, ENUM.AudioTypes.SFX)
	_debug_message(ENUM.Level.FRAME, "Damage incoming: " + str(cur_move.damage))
	combo += 1
	_last_interacted = true


func acknowledge_block(cur_move):
	play_sound(cur_move.blockid, ENUM.AudioTypes.SFX)
	_last_interacted = true


func state_step_die():
	_debug_message(ENUM.Level.EVENT, "I am Defeated!.")


func _state_step_interpret(
	incoming: Array = [], incoming_state: int = ENUM.State.FREE, incoming_duration: int = 0
):
	# Case for multiple states being queued, think attacks (startup, active, etc)
	if incoming != []:
		for new_state in incoming:
			new_state = new_state.split("|")
			new_state = [ENUM.State[new_state[0]], int(new_state[1])]
			_state_queue.append(new_state)
		return

	if incoming_state != ENUM.State.FREE and incoming_duration >= 0:
		if (incoming_duration) <= 0:
			_debug_message(ENUM.Level.ERROR, "State with duration of 0 passed in!")
		_state_queue.append([incoming_state, incoming_duration])
		return
	_debug_message(ENUM.Level.ERROR, "Empty state passed to _state_step_interpret")
	return

func _move_subtick():
	_debug_message(ENUM.Level.FRAME, "Move Tick")
	
	_move_step_state()
	var collision_report = move_and_collide(self.directional_input)
	self.current_position += self.directional_input
	_move_step_check(collision_report)
	_calc_side()
	_move_step_projectiles()
	return self.directional_input


func _move_step_state():
	
	match self._state:
		ENUM.State.JMPB:
			self.directional_input = Vector2.ZERO
		ENUM.State.JMPJ:
			self.directional_input = Vector2(_stored_x * horizontal_speed, -1 * _jump_velocity)
			self.collision.disabled = true
			_stored_x = 0
			
		#ENUM.State.FREE:
			#self.directional_input = Vector2
			
	if not _grounded:
		self.directional_input[1] += gravity

func _move_step_check(report):
	_move_calc_ground()
	
	if _grounded:
		var width = -collision.scale.x / 5
		_grounded = true
		if _p1_side:
			#self.position.x += width
			#self.current_position[0] += width
			## _move_step_check(move_and_collide(Vector2.ZERO))
			
			# skeleton of landing lag
			if self._state == ENUM.State.JMPA:
				self._state = ENUM.State.JMPR
			elif self._state > ENUM.State.JMPB:
				self._state = ENUM.State.FREE
	if (_bottom_pos > 0) or ((_bottom_pos == 0) and (directional_input.y > 0)):
		_move_calc_ground()
	_move_calc_bottom_y()
	return


func _move_calc_ground():
	_move_calc_bottom_y()
	
	
	self._grounded = _bottom_pos >= 0

	if _state == ENUM.State.JMPA:
		self._grounded = false

	$Box_Collision.disable(!_grounded)
	
	if self._grounded:
		self.current_position[1] -= self._bottom_pos
		self.position.y -= self._bottom_pos
		if self._state == ENUM.State.JMPF:
			_state = ENUM.State.FREE
		if self._state < ENUM.State.JMPB:
			_air_actions = _air_actions_max
	_move_calc_bottom_y()


## Calls the collision box's method to figure out the bottom most pixel of this object. Also evaluates if the player is grounded.
func _move_calc_bottom_y():
	_bottom_pos = self.position.y + ($Box_Collision.calc_height() + $Box_Collision.position.y) * abs(self.scale.y)
	


func _move_step_projectiles():
	for box in container_projectiles.get_children():
		box.subtick_move()

func _box_subtick():
	_debug_message(ENUM.Level.FRAME, "Box Tick")
	var temp
	for move in _immediate_queue:
		temp = move.split("-")
		_immediate_queue.erase(move)
		_box_spawn_box(temp[0], temp[1])
		
	_box_subtick_each()
	
	


func _box_spawn_box(move_id, box_no):
	var movedata = framedata[move_id]
	var newBox
	match movedata["type"]:
		"projectile":
			newBox = _box_produce_projectile()
		"normal":
			newBox = _box_produce_normal()
		"hurt":
			newBox = _box_produce_hurt()
	self.play_sound(0, ENUM.AudioTypes.SFX)
	#newBox.set_box(posx, posy, scalex,scaley, lifetime)
	newBox.set_box(movedata["boxes"][move_id + "-" + str(box_no)], self)


func _box_produce_projectile():
	var obj = self.preloadBoxProjectile.instantiate()
	container_projectiles.add_child(obj)
	return obj


func _box_produce_normal():
	var obj = self.preloadBoxHit.instantiate()
	container_normals.add_child(obj)
	return obj


func _box_produce_hurt():
	var obj = self.preloadBoxHurt.instantiate()
	container_hurts.add_child(obj)
	return obj
	
	
func _box_subtick_each():
	for _n in container_normals.get_children():
		if _n is Box:
			_n.tick()

	for _p in container_projectiles.get_children():
		_p.tick()


func _interact_subtick():
	_debug_message(ENUM.Level.FRAME, "Interact Tick")

	if _harm_queue != []:
		_debug_message(ENUM.Level.FRAME, "Interactions: " + str(_harm_queue))
		_debug_message(ENUM.Level.FRAME, "Processing interaction... " + str(_harm_queue[0]))
		var cur_move = _harm_queue.pop_front()

		while _harm_queue != []:
			if cur_move.priority < _harm_queue[0].priority:
				cur_move = _harm_queue.pop_front()
			else:
				_harm_queue.pop_front()
				
		_interact_step_process(cur_move)
		
	else:
		_debug_message(ENUM.Level.FRAME, "empty _state_queue: " + str(_state_queue == []))


func interact_hit(incoming_move):
	_harm_queue.append(incoming_move)


func clash(e1: Box_Hit, e2: Box_Hit):
	if not _p1_side:
		e1.queue_free()
		e2.queue_free()
		_debug_message(ENUM.Level.EVENT, "Clash detected")


#	 is -1, 0, or 1. If it's 0, then it's failed.


func step_low_check(move):
	if (
		(ENUM.Type[move.type] == ENUM.Type.LOW and self._cur_input.y == 1)
		or (ENUM.Type[move.type] == ENUM.Type.HIG and self._cur_input.y == -1)
	):
		return false
	return true





func _process_subtick():
	_debug_message(ENUM.Level.FRAME, "Subtick Process")
	#TODO last state was stun + current state = free then set animation to fake recovery
	$Sprite/AnimationPlayer.play("idle")
	if _other._state != ENUM.State.STUN:
		self.combo = 0
		
	_update_console()


func _calc_side():
	if _p1_side != (self.position.x < _other.position.x):
		_p1_side = not _p1_side

	if _grounded:
		if (_p1_side and _flipped) or (not _p1_side and not _flipped):
			self.scale.x *= -1
			self._flipped = not _flipped


func _calc_frames_left():
	var temp = _state_frames_left

	for queued_state in _state_queue:
		if queued_state != null:
			temp += queued_state[1]

	return temp


func play_sound(sound_id: int, audiotype: ENUM.AudioTypes, duration: int = 1):
	var newSFX = SFx_Audio.instantiate(sound_id)
	newSFX.stream = sfxs[sound_id]
	self.add_child(newSFX)

	var t = Timer.new()
	t.set_wait_time(duration)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()

	newSFX.set_volume_db(
		(newSFX.get_volume_db() + 80) * audio_levels[0] * audio_levels[audiotype] - 80
	)

	newSFX.play()
	await t.timeout
	newSFX.queue_free()
	t.queue_free()


func spawn_sprite(displacement: Vector2, duration: int, asset_index: int):
	var newSprite: Box_Sprite = preloadSprite.instantiate()
	self.add_child(newSprite)
	newSprite.set_sprite(displacement, duration, sprites[asset_index])

func _debug_message(level, msg: String = ""):
	if level is String:
		msg = level
		level = ENUM.Level.DEBUG
	elif typeof(level) != TYPE_INT:
		msg = "Misconfigured _Debug String..." + str(level)
		print(typeof(level) != TYPE_INT)
		level = ENUM.Level.DEBUG

	$"../.."._debug_message(level, msg, _p1_side)


func _adjust_ui(value, elem):
	$"../..".adjust_ui(self, value, elem)


func _update_console():
	var player = self
	var combocount = self.combo
	var state = self._state
	var direction = self.directional_input
	var input = self._cur_input
	var storedx = self._stored_x
	var xposition = self.current_position[0]
	var yposition = self._bottom_pos
	var grounded = self._grounded
	var jumps = self._air_actions
	var lastmove = self._last_move
	var interacted = self._last_interacted
	var boxqueue = str(self._box_queue)

	$"../..".update_console(player, combocount, state, direction, input, storedx, xposition, yposition, grounded, jumps, lastmove, interacted,boxqueue)
