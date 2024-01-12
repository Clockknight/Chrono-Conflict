extends player

func _ready():

	self.horizontal_speed = 25
	self.vertical_speed = 80.0
	self.gravity = 5.0
	self.terminal_speed = 100.0
	
	self._max_health = 10.0
	
	preloadSprite = preload("res://Scenes/Boxes/Sprite_Box.tscn")
	sprites = [preload("res://sprites/pow.png")]
	_base_sprite = preload("res://sprites/icon.png")
	sfxs = [
		preload("res://Sound/whiff.mp3"), 
		preload("res://Sound/hit.mp3"), 
		preload("res://Sound/block.mp3")]
	_state_sprites = [
	_base_sprite, #0
	_base_sprite, #1
	_base_sprite, #2
	_base_sprite, #3
	preload("res://sprites/stunned.png"), #4
	_base_sprite, #5
	_base_sprite, #6
	_base_sprite] #7
	
	._ready()



func _interpret_inputs(input:Input_Data):
	if _state == en.State.FREE or (_state_frames_left <= BUFFER_WINDOW and _state_queue == []):
		
		var frame_data = null
		
		frame_data = ._interpret_inputs(input)
			
		# Normal Block
		if input.a == true:
			spawn_box()
			frame_data = ['ACTV|15','RECV|5']

		#Command Normal Block
		if input.a == true and input.x *  int(_p1_side) > 0:
			spawn_box()
			frame_data = ['ACTV|15','RECV|5']
		
		
		# Special Block
		
		# Super Block

		if frame_data != null:
			_parse_states(frame_data)
