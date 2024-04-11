extends Control

var Prefab_menu = load("res://Scenes/Menu/Menu.tscn")
var dict_location = "res://Data/controls.cfg"
var _controls_dictionary  = Dictionary()
var _menu_stack = []
var _active_menu 

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
	self.size.x = 1
	self.size.y = 1
	_configure()
	build_menu()
	
	
	
	
# Should check for new inputs from user like checking for attacks
# On up, down or a1 from either user, change boxes appropriately
func _configure():
	_load_controls()
	
	_up1_string = _update_dictionary("ui_p1up")
	_up2_string = _update_dictionary("ui_p2up")
	_down1_string= _update_dictionary("ui_p1down")
	_down2_string= _update_dictionary("ui_p2down")
	_left1_string =_update_dictionary("ui_p1left")
	_left2_string =_update_dictionary("ui_p2left")
	_right1_string=_update_dictionary("ui_p1right")
	_right2_string=_update_dictionary("ui_p2right")
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
	if FileAccess.file_exists(dict_location):
		var file = FileAccess.get_file_as_string(dict_location)	
		var content = JSON.parse_string(file)
		if content != null:
			_controls_dictionary = content
	
func _save_controls():
	var file = FileAccess.open(dict_location, FileAccess.WRITE)
	file.store_string(JSON.stringify(_controls_dictionary, '	'))

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode in _controls_dictionary:
			match _controls_dictionary[event.keycode]:
				_up1_string:
					_menu_stack[-1].cycle(true)
				_up2_string:
					_menu_stack[-1].cycle(true)
				_down1_string:
					_menu_stack[-1].cycle(false)
				_down2_string:
					_menu_stack[-1].cycle(false)
				_left1_string:
					_menu_stack[-1].left(_menu_stack)
				_left2_string:
					_menu_stack[-1].left(_menu_stack)
				_right1_string:
					_menu_stack[-1].right(_menu_stack)
				_right2_string:
					_menu_stack[-1].right(_menu_stack)
				_a1_string:
					build_menu(_menu_stack[-1].accept())
				_a2_string:
					build_menu(_menu_stack[-1].accept())
				_b1_string:
					back()
				_b2_string:
					back()


func build_menu(menu_id="Main"):
	if menu_id == null:
		# this shouldnt ever be called
		return
	#instantiate a menu
	var new_menu = Prefab_menu.instantiate()
	self.add_child(new_menu)
	new_menu.init(menu_id)
	$Camera.offset.x += new_menu.width if _menu_stack == [] else new_menu.dimensions[0]/2 + _menu_stack[0].dimensions[0]/2
	
	_menu_stack.append(new_menu)
	new_menu.position.x += $Camera.offset.x
	#add menu to stack
	#update active_menu
	_active_menu = new_menu
	

func back():
	$Camera.offset.x -= _menu_stack[-1].dimensions[0]
	_menu_stack[-1].back(_menu_stack)
	
	_active_menu = _menu_stack[-1]
	
	_active_menu.deactivate()
