extends player

func _ready():

	self.horizontal_speed = 25
	self.vertical_speed = 80.0
	self.gravity = 5.0
	self.terminal_speed = 100.0
	self._health = 10



func _interpret_inputs(values:Input_Data):
	if _state == e.State.FREE or (_state_frames_left <= BUFFER_WINDOW and _state_queue == []):
		if Input.is_action_pressed(_up_string):
			_parse_states(['JMPS|5'])
			_cur_x = _stored_x
			_stored_x = _cur_input['x']
		if Input.is_action_just_pressed(_a_string):
			spawn_box()
			_parse_states(['ACTV|15','RECV|5'])
