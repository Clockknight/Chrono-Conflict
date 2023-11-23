extends Node

var duration 

var x 
var y 

var a 
var b 
var c 
var d 

var next = null

var test 

func _init( left=0,up=0,a=false,b=false,c=false,d=false,older_data=null):
	self.duration = 0
	
	self.x = left
	self.y = up
	self.a = a
	self.b = b
	self.c = c
	self.d = d 
	self.test = older_data
	
	if older_data != null:
		if compare(older_data):
			older_data.duration = older_data.duration + 1
			queue_free()
		else:
			older_data.next = self
			
			
			

func compare(o):
	return a == o.a and b==o.b and c==o.c and d==o.d and x==o.x and y==o.y
	

func report(first = true):
	var report = ""
	
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
		
		
	report =  str(duration) + " " + report
		
	if not first:
		report = "| " + report
		
		
		
	return report
