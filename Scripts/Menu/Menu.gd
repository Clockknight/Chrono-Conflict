extends Control

var preload_Button = load("res://Scenes/Menu/button.tscn")
var menu_location = "res://Data/menus.cfg"
var active_index = 0

var content
var label
var buttons
var array_2d
var length
var index
#var data = {"menu_id":{"name":"asdasd", "buttons":["id1","id2","id3"], "2d":false}}

#func _ready():

func init(menu_id:String):
	if FileAccess.file_exists(menu_location):
		var file = FileAccess.get_file_as_string(menu_location)	
		var res = JSON.parse_string(file)[menu_id]
		if res == null:
			get_tree().change_scene("res://Scenes/menu_main.tscn")
			
		content = res



func cycle(downwards:bool):
	if downwards:
		active_index += 1 
	else:
		active_index -= 1
		
	if index < 0:
		downwards = buttons.size()


 
func left(stack):
	
	
	'''
func right(stack):
	
func accept(stack):
	
func back(stack):
	
	
	

	
'''
