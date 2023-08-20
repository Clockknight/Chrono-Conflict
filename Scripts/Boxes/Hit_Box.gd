class_name Hit_Box
extends Box

var test = []

	

func _ready():
	connect("area_entered", self, "_on_area_entered")

#func _on_area_entered(object: Hit_Box) -> void:
#	if (object != null):

func tick():
	#check for hurt boxes	
	test = get_overlapping_areas()
	if test != []:
		for e in test:
			if (e.box_check() == "Hurt_Box"):
				e.get_parent().damage(5, self.position,10 )
		#if this box is overlapping a hurtbox
		#report to hurtbox
		#report to own parent
		
		#otherwise
		# if hitbox seen
		#report to hitbox
		#report to own parent
	.tick()
	
	
func box_check():
	return "Hit_Box"
