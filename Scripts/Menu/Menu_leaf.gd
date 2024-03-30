class_name MenuLeaf
extends Node2D

var sprite_child

var highlighted_sprite
var unhighlighted_sprite
var active_sprite

var highlighted = false
var activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_child = self.get_child(0)
	


# function for instantiation that loads a sprite for when button is selected, unselected, and being used (pressing A / Enter / Start etc) and also the next scene to load if selected
func init(button_text, dimensions, leafx, leafy):
	self.highlighted_sprite = load(self.get_parent().highlighted_sprite)
	self.unhighlighted_sprite = load(self.get_parent().unhighlighted_sprite)
	self.active_sprite = load(self.get_parent().active_sprite)
	
	self.position = Vector2(leafx, leafy)
	$Label.text = button_text
	
	sprite_check()
	
# function for checking which sprite to use
func sprite_check():
	sprite_child.set_texture(active_sprite if activated else (highlighted_sprite if self.highlighted else unhighlighted_sprite))
	print(report())
	
	

	
# function for updating selected/unselected state that calls sprite check
func highlight_toggle():
	self.highlighted = not self.highlighted
	self.sprite_check()

# function for being used
func use():
#	load next scene
# 	get_tree().root.add_child(simultaneous_scene)
#	update in use bool
	activated = true
#	sprite_check()

func report():
	return self.name  + " - " + str(activated) + "  - " + str(highlighted) 
