extends player

func _ready():
	self.preloadedAssets = []
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
	

func _interact_tick():
	self.gravity = self.gravity	
	# todo:
	# create a hurtbox
	# find all boxes touching hurtbox
	# filter out to hitboxes
		# How to deal with fireball and punch hitting at same time?
	# run interrupt on one of those hitboxes
		# How to deal with attacks that have multiple boxes but have the same properties? eg cammy dp, what if someone got hit by the edge box on one frame, then a deeper one on the second?
		# this should delete all boxes related to that attack and return DMG
		
	



