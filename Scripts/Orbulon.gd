extends player

func _ready():

	self.horizontal_speed = 25
	self.vertical_speed = 80.0
	self.gravity = 5.0
	self.terminal_speed = 100.0
	self._health = 10



func _interpret_inputs(input:Input_Data):
	if _state == e.State.FREE or (_state_frames_left <= BUFFER_WINDOW and _state_queue == []):
		
		var frame_data = null
		
		_debug_message(str(input.report(false, 1)))
		
		# Movement block (lowest priority)		
		if input.y < 0:
			frame_data = ['JMPS|5']
			_cur_x = _stored_x
			_stored_x = _cur_input['x']
			
		# Normal Block
		if input.a == true:
			spawn_box()
			frame_data = ['ACTV|15','RECV|5']

		#Command Normal Block
		if input.a == true and input.x *  int(_p1_side) > 0:
			spawn_box()
			spawn_box()
			frame_data = ['ACTV|15','RECV|5']
		
		
		# Special Block
		
		# Super Block

		if frame_data != null:
			_parse_states(frame_data)
