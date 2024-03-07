extends Control

var preload_Button = load("res://Scenes/Menu/button.tscn")
var active_index = 0

var content
var label
var buttons
var array_2d

#func _ready():

func menu_init(menu_id:String):
		
	if FileAccess.file_exists(dict_location):
		var file = FileAccess.get_file_as_string(dict_location)	
		res = JSON.parse_string(file)[menu_id]
		if res != null:
			content = res



func cycle(downwards:bool):
	if downwards:
		active_index += 1 
	else:
		active_index -= 1
		
	if downwards < 0:
		downwards = buttons.size()
	
	
var data = {"sam_id":{"name":"asdasd", "buttons":["id1","id2","id3"], "2d":false}}

 
func left(stack):
	
	
	
func right(stack):
	
func accept(stack):
	
func back(stack):
	
	
	

	
