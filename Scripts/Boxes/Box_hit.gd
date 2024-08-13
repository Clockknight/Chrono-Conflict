class_name Box_Hit
extends Box

var overlaps = []
var hits = []
var hurts = []

var atkpriority
var damage
var hitdur
var hitx
var hity
var blockdur
var blockx
var blocky
var whiffid
var blockid
var hitid
var type
var state


func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))


func set_box(inc_data, incharacter):
	#func set_box(posx, posy, scalex, scaley, lifespan):
	super.set_box(inc_data, incharacter)
	self.atkpriority = inc_data["atkpriority"]
	self.damage = inc_data["damage"]
	self.hitdur = inc_data["hitdur"]
	self.hitx = inc_data["hitx"]
	self.hity = inc_data["hity"]
	self.blockdur = inc_data["blockdur"]
	self.blockx = inc_data["blockx"]
	self.blocky = inc_data["blocky"]
	self.whiffid = inc_data["whiffid"]
	self.blockid = inc_data["blockid"]
	self.hitid = inc_data["hitid"]
	self.type = inc_data["type"]
	self.state = inc_data["state"]


func tick():
	#check for hurt boxes
	overlaps = get_overlapping_areas()
	if overlaps != []:
		for e in overlaps:
			if e.character != self.character:
				if e.box_check() == "Hurt":
					hurts.append(e)
				elif e.box_check() == "Hit":
					hits.append(e)

		if hurts != []:
			for box in hurts:
				self.character._other.hit(self.data)
				self.queue_free()
		elif hits != []:
			for box in hits:
				self.character._other.clash(self, box)
				self.queue_free()

	super.tick()


func box_check():
	return "Hit"
