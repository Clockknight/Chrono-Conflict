class_name Box
extends Node2D


func _init() -> void:
	pass


func box_set(posx, posy, scalex, scaley):
	var parent = self.get_owner()
	parent.position = Vector2(posx, posy)
	parent.scale = Vector2(scalex, scaley)
# func tick
# if lifetime <= 0
# kill this object
