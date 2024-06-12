class_name Player
extends CharacterBody2D

# external classes
var i
var framedata

# Constants
const BUFFER_WINDOW = en.Constants.BUFFER_WINDOW

# Assets
var audio_levels = []
var SFx_Audio
var preloadHitBox
var preloadHurtBox
var preloadSprite
var sprites
var _base_sprite
var sfxs
var _state_sprites

# nodes
var collision: CollisionShape2D

# 2d Vectors
var directional_input = Vector2.ZERO

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
var _state_frames_left = 0
var _bottom_pos
var _base_scaley
var _base_scalex
var _stage_bounds
var _stored_x = 0
var _cur_x = 0
var _max_health
var _health
var _jumps_max
var _jumps = 0
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
var _box_queue = []
var _state_queue = []
var _input_queue = []

var _input_history = []


func _ready():
	self._base_scaley = scale.y
	self._base_scalex = scale.x
	self.collision = self.get_node("Collision_Box")
	self._health = _max_health

	load_assets()


func load_assets():
	# Should be overwritten as part of character specific script
	self.i = load("res://Data/Inputs.gd")
	self.SFx_Audio = load("res://Scenes/Assets/Audio_SFx.tscn")
	self.preloadSprite = load("res://Scenes/Boxes/Sprite_Box.tscn")
	self.preloadHitBox = load("res://Scenes/Boxes/Box_Hit.tscn")
	self.preloadHurtBox = load("res://Scenes/Boxes/Box_Hurt.tscn")


func _configure(other_player, bounds, levels):
	# player object assumes it's player 1 until otherwise stated
	_other = other_player
	_jumps = _jumps_max
	self._stage_bounds = bounds
	self.audio_levels = levels

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
	_debug_message(en.Level.FRAME, "Tick Start ============")
	# Read Inputs and save the input for this frame for later use

	# Parse inputs
	_subtick_input()
	_other._subtick_input()

	# Assign state based on inputs / interactions
	_subtick_state()
	_other._subtick_state()

	# Spawn boxes based on inputs / State
	_subtick_box()
	_other._subtick_box()

	#move self and move projectiles, which should move child boxes as well
	_subtick_move()
	_other._subtick_move()

	# Check interactions with boxes
	_subtick_interact()
	_other._subtick_interact()

	# miscellaneous processing of various actions
	_subtick_process()
	_other._subtick_process()


func _subtick_input():
	_debug_message(en.Level.FRAME, "Input Tick")
	_cur_input = step_input_process()
	step_input_interpret(_cur_input)


func step_input_process():
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
		_ninput_event = new_input[0].keycode
		_ninput_state = new_input[1]

		# TODO add check for simultaneous l/R input
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

		x = clamp(x, -1, 1)
		y = clamp(y, -1, 1)

	new_input = i.new(self, x, y, a, b, c, d)
	_cur_input = new_input.compare(_cur_input)

	return _cur_input


func step_input_interpret(input: Input_Data):
	var frame_data = null

	#Code will have to check if player is currently in active/recovery frames
	#Will have to check if previous hit landed
	#check if incoming move is OK to cancel to
	#If all are true, then:
	#-clear queue of states
	#-force new queue of states

	# Movement block (lowest priority)
	if input.input_new_down("y") and input.y < 0:
		frame_data = ["JMPS|5"]
		if self._grounded:
			self._cur_x = 0
		else:
			self._cur_x = self._stored_x

		self._stored_x = _cur_input["x"]

	return frame_data


func _subtick_state():
	_debug_message(en.Level.FRAME, "State Tick")
	# this tick is for dealing with the players' state. More specifically, a frame by frame check to see if the current state has expired, and if so, which state should be next?
	_state_frames_left -= 1
	#if (_state == en.State.FREE or _state ==en.State.JMPA) and _state_queue == []:
	#else:

	var new_state = _state_queue.pop_front()

	if _state_frames_left <= 0:
		_debug_message(en.Level.FRAME, "new_state: " + str(new_state))
		_debug_message(en.Level.FRAME, "_state_queue: " + str(_state_queue))

		if new_state == null:
			_debug_message(en.Level.FRAME, "state queue empty - returning to free")
			_state = en.State.FREE
			_state_frames_left = 0
			return
		match new_state[0]:
			# todo new states should not be queued if they are not possible
			# ie these checks should be moved to input
			# this function should just be for making the actual changes
			en.State.JMPS:
				if _jumps > 0:
					_jumps -= 1
					$Collision_Box.disable(true)
					_grounded = false
					_debug_message(en.Level.FRAME, "jump started")
					self.directional_input.y = -1 * self.vertical_speed
					step_state_adopt(new_state)
			en.State.ACTV:
				# Should tick down all the queued boxes, and spawn in any that have zero left
				var occurences
				for i in range(1, _box_queue.size()):
					var move = _box_queue.pop_front().split("|")
					occurences = int(move[1]) - 1

					if occurences <= 0:
						#spawn the box NOW
						_spawn_box(move[0])
					else:
						_box_queue.append(move[0] + "|" + str(occurences))
				step_state_adopt(new_state)

			_:
				step_state_adopt(new_state)
	else:
		_state_queue.insert(0, new_state)


func step_state_adopt(new_state_array):
	_state = new_state_array[0]
	_state_frames_left = new_state_array[1]


func step_state_process(cur_move: MoveData):
	match step_block_check(cur_move):
		en.Hit.HURT:
			self._other.play_sound(cur_move.hit, en.AudioTypes.SFX)
			_other._debug_message(en.Level.FRAME, "Damage incoming: " + str(cur_move.damage))
			_other.combo += 1
			self._health -= cur_move.damage
			var pct = float(_health / _max_health)
			_adjust_ui(pct, en.Elem.HEALTH)

			if self._health <= 0:
				self._health = 0
				self.step_die()

			self._state = cur_move.state
			self.directional_input = cur_move.hit_direction * (-1 if _p1_side else 1)
		en.Hit.BLCK:
			#block for blocking
			self._other.play_sound(cur_move.block)
	step_state_interpret([], cur_move.state, cur_move.duration)


func step_die():
	_debug_message(en.Level.EVENT, "I am Defeated!.")


func step_state_interpret(
	incoming: Array = [], incoming_state: int = en.State.FREE, incoming_duration: int = 0
):
	#if _state_queue != []:
	#_debug_message(en.Level.EVENT, 'step_state_interpret() called when _state_queue not empty')
	if incoming != []:
		for s in incoming:
			s = s.split("|")
			s = [en.State[s[0]], int(s[1])]
			_state_queue.append(s)
		return

	if incoming_state != en.State.FREE and incoming_duration >= 0:
		if (incoming_duration) <= 0:
			_debug_message(en.Level.ERROR, "State with duration of 0 passed in!")
		_state_queue.append([incoming_state, incoming_duration])
		return
	_debug_message(en.Level.ERROR, "Empty state passed to step_state_interpret")
	return


func _subtick_box():
	_debug_message(en.Level.FRAME, "Box Tick")


func _subtick_interact():
	_debug_message(en.Level.FRAME, "Interact Tick")
	for _i in self.get_children():
		if _i is Box:
			_i.tick()

	if _move_queue != []:
		_debug_message(en.Level.FRAME, "Interactions: " + str(_move_queue))
		_debug_message(en.Level.FRAME, "Processing interaction... " + str(_move_queue[0]))
		var cur_move = _move_queue.pop_front()

		while _move_queue != []:
			if cur_move.priority < _move_queue[0].priority:
				cur_move = _move_queue.pop_front()
			else:
				_move_queue.pop_front()

		step_state_process(cur_move)
	else:
		_debug_message(en.Level.FRAME, "empty _state_queue: " + str(_state_queue == []))


func hit(incoming_move: MoveData):
	_move_queue.append(incoming_move)


func clash(e1: Hit_Box, e2: Hit_Box):
	if not _p1_side:
		e1.queue_free()
		e2.queue_free()
		_debug_message(en.Level.EVENT, "Clash detected")


func step_block_check(move: MoveData):
	var hit
	# if unblock hit = true
	if _state != en.State.FREE and _state != en.State.JMPA:
		hit = true
	elif int(self._cur_input.x) == 0:
		hit = true
	elif int(self._cur_input.x) == int((int(_p1_side) - .5) * -2):
		hit = false
	elif int(self._cur_input.x) == int((int(_p1_side) - .5) * 2):
		hit = true

	if hit == false:
		if step_low_check(move):
			return en.Hit.BLCK
		hit = true
	if hit == true:
		if _state == en.State.STRT or _state == en.State.ACTV:
			return en.Hit.CNTR
		if _state == en.State.JMPS and move.type == en.Type.GRB:
			return en.Hit.BLCK
		return en.Hit.HURT
	# returns 1 if t is holding back, -1 if not
	#return int(self._cur_input.x) *   (1 - 2 * int(self._p1_side)) * step_low_check(move)
	#int(self._cur_input.x)


#	 is -1, 0, or 1. If it's 0, then it's failed.


func step_low_check(move):
	if (
		(move.type == en.Type.LOW and self._cur_input.y == 1)
		or (move.type == en.Type.HIG and self._cur_input.y == -1)
	):
		return false
	return true


func _subtick_move():
	_debug_message(en.Level.FRAME, "Move Tick")
	_calc_bottom_y()
	if _grounded:
		# todo refactor this so the repeated .xs are not necessary
		if _state == en.State.FREE:
			#Y movement
			self.directional_input.x = 0
			self.directional_input.y = 0
		if _cur_input.y > 0:
			self.scale.y = _base_scaley * .5
			self.directional_input.x = 0
			self.directional_input.y += self._base_scaley
		if _state == en.State.ACTV:
			self.directional_input.x = 0
			self.directional_input.x = 0

	if not _grounded:
		#get_node("Collision_Box").disabled = true
		self.directional_input.y = min(gravity + self.directional_input.y, terminal_speed)
		if self._state == en.State.JMPS:
			self.directional_input.x = self._cur_x * self.horizontal_speed
		elif self._state == en.State.JMPA:
			self.directional_input.x = self._stored_x * self.horizontal_speed
		# clause for landing
		if self.directional_input.y >= -1 * _bottom_pos:
			self.directional_input.y = -1 * _bottom_pos

	if _state == en.State.FREE:
		#X movement
		self.directional_input.x = _cur_input.x * horizontal_speed

	if _state == en.State.STUN:
		self.directional_input.x = self.directional_input.x * _friction

	#clause to stay in stage bounds
	if abs(self.directional_input.x + self.position.x) > _stage_bounds:
		self.directional_input.x -= (
			(abs(self.directional_input.x + self.position.x) - _stage_bounds)
			* sign(self.position.x)
		)

	var collision_report = move_and_collide(self.directional_input)
	step_move_check(collision_report)
	_calc_side()
	return self.directional_input


func step_move_check(report):
	if report and _grounded:
		var width = -collision.scale.x / 5
		_calc_ground()
		if _p1_side:
			self.position.x += width
			_grounded = true
			step_move_check(move_and_collide(Vector2.ZERO))
	if (_bottom_pos > 0) or ((_bottom_pos == 0) and (directional_input.y > 0)):
#		_debug_message( en.Level.ERROR, "Player's position is below the floor: " + str(_bottom_pos))
		_calc_ground()
	_calc_bottom_y()
	return


func _subtick_process():
	_debug_message(en.Level.FRAME, "Subtick Process")
	# look at list of interactions, compare highest priority value on list of interactions against other
	# if the number is uneven, process the lowest value of priorities, until all interactions are settled
	#in the case of multiple, prioritize preserving the one with the highest amount first, then duration
	#TODO how to tell if previous state was free or stun?
	# if bool check for if state just changed?
	$Sprite2D.set_texture(_state_sprites[_state])
	#_debug_messageen.Level.EVENT, "_state value: " + str(_state))
	#if _state == en.State.FREE:
	#elif _state == en.State.STUN:
	#	$Sprite.set_texture()
	if _other._state != en.State.STUN:
		self.combo = 0
	_update_console()


## Calls the collision box's method to figure out the bottom most pixel of this object
func _calc_bottom_y():
	_bottom_pos = self.position.y + $Collision_Box.calc_height() * abs(self.scale.y)
	self._grounded = _bottom_pos >= 0

	if _state == en.State.JMPA and self.directional_input.y < 0:
		self._grounded = false

	$Collision_Box.disable(!_grounded)


func _calc_ground():
	_calc_bottom_y()
	self.position.y -= self._bottom_pos
	if _state == en.State.JMPA:
		_state = en.State.FREE
		_jumps = 2
	_calc_bottom_y()


func _calc_side():
	if _p1_side != (self.position.x < _other.position.x):
		_p1_side = not _p1_side

	if _grounded:
		if (_p1_side and _flipped) or (not _p1_side and not _flipped):
			self.scale.x *= -1
			self._flipped = not _flipped


func _check_cancel():
	print("not implemented")
	# todo
	# Check incoming move
	# if the incoming move is higher priority, then cancel the current state and then queue new states


func _check_buffer():
	if _calc_frames_left() > BUFFER_WINDOW:
		return false
	return true


func _calc_frames_left():
	var temp = _state_frames_left

	if _state_queue != [null]:
		for i in _state_queue:
			temp += i[1]

	return temp


func _overwrite_box(move_id):
	print("not implemented")
	# todo
	# check if the current state is active or recovery
	# check if the current move has landed a hit
	# check if the overwriting move level is higher or greater than the current move's


# Should take in an id, and then pout it in the queue of boxes to create
# the queue should tick up the appearance value each time the ACTV state begins
# once a box in the queue has reached appearance 0, then it should build the box
#func _queue_box(posx = 100, posy=0, scalex=10, scaley=10, lifetime=15, damage=5):
func _queue_box(move_id):
	#spawn box given array of variables describing it

	for item in framedata[move_id]["boxes"]:
		_box_queue.append(item + framedata[move_id]["boxes"][item]["queue_info"])

	step_state_interpret(framedata[move_id]["framedata"])


func _spawn_box(move_id):
	var newBox = preloadHitBox.instantiate()
	self.add_child(newBox)
	self.play_sound(0, en.AudioTypes.SFX)
	#newBox.set_box(posx, posy, scalex,scaley, lifetime)
	newBox.set_box(10, 10, 10, 10, 10)


func play_sound(sound_id: int, audiotype: en.AudioTypes, duration: int = 1):
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
	var newSprite: Sprite_Box = preloadSprite.instantiate()
	self.add_child(newSprite)
	newSprite.set_sprite(displacement, duration, sprites[asset_index])


func _debug_message(level, msg: String = ""):
	if level is String:
		msg = level
		level = en.Level.DEBUG
	elif typeof(level) != TYPE_INT:
		msg = "Misconfigured _Debug String..." + str(level)
		print(typeof(level) != TYPE_INT)
		level = en.Level.DEBUG

	self.get_parent()._debug_message(level, msg, _p1_side)


func _adjust_ui(value, elem):
	self.get_parent().adjust_ui(self, value, elem)


func _update_console():
	var a = self
	var b = self.combo
	var c = self._state
	var d = self.directional_input
	var e = self._cur_input
	var f1 = self._cur_x
	var f2 = self._stored_x
	var g = self._grounded
	var h = self._jumps

	self.get_parent().update_console(a, b, c, d, e, f1, f2, g, h)
