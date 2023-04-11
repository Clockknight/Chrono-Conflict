extends player

func _ready():
	self.preloadedAssets = []
	self.horizontal_speed = 25.0
	self.vertical_speed = 80.0
	self.gravity = 5.0
	self.terminal_speed = 100.0
	

func _box_tick():
	if Input.is_action_just_pressed(_a1_string):
		_debug_message("Success!")
		.spawn_box()

func _interact_tick():
	self.gravity = self.gravity	
	#_debug_message("Success!")



