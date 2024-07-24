class_name Box_Projectile
extends Box_Hit

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))


#func _on_area_entered(object: Hit_Box) -> void:
#	if (object != null):


func set_box(inc_data):
	#func set_box(posx, posy, scalex, scaley, lifespan):
	super.set_box(inc_data)
	self.data = inc_data
	"
func _init(priority: int, damage: int, duration: int, 
hit_dir_x, hit_dir_y, blk_dir_x, blk_dir_y, whiff_id, block_id, hit_id, type:int, state: int=en.State.STUN):"


func tick():
	super.tick()
	



func box_check():
	return "Box_Projectile"
