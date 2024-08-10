class_name Box_Projectile
extends Box_Hit

var velocityx
var velocityy
var accelx
var accely


func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))


func set_box(inc_data):
	#func set_box(posx, posy, scalex, scaley, lifespan):
	super.set_box(inc_data)
	velocityx = inc_data["velocityx"]
	velocityy = inc_data["velocityy"]
	accelx = inc_data["accelx"]
	accely = inc_data["accely"]


func tick():
	super.tick()
	velocityx += accelx
	self.position.x += velocityx

	velocityy += accely
	self.position.y += velocityy
	# delete if outside of horiz bounds


func box_check():
	return "Box_Projectile"
