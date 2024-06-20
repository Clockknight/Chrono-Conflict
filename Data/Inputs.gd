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


func _init(player, left = 0, up = 0, a = false, b = false, c = false, d = false):
	self.duration = 1

	self.x = left
	self.y = up
	self.a = a
	self.b = b
	self.c = c
	self.d = d
	self.player = player


func compare(o):
	if o != null and a == o.a and b == o.b and c == o.c and d == o.d and x == o.x and y == o.y:
		#print(str(x) + " " + str(o.x))
		o.duration += 1
		return o
	else:
		self.older = o
		return self


func input_new_down():
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
	var report = "\n\n" + str(duration) + " | "

	x *= 1 if p1_side else -1
	y *= 1 if p1_side else -1

	report += str(directions[x + 1][y + 1])

	if not motion_only:
		if report != "":
			report += " "

		if a:
			report += "a"
		if b:
			report += "b"
		if c:
			report += "c"
		if d:
			report += "d"

	if (full or history - duration > 0) and self.older != null:
		return report + self.older.report(history - duration, p1_side, motion_only, full)
	else:
		return report


func down():
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
