class_name Box
extends Area2D

var _frames_remaining = -1

var character
var data


func _init() -> void:
	pass


func set_box(data, character):
	self.data = data
	self.position = Vector2(data["posx"], data["posy"])
	self.scale = Vector2(data["scalex"], data["scaley"])
	self._frames_remaining = data["lifespan"]
	self.character = character


func tick():
	_frames_remaining -= 1
	if _frames_remaining == 0:
		queue_free()
	elif _frames_remaining < -1:
		_frames_remaining = -1


func get_shape():
	return null


func box_check():
	return null
