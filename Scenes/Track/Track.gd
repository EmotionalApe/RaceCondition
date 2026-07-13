extends Node
class_name track

@onready var track_path := $TrackPath
@onready var verifications_holder:= $VerificationsHolder
@onready var cars_holder := $CarsHolder


var trackCurve = Curve2D

func _ready():
	trackCurve = track_path.curve

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
