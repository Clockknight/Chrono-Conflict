class_name Box
extends CollisionObject2D

var _frames_remaining = -1
var parent

func _init() -> void:
	pass


func set_box(posx, posy, scalex, scaley, lifespan):
	self.position = Vector2(posx, posy)
	self.scale = Vector2(scalex, scaley)
	self._frames_remaining = lifespan
	parent = self.get_parent()
	
	
func tick():
	_frames_remaining -= 1
	if _frames_remaining <= 0:
		parent.remove_child(self)
	

func interrupt():
	parent.remove_child(self)
