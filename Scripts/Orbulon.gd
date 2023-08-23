extends player

func _ready():

	self.horizontal_speed = 25.0
	self.vertical_speed = 80.0
	self.gravity = 5.0
	self.terminal_speed = 100.0
	

func _box_tick():
	for _i in self.get_children():
		if _i is Box:
			_i.tick()
	#if Input.is_action_pressed(_a1_string):
	if Input.is_action_just_pressed(_a1_string):
		.spawn_box()
