extends Node

class_name Waypoint

@onready var label = $Label
@onready var right_collision = $RightCollision
@onready var left_collision = $LeftCollision


var number := 0:
	get : return number

var next_waypoint : Waypoint:
	get : 
		if !next_waypoint : printerr("no next_waypoint")
		return next_waypoint

var prev_waypoint : Waypoint:
	get : 
		if !prev_waypoint : printerr("no prev_waypoint")
		return prev_waypoint
		
func setup(next_wp : Waypoint, prev_wp: Waypoint, num: int):
	next_waypoint = next_wp
	prev_waypoint = prev_wp
	number = num
	label.text = "%d" % num
	
func _to_string():
	return "%d next:%d prev:%d" % [number, next_waypoint.number, prev_waypoint.number]
