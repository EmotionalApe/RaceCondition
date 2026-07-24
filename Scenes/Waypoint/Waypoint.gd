extends Node

class_name Waypoint

const MAX_RADIUS := 300.0

@onready var label = $Label
@onready var right_collision = $RightCollision
@onready var left_collision = $LeftCollision

var radius := MAX_RADIUS:
	get : return radius
	
var radius_factor := 0.0:
	get : return radius_factor

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
	calc_turn_radius()

func calc_turn_radius():
	var a : float = prev_waypoint.global_position.distance_to(self.global_position)
	var b : float = self.global_position.distance_to(next_waypoint.global_position)
	var c : float = next_waypoint.global_position.distance_to(prev_waypoint.global_position)
	var s : float = (a + b + c) / 2.0
	var area : float = sqrt(max(s * (s-a) * (s-b) * (s-c), 0.0))
	if !is_zero_approx(area):
		radius = (a*b*c) / (4.0 * area)

func set_radius_factor(min_radius : float, radius_curve : Curve):
	var adj : float = clampf(radius, min_radius, MAX_RADIUS) 
	var t : float = (adj - min_radius) / (MAX_RADIUS - min_radius)
	radius_factor = radius_curve.sample(t)

func _to_string():
	calc_turn_radius()
	return "%d next:%d prev:%d rad:%.2f fac:%.2f" % [number, next_waypoint.number, 
	prev_waypoint.number, radius, radius_factor]
