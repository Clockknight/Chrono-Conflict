extends Node


var priority
var damage
var duration
var state

var hit_influence
var blk_influence

var whiff
var block
var hit
var type


func _init(priority: int, damage: int, duration: int, 
hit_inf_x, hit_inf_y, blk_inf_x, blk_inf_y, whiff_id, block_id, hit_id, type:int, state: int=en.State.STUN):
	self.priority = priority
	self.damage = damage
	self.duration = duration
	self.state = state
	
	self.hit_influence = Vector2(hit_inf_x,hit_inf_y)
	self.blk_influence = Vector2(blk_inf_x, blk_inf_y)

	self.whiff = whiff_id
	self.block = block_id
	self.hit = hit_id
	
	self.type = type
