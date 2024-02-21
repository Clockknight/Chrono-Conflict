extends Node2D

var sprite_child


var active_sprite
var unactive_sprite
var used_sprite

var used_scene

var scene_is_new
var is_active
var button_using

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_child = self.get_node("Sprite")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# function for instantiation that loads a sprite for when button is selected, unselected, and being used (pressing A / Enter / Start etc) and also the next scene to load if selected
func button_set(active_sprite, unactive_sprite, used_sprite, used_scene, scene_is_new):
	self.active_sprite = active_sprite
	self.unactive_sprite = unactive_sprite
	self.used_sprite = used_sprite
	self.used_scene = used_scene
	self.scene_is_new = scene_is_new
	
# function for checking which sprite to use
func sprite_check():
	self.sprite = used_sprite if button_using else (active_sprite if self.button_is_active else unactive_sprite)

# function for updating selected/unselected state that calls sprite check
func active_toggle(new_active=null):
	self.is_active = not self.is_active
	
	self.sprite_check()
	
	if new_active != null:
		new_active.active_toggle()

# function for being used
# func use()
#	load next scene
#	update in use bool
#	sprite_check()

