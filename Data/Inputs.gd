class_name Input_Data
extends Node

var duration

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
	if self.a and not self.older.a:
		return true
	if self.b and not self.older.b:
		return true
	if self.c and not self.older.c:
		return true
	if self.d and not self.older.d:
		return true
	return false


func input_new_direction():
	if self.x != self.older.x:
		return true
	if self.y != self.older.y:
		return true

	return false


func report(full = true, history = 30):
	var report = "\n\n" + str(duration)

	if x == -1:
		report += "L"
	elif x == 1:
		report += "R"
	if y == 1:
		report += "D"
	elif y == -1:
		report += "U"

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
		return self.older.report(full, history - duration) + report
	else:
		return report
