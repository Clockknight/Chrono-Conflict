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
	sprite_child = $Sprite2D
	
# function for instantiation that loads a sprite for when button is selected, unselected, and being used (pressing A / Enter / Start etc) and also the next scene to load if selected
func init(leaf_id, dimensions, leafx, leafy):
	self.highlighted_sprite = load(self.get_parent().highlighted_sprite)
	self.unhighlighted_sprite = load(self.get_parent().unhighlighted_sprite)
	self.active_sprite = load(self.get_parent().active_sprite)
	
	self.position = Vector2(leafx * dimensions[0], leafy * dimensions[1])  
	self.name = leaf_id
		
	
	$Label.text = leaf_id.trim_suffix(".tscn").trim_suffix(".val")
	_init_scale(dimensions)
	
	sprite_check()
	
func _init_scale(dimensions):
	
	self.scale = Vector2(dimensions[0], dimensions[1])
	'$Sprite2D.scale.x = dimensions[0] / sprite_child.texture.get_size().x
	$Sprite2D.scale.y = dimensions[1] / sprite_child.texture.get_size().y
	$Label.scale.x *= dimensions[0]
	$Label.scale.y *= dimensions[1]
	$Label.position.x = -.25 * $Label.size.x * dimensions[0]
	$Label.position.y = -.25 * $Label.size.y * dimensions[1]'
	
# function for checking which sprite to use
func sprite_check():
	if sprite_child != null:
		sprite_child.set_texture(active_sprite if activated else (highlighted_sprite if self.highlighted else unhighlighted_sprite))
	
# function for updating selected/unselected state that calls sprite check
func highlight_toggle():
	self.highlighted = not self.highlighted
	self.sprite_check()

func activate_toggle():
	self.activated = !self.activated
	self.sprite_check()

func report():
	return self.name  + " - " + str(activated) + "  - " + str(highlighted) 
