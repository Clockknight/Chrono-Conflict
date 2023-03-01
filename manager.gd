extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var p1 = false
var p2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	# find all children (there should be 2)
	# Find the two player objects
	# assign p1/p2 arbitrarily for now
	if self.get_child_count() == 2:
		for player in self.get_children():
			if not p1:
				p1 = player
			else:
				p2 = player
				
		
	# run config() on each, setting their control strings as needed depending on which is p1/p2
	
	p1.config(p2)
	p2.config(p1)
	pass


#func for accepting win/loss
