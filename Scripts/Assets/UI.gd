extends Node


var p1hp


# Called when the node enters the scene tree for the first time.
func _ready():
	p1hp = get_node("p1hp")
	p1hp.get_node("have").scale.x = 10
	p1hp.get_node("lose").scale.x = 10
	
	p1hp.get_node("have").scale.y = 10
	p1hp.get_node("lose").scale.y = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
