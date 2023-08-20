class_name Hit_Box
extends Box

var overlaps = []
var hit_boxes = []
var hurt_boxes = []

	

func _ready():
	connect("area_entered", self, "_on_area_entered")

#func _on_area_entered(object: Hit_Box) -> void:
#	if (object != null):

func tick():
	#check for hurt boxes	
	overlaps = get_overlapping_areas()
	if overlaps != []:
		for e in overlaps:
			if e.get_parent() != self.get_parent():
				if (e.box_check() == "Hurt_Box"):
					hurt_boxes.append(e)
				elif e.box_check() == "Hit_Box":
					hit_boxes.append(e)

		if hurt_boxes != []:
			for e in hurt_boxes:
				e.get_parent().damage(5, self.position,10 )
				queue_free()
		elif hit_boxes != []:
			for e in hit_boxes:
				e.get_parent().clash(self, e)
			
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
