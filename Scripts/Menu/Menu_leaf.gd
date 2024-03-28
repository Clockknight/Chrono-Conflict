class_name MenuLeaf
extends Node2D

var sprite_child

var active_sprite
var unactive_sprite
var used_sprite

var highlighted
var activated

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_child = self.get_node("Sprite2D")
	


# function for instantiation that loads a sprite for when button is selected, unselected, and being used (pressing A / Enter / Start etc) and also the next scene to load if selected
func init(button_text, dimensions, leafx, leafy):
	self.active_sprite = load(self.get_parent().active_sprite)
	self.unactive_sprite = load(self.get_parent().unactive_sprite)
	self.used_sprite = load(self.get_parent().used_sprite)
	
	self.position = Vector2(leafx, leafy)
	$Label.text = button_text
	
# function for checking which sprite to use
func sprite_check():
	sprite_child.set_texture( used_sprite if activated else (active_sprite if self.highlighted else unactive_sprite))
	
	

	
# function for updating selected/unselected state that calls sprite check
func highlight_toggle(new_active:MenuLeaf=null):
	self.highlighted = not self.highlighted
	
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

