extends Control

var preload_Button = load("res://Scenes/Menu/button.tscn")
var buttons 
# Called when the node enters the scene tree for the first time.
#func _ready():
	
	

func menu_init(length:int):
	buttons = []
	
	for x in range(0,length):
		buttons[x] = preload_Button.instantiate()
		buttons[x].button_set()

#
	
