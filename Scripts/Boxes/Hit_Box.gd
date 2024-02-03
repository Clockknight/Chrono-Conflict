class_name Hit_Box
extends Box

var overlaps = []
var hit_boxes = []
var hurt_boxes = []

var data
	
	
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

#func _on_area_entered(object: Hit_Box) -> void:
#	if (object != null):

func set_box(a,b,c,d,e, inc_data:Move_Data=null):
	super.set_box(a,b,c,d,e)
	self.data = inc_data
	if data==null:
		self.data = (Move_Data.new(0, 5, 30, 50, 0, 10, 0, 0, 2, 1, en.Type.MID))

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
			for box in hurt_boxes:
				self.get_parent()._other.hit(self.data)
				queue_free()
		elif hit_boxes != []:
			for box in hit_boxes:
				self.get_parent()._other.clash(self, box)
			
		#damag/clash function shouldnt immediately make player take damage, but instead set itself up with some variables, which can be passsed on to the manager or other functions in another tick step
		#if its p2, and the hitbox's owner is clear of these, then check for projectiles
		# if its p2, and the owner is being told to clash, then check if there's any hurtbox overlap. override if that's the casen.
		# if its p2, and the owner is being told to hit, check for hurtboxes to look for a trade,
		#if its p1, calc as normal
			
	super.tick()
	
	
func box_check():
	return "Hit_Box"
