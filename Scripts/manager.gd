extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var p1 = false
var p2
var _timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# find all children (there should be 2)
	# Find the two player objects
	# assign p1/p2 arbitrarily for now
	if self.get_child_count() == 2:
		for player in self.get_children():
			if not p1:
				p1 = player
			else:
				p2 = player
		# run config function on each, setting their control strings as needed depending on which is p1/p2
		print(p1)
		p1._configure(p2)
		p2._configure(p1)

	#Creat timer
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0 / 60)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
				
		
	
	pass


#Func to update state
# using type of move, normal, special, etc
# hitstun / special animation
# jumping or whatever



func _on_Timer_timeout():
	_tick_players()
	
	
func _tick_players():
# move tick all children
# collisions and jumps n stuff
	p1.tick()
	p2.tick()

