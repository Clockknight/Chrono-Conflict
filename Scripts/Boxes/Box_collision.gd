class_name Box_Collision
extends Box

var parentcharacter


func set_box(posx, posy, scalex, scaley, lifespan):
	self.position = Vector2(posx, posy)
	self.scale = Vector2(scalex, scaley)
	self._frames_remaining = lifespan
	parentcharacter = self.get_parent()


func calc_height():
	return self.shape.extents.y * self.scale.y



func disable(disable_toggle):
	#if not disable_toggle:
		#print("collision boxes set to be enabled" + $"../..".name)
		
	#self.disabled = disable_toggle
	self.visible = not disable_toggle

func get_box():
	return "Collision"
