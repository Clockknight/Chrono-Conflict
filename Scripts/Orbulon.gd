extends player

func _ready():

	self.horizontal_speed = 25
	self.vertical_speed = 80.0
	self.gravity = 5.0
	self.terminal_speed = 100.0
	self._health = 10



func _interpret_inputs(values:Input_Data):
	if _state == e.State.FREE or (_state_frames_left <= BUFFER_WINDOW and _state_queue == []):
		
		var frame_data = null
		
		
		# Movement block (lowest priority)		
		if Input.is_action_pressed(_up_string):
			frame_data = ['JMPS|5']
			_cur_x = _stored_x
			_stored_x = _cur_input['x']
			
		# Normal Block
		if Input.is_action_just_pressed(_a_string):
			spawn_box()
			frame_data = ['ACTV|15','RECV|5']

		#Command Normal Block
		# if newest input data has forward and also a, use a different move
		
		# Special Block
		
		# Super Block

		if frame_data != null:
			_parse_states(frame_data)
