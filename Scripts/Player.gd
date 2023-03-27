class_name player
extends KinematicBody2D

export(float) var horizontal_speed = 25.0
export(float) var vertical_speed = 80.0
export(float) var gravity = 5
export(float) var terminal_speed = gravity * 20
var directional_input  = Vector2.ZERO


var _up_string = "ui_p1up"
var _down_string = "ui_p1down"
var _left_string = "ui_p1left"
var _right_string = "ui_p1right"
var _a1_string = "ui_p1a1"
var _a2_string = "ui_p1a2"
var _a3_string = "ui_p1a3"
var _a4_string = "ui_p1a4"

var _other
var _p1_side = true
var _bottom



func configure(other_player):
	# player object assumes it's player 1 until otherwise stated
	_other = other_player
	sidecheck()
	
	if not _p1_side:
		_up_string = "ui_p2up"
		_down_string = "ui_p2down"
		_left_string = "ui_p2left"
		_right_string = "ui_p2right"
		_a1_string = "ui_p2a1"
		_a2_string = "ui_p2a2"
		_a3_string = "ui_p2a3"
		_a4_string = "ui_p2a4"


func sidecheck():
	_p1_side = self.position.x < _other.position.x
