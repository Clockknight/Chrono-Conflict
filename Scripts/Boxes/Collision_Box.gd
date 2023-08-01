class_name Collision_Box
extends CollisionObject2D

var parent

func set_box(posx, posy, scalex, scaley, lifespan):
	self.position = Vector2(posx, posy)
	self.scale = Vector2(scalex, scaley)
	self._frames_remaining = lifespan
	parent = self.get_parent()
	
	
func calc_height():
	#print("ping")
	#print(self.get_child(0).shape.extents.y)
	#print(self.get_child(0).scale.y)
	#print(self.get_child(0).shape.extents.y * self.get_child(0).scale.y)
	return self.shape.extents.y * self.scale.y
	
	
func get_box():
	return $Box_Shape
#func _init() -> void:
	
