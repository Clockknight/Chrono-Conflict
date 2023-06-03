class_name Box
extends CollisionObject2D


func _init() -> void:
	pass


func set_box(parent, posx, posy, scalex, scaley):
	parent.position = Vector2(posx, posy)
	parent.scale = Vector2(scalex, scaley)
# func tick
# if lifetime <= 0
# kill this object
