extends Node
class_name track

@onready var track_path := $TrackPath
@onready var verifications_holder:= $VerificationsHolder
@onready var cars_holder := $CarsHolder
@onready var track_processor = $TrackPath/TrackProcessor
@onready var waypoints_holder = $WaypointsHolder
@onready var race_controller = $RaceController
@onready var game_ui = $UICanvas/GameUI

var trackCurve = Curve2D

func _ready():
	await setup()

func setup():
	var cars : Array[Car] = []
	trackCurve = track_path.curve
	track_processor.build_waypoint_data(waypoints_holder)
	await track_processor.build_completed
	
	for car in $CarsHolder.get_children():
		cars.append(car)
		if car is CpuCar:
			car.set_next_waypoint(track_processor.first_waypoint)
	race_controller.setup(cars, trackCurve)
	game_ui.setup(cars)

func get_direction_to_path(fromPos : Vector2):
	var closestOffset : float = trackCurve.get_closest_offset(fromPos)
	var nearestPoint : Vector2 = trackCurve.sample_baked(closestOffset)
	return fromPos.direction_to(nearestPoint)

func _on_track_collision_area_entered(area):
	if area is Car:
		area.hit_boundary(get_direction_to_path(area.position))

 
func _on_start_line_area_entered(area):
	if area is Car:
		area.lap_completed()
