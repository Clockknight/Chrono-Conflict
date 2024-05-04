extends Node2D

var menu_location = "res://Data/menus.cfg"
var preload_Leaf = load("res://Scenes/Menu/leaf.tscn")
var preload_Leafslider = load("res://Scenes/Menu/Leaf_slider.tscn")
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
var width
var height
var source
var index = 0
var column_index= null
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
		self.offset = content["offset"]
		self.width = self.dimensions[0] + self.offset[0]
		self.height = self.dimensions[1] + self.offset[1]
		self.source = content["source"]
		
		#grid check 
		if self.grid:
			self.index = 0
			self.column_index = 0
			self.length = leafs[index].size()

			# loop
			var temp = 0
			for i in leafs:
				leaf_stack.append([])
				for j in i:
					
					leaf_stack[temp].append( _spawn_leaf(j, self.dimensions) )
				leafx += self.width
				leafy = 0
				temp += 1
				# spawn button
				# adjust button_spawn by button height	
			
			leaf_stack[self.index][self.column_index].highlight_toggle()
		else:
			self.index = 0
			for leaf in self.leafs:
				leaf_stack.push_back(_spawn_leaf(leaf, self.dimensions))
			leaf_stack[self.index].highlight_toggle()
				
		
		

func _spawn_leaf(leaf_id:String, dimensions):
	var leaf
	
	if leaf_id.ends_with(".tscn"):
		print("tscn case")
		leaf = self.preload_Leaf.instantiate()	
	elif leaf_id.ends_with(".val"):
		leaf = self.preload_Leafslider.instantiate()
	else:
		leaf = self.preload_Leaf.instantiate()	
	
	#instantiate button
	self.add_child(leaf)
	# init it according to values
	leaf.init(leaf_id, dimensions, leafx, leafy)
	leafy += 2* (dimensions[1]+ offset[1])
	return leaf


func cycle(upwards:bool):
	if grid:
		leaf_stack[column_index][index].highlight_toggle()
		if upwards:
			index -= 1
		else:
			index += 1

		if index < 0:
			index = leafs.size()-1
		elif index >= leafs.size():
			index = 0
		leaf_stack[column_index][index].highlight_toggle()
			
		

	else:
		leaf_stack[index].highlight_toggle()
		if upwards:
			index -= 1 
		else:
			index += 1

		if index < 0:
			index = leaf_stack.size()-1
		elif index >= leaf_stack.size():
			index = 0

		leaf_stack[index].highlight_toggle()



 
func left(stack):
	# if grid then move to a left column
	if grid:
		leaf_stack[column_index][index].highlight_toggle()
		column_index -= 1
		

		if column_index < 0:
			column_index = leaf_stack.size()-1
		leaf_stack[column_index][index].highlight_toggle()
		
	else:
		back(stack)
	
func right(stack):
	# if grid then move to a right column
	if grid:
		leaf_stack[column_index][index].highlight_toggle()
		column_index += 1
		
		if column_index >= leaf_stack.size():
			column_index = 0
		
		if index >= leaf_stack[column_index].size():
			index = leaf_stack[column_index].size()-1
		leaf_stack[column_index][index].highlight_toggle()
		
	else:
		accept()
	
func accept():
	var active_leaf
	
	if not grid:
		#  trigger highlight on current button
		active_leaf = leaf_stack[index]
	else:
		active_leaf = leaf_stack[index[0]][index[1]]
		
	# get id of leaf at index
	active_leaf.activate_toggle()
	return str(active_leaf.name)
		
		
		
func back(stack):
	if not grid:
		if stack[0] == self:
			load_scene(self.source)
		queue_free()
		# drop an item off the list
	stack.pop_back()
		
func load_scene(next_scene):
#	load next scene
	get_tree().root.add_child(load(next_scene).instantiate())
	self.get_parent().queue_free()

func deactivate():
	self.leaf_stack[self.index].activate_toggle()

func reposition(leaving):
	
	self.position.x -= self.width * 6 * (1 if leaving else -1)
