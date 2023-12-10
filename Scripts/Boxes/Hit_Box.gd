class_name Hit_Box
extends Box

const Move_Data = preload('../data/Move_Data.gd')
const e = preload('../data/Enums.gd')

var overlaps = []
var hit_boxes = []
var hurt_boxes = []

var data
	
	
func _init(inc_data:Move_Data = null):
	self.data = inc_data
	if data==null:
		self.data = (Move_Data.new(0, 5, 30, e.State.STUN, Vector2(500.0,0.0), self.position))


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
			for box in hurt_boxes:
				box.get_parent().damage(Move_Data.new(0, 5, 30, e.State.STUN, Vector2(500.0,0.0), self.position))
				queue_free()
		elif hit_boxes != []:
			for box in hit_boxes:
				box.get_parent().clash(self, box)
			
		#damag/clash function shouldnt immediately make player take damage, but instead set itself up with some variables, which can be passsed on to the manager or other functions in another tick step
		#if its p2, and the hitbox's owner is clear of these, then check for projectiles
		# if its p2, and the owner is being told to clash, then check if there's any hurtbox overlap. override if that's the case.
		# if its p2, and the owner is being told to hit, check for hurtboxes to look for a trade,
		#if its p1, calc as normal
			
	.tick()
	
	
func box_check():
	return "Hit_Box"
