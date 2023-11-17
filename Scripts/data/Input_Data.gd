extends Node

var duration = 0

var horiz 
var vert 

var a 
var b 
var c 
var d 

var next = null

func _init( left=0,up=0,a=false,b=false,c=false,d=false,older_data=null):
	self.horiz = left
	self.vert = up
	self.a = a
	self.b = b
	self.c = c
	self.d = d 
	if older_data != null:
		if compare(older_data):
			older_data.duration += 1
		else:
			older_data.next = self
			
			
			

func compare(o):
	return a == o.a and b==o.b and c==o.c and d==o.d and horiz==o.horiz and vert==o.vert
	

func report(first = true):
	var report = ""
	
	if horiz == -1:
		report+="L"
	elif horiz == 1:
		report+= "R"
	if vert == 1:
		report+="D"
	elif vert ==-1:
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
