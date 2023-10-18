extends Node

var priority
var damage
var duration
var state

var influence
var location


func _init(priority: int, damage: int, duration: int, state: int, influence: Vector2, location: Vector2):
	self.priority = priority
	self.damage = damage
	self. duration = duration
	self.state = state
	
	self.influence = influence
	self.location = location
