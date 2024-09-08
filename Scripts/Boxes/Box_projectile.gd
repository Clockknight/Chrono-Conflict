class_name Box_Projectile
extends Box_Hit

var velocityx
var velocityy
var accelx
var accely


func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))


func set_box(inc_data, parent):
	#func set_box(posx, posy, scalex, scaley, lifespan):
	super.set_box(inc_data, parent)
	velocityx = inc_data["velocityx"] * (1 if p1 else -1)
	velocityy = inc_data["velocityy"] * (1 if p1 else -1)
	accelx = inc_data["accelx"] * (1 if p1 else -1)
	accely = inc_data["accely"] * (1 if p1 else -1)
	self.position = parent.position


func subtick_move():
	# Todo the p1 has to be set when to projectile is spawned, then checked here
	velocityx += accelx
	self.position.x += velocityx

	velocityy += accely
	self.position.y += velocityy

	# todo delete if outside of horiz bounds


func box_check():
	return "Projectile"
