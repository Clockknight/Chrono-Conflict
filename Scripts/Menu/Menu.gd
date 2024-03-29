extends Node2D

var menu_location = "res://Data/menus.cfg"
var preload_Leaf = load("res://Scenes/Menu/leaf.tscn")
var highlighted_sprite = "res://Sprites/hurtbox.png"
var unhighlighted_sprite = "res://Sprites/hitbox.png"
var active_sprite = "res://Sprites/grabbox.png"
var used_sound
var active_sound

var leafx = 0
var leafy = 0
var content
var label
var leafs
var grid
var length
var dimensions
var offset
var index = 0
var leaf_stack = []

#func _ready():
func init(menu_id:String):
	self.label = menu_id
	
	if FileAccess.file_exists(menu_location):
		var file = FileAccess.get_file_as_string(menu_location)	
		var res = JSON.parse_string(file)
		
		if res == null:
			get_tree().change_scene("res://Scenes/menu_main.tscn")
			
		content = res[menu_id]
		
		#var data = {"menu_id":{"name":"asdasd", "buttons":["id1","id2","id3"], "2d":false}}
		self.grid = content["grid"]
		self.leafs = content["leafs"]
		self.length = leafs.size()
		self.dimensions = content["dimensions"]
		
		#grid check 
		if self.grid:
			self.length = [self.length, leafs[0].size()]
			self.index = [0,0]
			# loop
			# spawn button
			# adjust button_spawn by button height	
		else:
			for leaf in self.leafs:
				leaf_stack.push_front(_spawn_leaf(leaf, dimensions))
				
				
		leaf_stack[-1].highlight_toggle()
				
		
		

func _spawn_leaf(leaf_id:String, dimensions):
	#instantiate button
	var leaf = self.preload_Leaf.instantiate()
	self.add_child(leaf)
	# init it according to values
	leaf.init(leaf_id, dimensions, leafx, leafy)
	# adjust button_spawn by button height
	leafy += dimensions[1]
	return leaf


func cycle(downwards:bool):
	if grid:
		if downwards:
			index[1] += 1
		else:
			index[1] -= 1
			
		if index[1] < 0:
			index[1] = leafs.size()-1
		elif index[1] >= leafs.size():
			index[1] = 0
			
	else:
		leaf_stack[index].highlight_toggle()
		if downwards:
			index += 1 
		else:
			index -= 1
		
		if index < 0:
			index = leafs.size()-1
		elif index >= leafs.size():
			index = 0
		
		leaf_stack[index].highlight_toggle()
		
	print(index)


 
func left(stack):
	# if grid then move to a left column
	if not grid:
		back(stack)
	
func right(stack):
	# if grid then move to a right column
	if not grid:
		accept(stack)
	
func accept(stack):
	print('accept not implemented')
	
func back(stack):
	print('back not implemented')
	
