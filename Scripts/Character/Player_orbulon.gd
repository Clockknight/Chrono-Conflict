class_name Orbulon
extends Player


func _ready():
	self.horizontal_speed = 25
	self.vertical_speed = 80.0
	self.gravity = 10
	self.terminal_speed = 100.0
	self._jumps_max = 2

	self._max_health = 10.0

	super._ready()


func load_assets():
	var temp = "res://Data/framedata_orbulon.cfg"
	if FileAccess.file_exists(temp):
		temp = FileAccess.get_file_as_string(temp)
		self.framedata = JSON.parse_string(temp)

	self.sprites = [load("res://sprites/pow.png")]
	self._base_sprite = load("res://sprites/icon.png")
	self.sfxs = [
		load("res://Sound/whiff.mp3"), load("res://Sound/hit.mp3"), load("res://Sound/block.mp3")
	]
	self._state_sprites = [
		_base_sprite,  #0
		_base_sprite,  #1
		_base_sprite,  #2
		_base_sprite,  #3
		load("res://sprites/stunned.png"),  #4
		_base_sprite,  #5
		_base_sprite,  #6
		_base_sprite,  #7
		_base_sprite,  #8
		_base_sprite,  #9
		_base_sprite  #10
	]

	super.load_assets()
