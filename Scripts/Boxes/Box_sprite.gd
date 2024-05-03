class_name Sprite_Box
extends Box


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sprite(displacement: Vector2, duration: int, image_texture):
	self.position += displacement
	self._frames_remaining = duration
	$Sprite2D.set_texture(image_texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
