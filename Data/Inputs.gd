class_name Input_Data
extends Node

var duration

var directions = [[7, 4, 1], [8, 5, 2], [9, 6, 3]]

var x
var y

var a
var b
var c
var d
var repeat

var older

var player


func _init(inplayer, inleft = 0, inup = 0, ina = false, inb = false, inc = false, ind = false):
	self.duration = 1

	self.x = inleft
	self.y = inup
	self.a = ina
	self.b = inb
	self.c = inc
	self.d = ind
	self.player = inplayer


func compare(o):
	if o != null and a == o.a and b == o.b and c == o.c and d == o.d and x == o.x and y == o.y:
		o.duration += 1
		return o
	else:
		# TODO Notably, this is a step where previous -1 horiz inputs are already flipped to 1 horiz inputs.
		# I probably left some code in subtick input or something to fuck this up on p2 side
		self.older = o
		return self


func input_new_get_down():
	if self.older == null or duration > 1:
		return false

	return input_new_button() or input_new_direction()


func self_newest_input():
	return self.older == null


func input_new_button():
	if self_newest_input():
		return false
	if self.a and (not self.older.a):
		return true
	if self.b and (not self.older.b):
		return true
	if self.c and (not self.older.c):
		return true
	if self.d and (not self.older.d):
		return true
	return false


func input_new_direction():
	if not self_newest_input():
		return false
	if self.x != self.older.x:
		return true
	if self.y != self.older.y:
		return true

	return false


func report(history: int, inp1_side: bool, motion_only = false, full = true):
	var reporttext = "" if motion_only else "\n\n" + str(duration) + " | "

	reporttext += get_direction(inp1_side)

	if not motion_only:
		if reporttext != "":
			reporttext += " "

		if a:
			reporttext += "a"
		if b:
			reporttext += "b"
		if c:
			reporttext += "c"
		if d:
			reporttext += "d"

	if (full or history - duration > 0) and self.older != null:
		return reporttext + self.older.report(history - duration, inp1_side, motion_only, full)
	else:
		return reporttext


func get_down():
	var temp = ""
	if a:
		temp += ("a")
	if b:
		temp += ("b")
	if c:
		temp += ("c")
	if d:
		temp += ("d")

	return temp


func get_direction(inp1_side):
	var directionx = x * (1 if inp1_side else -1)
	var directiony = y

	return str(directions[directionx + 1][directiony + 1])
