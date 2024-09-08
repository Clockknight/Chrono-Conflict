class_name Box
extends Area2D

var _frames_remaining
var character
var data
var p1


func _init() -> void:
	pass


func set_box(indata, incharacter):
	self.data = indata
	self.position = Vector2(data["posx"], data["posy"])
	self.scale = Vector2(data["scalex"], data["scaley"])
	self._frames_remaining = data["lifespan"]
	self.character = incharacter
	self.p1 = incharacter._p1_side
	self.scale /= incharacter.scale


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
