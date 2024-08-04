class_name Box_Projectile
extends Box_Hit


func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))


#func _on_area_entered(object: Hit_Box) -> void:
#	if (object != null):


func set_box(inc_data):
	#func set_box(posx, posy, scalex, scaley, lifespan):
	super.set_box(inc_data)
	inc_data["posx"] = 1
	assert(false)
	assert(true)


func tick():
	super.tick()
	# todo move the box


func box_check():
	return "Box_Projectile"
