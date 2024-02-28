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

# Should check for new inputs from user like checking for attacks
# On up, down or a1 from either user, change boxes appropriately
#
	
'''
func _unhandled_input(event):
	if event is InputEventKey:
		if event.keycode in _input_dict:
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
		
		
		# TODO add check for simultaneous l/R input
		match _input_dict[_ninput_event]:
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
