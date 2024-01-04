extends Node

var width = 200
var p1hp
var p2hp

# Called when the node enters the scene tree for the first time.
func _ready():
	p1hp = get_node("p1hp")
	p2hp = get_node("p2hp")


func adjust(perc:float, node:String):

	var adjust
	
	match node:
		# hp bars are currently 800px long
		"p1hp":
			adjust = p1hp.get_node("have")
			adjust.scale.x -= perc
			
	
	
	
# func decompose(node:String)
# func to make lose shrink to have's size
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
