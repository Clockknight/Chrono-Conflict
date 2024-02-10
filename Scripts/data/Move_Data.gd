extends Node


var priority
var damage
var duration
var state

var hit_direction
var blk_direction

var whiff
var block
var hit
var type


func _init(priority: int, damage: int, duration: int, 
hit_dir_x, hit_dir_y, blk_dir_x, blk_dir_y, whiff_id, block_id, hit_id, type:int, state: int=en.State.STUN):
	self.priority = priority
	self.damage = damage
	self.duration = duration
	self.state = state
	
	self.hit_direction = Vector2(hit_dir_x,hit_dir_y)
	self.blk_direction = Vector2(blk_dir_x, blk_dir_y)

	self.whiff = whiff_id
	self.block = block_id
	self.hit = hit_id
	
	self.type = type
