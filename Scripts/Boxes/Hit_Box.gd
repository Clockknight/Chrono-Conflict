class_name Hit_Box
extends Box

var test = []

func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(object: Hit_Box) -> void:
	test.append(object)
	print("!!!!")

func tick():
	#check for hurt boxes	
	test = get_overlapping_areas()
	if (test != []):
		print(test)
		#if this box is overlapping a hurtbox
		#report to hurtbox
		#report to own parent
		
		#otherwise
		# if hitbox seen
		#report to hitbox
		#report to own parent
	.tick()
	
	
