class_name Hit_Box
extends Box

const Move_Data = preload('res://Scripts/Data/Move_Data.gd')

var overlaps = []
var hit_boxes = []
var hurt_boxes = []

var data
	
	
func _ready():
	connect("area_entered", self, "_on_area_entered")

#func _on_area_entered(object: Hit_Box) -> void:
#	if (object != null):

func set_box(a,b,c,d,e, inc_data:Move_Data=null):
	.set_box(a,b,c,d,e)
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
				elif en.box_check() == "Hit_Box":
					hit_boxes.append(e)

		if hurt_boxes != []:
			for box in hurt_boxes:
				box.get_parent().damage(self.data)
				queue_free()
		elif hit_boxes != []:
			for box in hit_boxes:
				box.get_parent().clash(self, box)
			
		#damag/clash function shouldnt immediately make player take damage, but instead set itself up with some variables, which can be passsed on to the manager or other functions in another tick step
		#if its p2, and the hitbox's owner is clear of these, then check for projectiles
		# if its p2, and the owner is being told to clash, then check if there's any hurtbox overlap. override if that's the casen.
		# if its p2, and the owner is being told to hit, check for hurtboxes to look for a trade,
		#if its p1, calc as normal
			
	.tick()
	
func _block_check(t):
	# returns 1 if t is holding back, -1 if not
	return int(t._cur_input.x) *   (1 - 2 * int(t._p1_side)) * _low_check(t)
	
func _low_check(t):
	if data.type == en.Type.LOW:
		return int(t._cur_input.y)
	return 1
	
func box_check():
	return "Hit_Box"
