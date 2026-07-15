extends PathFollow2D


class_name TrackProcessor

const WAYPOINT = preload("uid://bi3reukmi5kwa")
@export var interval := 50.0 
@export var grid_space := 75.0

var waypoints : Array[Waypoint] 

signal build_completed

func connect_waypoints():
	var total_wp := waypoints.size() 
	for i in range(total_wp):
		var prev_idx := (i-1+total_wp) % total_wp
		var next_idx := (i+1+total_wp) % total_wp
		waypoints[i].setup(waypoints[next_idx], waypoints[prev_idx], i)
		

func create_waypoint():
	var wp:= WAYPOINT.instantiate()
	wp.global_position = global_position
	wp.rotation_degrees = global_rotation_degrees + 90.0
	return wp

func generate_waypoints(holder):
	var path2d : Path2D = get_parent()
	progress = interval
	while progress < path2d.curve.get_baked_length() - grid_space:
		var wp=create_waypoint() 
		holder.add_child(wp)
		waypoints.append(wp)
		progress += interval
	await get_tree().physics_frame


func build_waypoint_data(holder):
	waypoints.clear()
	await generate_waypoints(holder)
	connect_waypoints()
	
	for wp in waypoints:print(wp)
	build_completed.emit()
