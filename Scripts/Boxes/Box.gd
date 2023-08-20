class_name Box
extends Area2D

var _frames_remaining = -1 

func _init() -> void:
	pass


func set_box(posx, posy, scalex, scaley, lifespan):
	self.position = Vector2(posx, posy)
	self.scale = Vector2(scalex, scaley)
	self._frames_remaining = lifespan
	
func tick():
	_frames_remaining -= 1
	if _frames_remaining == 0:
		queue_free()
	elif _frames_remaining < -1:
		_frames_remaining = -1
	

func interrupt():
	self.get_parent().remove_child(self)
	
func get_shape():
	return null

func box_check():
	return null
