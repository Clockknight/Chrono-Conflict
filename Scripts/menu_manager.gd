extends Control

var preload_Button = load("res://Scenes/Menu/button.tscn")
var dict_location = "res://Data/controls.cfg"
var _controls_dictionary


var _up1_string 
var _up2_string 
var _down1_string
var _down2_string
var _left1_string
var _left2_string
var _right1_string
var _right2_string
var _a1_string
var _a2_string
var _b1_string
var _b2_string

# Called when the node enters the scene tree for the first time.
func _ready():
	_configure()
	
	
	
# Should check for new inputs from user like checking for attacks
# On up, down or a1 from either user, change boxes appropriately
func _configure():
	
	_controls_dictionary = {}
	
	_load_controls()
	
	_up1_string = _update_dictionary("ui_p1up")
	_up2_string = _update_dictionary("ui_p1up")
	_down1_string= _update_dictionary("ui_p1down")
	_down2_string= _update_dictionary("ui_p2down")
	_left1_string =_update_dictionary("ui_p1left")
	_left2_string =_update_dictionary("ui_p2left")
	_right1_string=_update_dictionary("ui_p1right")
	_right2_string=_update_dictionary( "ui_p2right")
	_a1_string=_update_dictionary("ui_p1a")
	_a2_string=_update_dictionary("ui_p2a")
	_b1_string=_update_dictionary("ui_p1b")
	_b2_string=_update_dictionary("ui_p2b")
	
	_save_controls()
	
func _update_dictionary(res:String):
	if InputMap.action_get_events(res).pop_front().physical_keycode == 0:
		_controls_dictionary[InputMap.action_get_events(res).pop_front().keycode] = res
	else:
		_controls_dictionary[InputMap.action_get_events(res).pop_front().physical_keycode] = res
	
	return res


func _load_controls():
	print("loading")
	if FileAccess.file_exists(dict_location):
		var file = FileAccess.get_file_as_string(dict_location)	
		_controls_dictionary = JSON.parse_string(file)
		
		
	
	
func _save_controls():
	print("saving")
	print(_controls_dictionary)
	var file = FileAccess.open(dict_location, FileAccess.WRITE)
	if FileAccess.file_exists(dict_location):
		file.store_string(JSON.stringify(_controls_dictionary, '	'))
	else:
		file

'''
func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode in _controls_dictionary:
			_input_queue.append([event, event.pressed])
			
func step_input_process():
	# Process all the queued inputs, and pass the resulting input to cur innput next
	var x = 0
	var y = 0

	var a = false
	var b = false
	var c = false
	var d = false

	var new_input
	var _ninput_event
	var _ninput_state

	if is_instance_valid(_cur_input):
		x = _cur_input.x
		y = _cur_input.y
		a = _cur_input.a
		b = _cur_input.b
		c = _cur_input.c
		d = _cur_input.d
		
	if _input_queue != []:
		_debug_message(en.Level.FRAME, "Processing input queue...")
	while _input_queue != []:
		new_input = _input_queue.pop_front()
		_ninput_event = new_input[0].keycode
		_ninput_state = new_input[1]
		
		
		match _controls_dictionary[_ninput_event]:
			_up_string:
				y -=  int(_ninput_state) *2-1
			_down_string:
				y +=  int(_ninput_state)*2-1
			_left_string:
				x -=  int(_ninput_state) *2-1
			_right_string:
				x +=  int(_ninput_state) *2-1
			_a_string:
				a = _ninput_state
			_b_string:
				b = _ninput_state
			_c_string:
				c = _ninput_state
			_d_string:
				d = _ninput_state
		
		x = clamp(x, -1, 1)
		y = clamp(y, -1, 1)

	new_input = i.new(self, x, y, a,b,c,d)
	_cur_input = new_input.compare(_cur_input)

	return _cur_input
'''
