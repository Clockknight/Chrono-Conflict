class_name Hurt_Box
extends Box


"""
#func _init() -> void:
	
func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	
	
func tick():
	_frames_remaining = 1
	
	
func _on_area_entered(hitbox: Hit_Box):
	if hitbox == null:
		return
		
	if owner.has_method("damage"):
		owner.damage(10)
"""
