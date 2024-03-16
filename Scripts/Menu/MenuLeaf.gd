class_name MenuLeaf
extends Node2D

var sprite_child

var used_scene

var highlighted_sprite
var unhighlighted_sprite
var activated_sprite

var scene_is_new
var highlighted
var activated

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_child = self.get_node("Sprite")


# function for instantiation that loads a sprite for when button is selected, unselected, and being used (pressing A / Enter / Start etc) and also the next scene to load if selected
func button_set(active_sprite, unactive_sprite, used_sprite, used_scene, scene_is_new, button_text):
	self.active_sprite = active_sprite
	self.unactive_sprite = unactive_sprite
	self.used_sprite = used_sprite
	self.used_scene = used_scene
	self.scene_is_new = scene_is_new
	$Label.text = button_text
	
# function for checking which sprite to use
func sprite_check():
	sprite_child.sprite = activated_sprite if activated else (highlighted_sprite if self.highlighted else unhighlighted_sprite)

# function for updating selected/unselected state that calls sprite check
func highlight_toggle(new_active:MenuLeaf=null):
	self.is_active = not self.is_active
	
	self.sprite_check()
	
	if new_active != null:
		new_active.highlight_toggle()

# function for being used
func use():
#	load next scene
# 	get_tree().root.add_child(simultaneous_scene)
#	update in use bool
	activated = true
#	sprite_check()

