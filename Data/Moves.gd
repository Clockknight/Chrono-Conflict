class_name MoveData
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

var appearance


func _init(
	inpriority: int,
	indamage: int,
	induration: int,
	inhit_dir_x,
	inhit_dir_y,
	inblk_dir_x,
	inblk_dir_y,
	inwhiff_id,
	inblock_id,
	inhit_id,
	intype: int,
	instate: int = en.State.STUN
):
	self.priority = inpriority
	self.damage = indamage
	self.duration = induration
	self.state = instate

	self.hit_direction = Vector2(inhit_dir_x, inhit_dir_y)
	self.blk_direction = Vector2(inblk_dir_x, inblk_dir_y)

	self.whiff = inwhiff_id
	self.block = inblock_id
	self.hit = inhit_id

	self.appearance = 1
	self.type = intype
