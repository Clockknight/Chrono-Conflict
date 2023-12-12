extends Node

var priority
var damage
var duration
var state

var influence
var location

var whiff
var block
var hit


func _init(priority: int, damage: int, duration: int, state: int, influence: Vector2, location: Vector2, whiff_id, block_id, hit_id):
	self.priority = priority
	self.damage = damage
	self. duration = duration
	self.state = state
	
	self.influence = influence
	self.location = location

	self.whiff = whiff_id
	self.block = block_id
	self.hit = hit_id
