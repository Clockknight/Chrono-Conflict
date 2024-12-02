class_name Evilorbulon 
extends Player

func _ready():
	self.horizontal_speed = 25
	self.gravity = 10
	self.terminal_speed = 100.0
	self._air_actions_max = 6
	self._jump_velocity = 100.0

	self._max_health = 10.0

	super._ready()



func load_assets():
	var temp = "res://Data/framedata_orbulon.cfg"
