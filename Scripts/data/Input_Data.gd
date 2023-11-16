extends Node

var duration = 0

var horiz = 0
var vert = 0

var a = false
var b = false
var c = false
var d = false

func init(older_data=null, left=0,up=0,a=false,b=false,c=false,d=false):
	self.horiz = left
	self.vert = up
	self.a = a
	self.b = b
	self.c = c
	self.d = d 
	if older_data != null:
		compare(older_data)

#func compare(older_data:Input_Data):
	
	

