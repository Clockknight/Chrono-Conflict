extends Node


var _camera
var p1 = null
var p2
var UI 
var _background
var _timer
var _fps

var levels = [1.0,1.0,1.0,1.0,1.0]

var _camera_pos

var _view_width = 350
var _framerate = 2
var _stage_boundaries = 3000
var frames = 0
var _min_level = en.Level.FRAME

var size

var diff_vector

var _left_max
var _right_max
const diff_x_max = 1000
const diff_x_min = 400
const diff_y_max = 300
const diff_y_min = 100

var debug_state_for_p1n2 = [true, false]

func _ready():
	var temp = get_tree().current_scene.get_node("Menu Manager")
	if temp != null:
		self.levels = temp.levels
		
	_camera = self.get_parent().get_node("Camera2D")
	_background = _camera.get_node("Background")
	UI = self.get_node("UI")
	size = get_viewport().size
	print(size)
	#For setting ground borders
	self.get_parent().get_node('groundline').scale.x = _stage_boundaries / 31
	# find all children (there should be 2)
	# Find the two player objects
	# assign p1/p2 arbitrarily for now
	
	
	UI.scale.x = size[0]/1920.0
	print(UI.scale.x)
	UI.scale.y = size[1]/1080.0
	print(UI.scale.y)
	

	
	for player in self.get_children():
		if player.get_class() == 'CharacterBody2D':
			if not p1:
				p1 = player
			else:
				p2 = player
				
				
	# run config function on each, setting their control strings as needed depending on which is p1/p2
	p1._configure(p2, _stage_boundaries, levels)
	p2._configure(p1, _stage_boundaries, levels)
		

	#Timer section
	_timer = Timer.new()
	add_child(_timer)
	_timer.TIMER_PROCESS_IDLE
	_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	_timer.set_wait_time(1.0 / _framerate)
	_timer.set_one_shot(false)
	_timer.start()
	
	_fps = Timer.new()
	add_child(_fps)
	_timer.TIMER_PROCESS_IDLE
	_fps.connect("timeout", Callable(self, "_on_fps_timeout"))
	_fps.set_wait_time(1.0)
	_fps.set_one_shot(false) # Make sure it loops
	_fps.start()
	
	pass


#Func to update state
# using type of move, normal, special, etc
# hitstun / special animation
# jumping or whatever

func _on_timer_timeout():
	if p1 == null:
		return
	_tick_players()
	_tick_camera()
	
	frames += 1
	
	
func _on_fps_timeout():
#	print(frames)
	UI.tick_timer()
	frames = 0

	
func _tick_players():
# move tick all children
# collisions and jumps n stuff
	
	if p1 != null:
		p1.tick()
	


func _tick_camera():
#	codeblock for camera zooming
	diff_vector = p1.position - p2.position
	
	
	diff_vector.x = clamp(abs(diff_vector.x), diff_x_min, diff_x_max)
	diff_vector.y = clamp(diff_vector.y, diff_y_min, diff_y_max)
	
	
	_camera.zoom.x = 160 / diff_vector.x
	_camera.zoom.y = _camera.zoom.x
	_view_width = 350 * _camera.zoom.x
		
	# codeblock for camera position
	_camera_pos = p1.position + p2.position	
	_left_max = _stage_boundaries - _view_width
	_right_max = -1 *_stage_boundaries + _view_width
	
	_camera_pos.x /= 2
	_camera_pos.y /= 8
	
	_camera_pos.x = clamp(_camera_pos.x,  _right_max, _left_max)
	
	
	_background.position.x = _camera.position.x *-.05
	_camera.position = _camera_pos
	
	
	_background.scale = _camera.zoom * 2
	
	
	
	
	
func adjust_ui(p1, new_val, item:int):
	
	match item:
		en.Elem.HEALTH:	
			UI.adjust_health(p1==self.p1, new_val)	
			
			
			
func update_console(p1, combo, state, direction, input,  cx, sx, grounded, jumps):
	UI.update_console(p1==self.p1, combo, state, direction, input, cx, sx, grounded, jumps)

	
func _debug_message(level:int, msg:String, p1:bool):
	if ((p1 and debug_state_for_p1n2[0]) or (not p1 and debug_state_for_p1n2[1]))and (level >= _min_level and  _min_level != en.Level.DEBUG) or (level == en.Level.DEBUG and level == _min_level):
		
		msg = '==> '.repeat(level+1) + msg
		
		print(msg)
