extends Control

var preload_Button = load("res://Scenes/Menu/button.tscn")
var buttons 
var active_index = 0

#func _ready():

func menu_init(length:int):
	buttons = []
	for x in range(0,length):
		buttons[x] = preload_Button.instantiate()
		buttons[x].button_set()


func cycle(downwards:bool):
	if downwards:
		active_index += 1 
	else:
		active_index -= 1
		
	if downwards < 0:
		downwards = buttons.size()
	
	
func left(stack):
	
func right(stack):
	
func accept(stack):
	
func back(stack):

	
