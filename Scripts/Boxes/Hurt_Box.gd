class_name Hurt_Box
extends Box


func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	
func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	
	
func _on_area_entered(hitbox: Hit_Box):
	if hitbox == null:
		return
		
	if owner.has_method("damage"):
		owner.damage(10)
		
	
