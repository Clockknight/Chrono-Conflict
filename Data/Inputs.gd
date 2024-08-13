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


func _init(inplayer, left = 0, up = 0, ina = false, inb = false, inc = false, ind = false):
	self.duration = 1

	self.x = left
	self.y = up
	self.a = ina
	self.b = inb
	self.c = inc
	self.d = ind
	self.player = inplayer


func compare(o):
	if o != null and a == o.a and b == o.b and c == o.c and d == o.d and x == o.x and y == o.y:
		#print(str(x) + " " + str(o.x))
		o.duration += 1
		return o
	else:
		self.older = o
		return self


func input_new_get_down():
	if self.older == null or duration > 1:
		return false

	return input_new_button() or input_new_direction()


func input_new_button():
	if self.a and (self.older == null or not self.older.a):
		return true
	if self.b and (self.older == null or not self.older.b):
		return true
	if self.c and (self.older == null or not self.older.c):
		return true
	if self.d and (self.older == null or not self.older.d):
		return true
	return false


func input_new_direction():
	if self.x != self.older.x:
		return true
	if self.y != self.older.y:
		return true

	return false


func report(history: int, p1_side: bool, motion_only = false, full = true):
	var reporttext = "" if motion_only else "\n\n" + str(duration) + " | "

	reporttext += get_direction(p1_side)

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
		return reporttext + self.older.report(history - duration, p1_side, motion_only, full)
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


func get_direction(p1_side):
	x *= 1 if p1_side else -1
	y *= 1 if p1_side else -1

	return str(directions[x + 1][y + 1])
