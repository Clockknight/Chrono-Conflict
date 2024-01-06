extends Node

var width = 200
var p1hp
var p2hp

# Called when the node enters the scene tree for the first time.
func _ready():
	p1hp = get_node("p1hp")
	p2hp = get_node("p2hp")


func adjust(p1:bool, perc:float):

	var adjust
	
	adjust = (p1hp if p1 else p2hp)
	adjust = adjust.get_node("have")		
	adjust.scale.x = max(0, perc)
			
	
	
	
# func decompose(node:String)
# func to make lose shrink to have's size
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
