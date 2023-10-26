extends Node

const e = preload('./data/Enums.gd')

var _camera

var p1 = false
var p2
var _timer
var _fps

var _camera_pos

var _view_width 
var _framerate = 60
var _stage_boundaries = 3000
var frames = 0
var _min_level = e.Level.EVENT

var _observe_players = [true]

func _ready():
	_camera = self.get_parent().get_node("Camera2D")
	#For setting ground borders
	self.get_parent().get_node('groundline').scale.x = _stage_boundaries / 31
	_view_width = 350 * _camera.zoom.x
	# find all children (there should be 2)
	# Find the two player objects
	# assign p1/p2 arbitrarily for now
	if self.get_child_count() == 2:
		for player in self.get_children():
			if not p1:
				p1 = player
			else:
				p2 = player
				
		p1._debug = true
		# run config function on each, setting their control strings as needed depending on which is p1/p2
		p1._configure(p2, _stage_boundaries)
		p2._configure(p1, _stage_boundaries)
		

	#Creat timer
	_timer = Timer.new()
	add_child(_timer)
	_timer.TIMER_PROCESS_IDLE
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.set_wait_time(1.0 / _framerate)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
	_fps = Timer.new()
	add_child(_fps)
	_timer.TIMER_PROCESS_IDLE
	_fps.connect("timeout", self, "_on_fps_timeout")
	_fps.set_wait_time(1.0)
	_fps.set_one_shot(false) # Make sure it loops
	_fps.start()
	
	pass


#Func to update state
# using type of move, normal, special, etc
# hitstun / special animation
# jumping or whatever

func _on_timer_timeout():
	_tick_players()
	_tick_camera()
	
	frames += 1
	
	
func _on_fps_timeout():
#	print(frames)
	frames = 0

	
func _tick_players():
# move tick all children
# collisions and jumps n stuff
	p1.tick()
	


func _tick_camera():

	_camera_pos = p1.position + p2.position
	_camera_pos.x /= 2
	
	
	var _left_max = _stage_boundaries - _view_width
	var _right_max = -1 *_stage_boundaries + _view_width
	
	if(_camera_pos.x > _left_max):
		_camera_pos.x = _left_max
	elif(_camera_pos.x < _right_max):
		_camera_pos.x = _right_max
	
	_camera_pos.y = 0
	# if (_camera_pos_y > 0)

	_camera.position = _camera_pos
	 
	
func _debug_message(msg:String, level:int, p1:bool):
	if (level >= _min_level and p1 in _observe_players):
		msg = '==> '.repeat(level) + msg
		print(msg)
