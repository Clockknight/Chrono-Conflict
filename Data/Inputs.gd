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

func _init(player, left=0,up=0,a=false,b=false,c=false,d=false):
	self.duration = 1
	
	self.x = left
	self.y = up
	self.a = a
	self.b = b
	self.c = c
	self.d = d 
	self.player = player
	

func compare(o):
	if o != null and a == o.a and b==o.b and c==o.c and d==o.d and x==o.x and y==o.y:
		o.duration += 1
		return o
	else:
		self.older = o
		return self
		
		
		
func input_new_down(input:String):
	if self.older == null or duration > 1:
		return false
	
	var newinput
	var oldinput
	
	match input:
		'a':
			newinput = self.a 
			oldinput = self.older.a
		'b':
			newinput = self.b 
			oldinput = self.older.b
		'c':
			newinput = self.c 
			oldinput = self.older.c
		'd':
			newinput = self.d 
			oldinput = self.older.d
		'x':
			newinput = self.x 
			oldinput = self.older.x
		'y':
			newinput = self.y 
			oldinput = self.older.y

				
	return (newinput != oldinput) and newinput
			
	

func report(full=true, history=30):
	var report = "\n\n" + str(duration) 
			
	if x == -1:
		report+="L"
	elif x == 1:
		report+= "R"
	if y == 1:
		report+="D"
	elif y ==-1:
		report +="U"
	
	if report != "":
		report += " "
	
	if a:
		report+="a"
	if b:
		report+="b"
	if c:
		report += "c"
	if d:
		report+="d"
		
		
	if((full or history - duration > 0) and self.older != null):
		return self.older.report(full, history-duration) + report
	else:
		return report
	
	