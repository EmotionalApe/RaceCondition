extends Node
class_name track

func _on_track_collision_area_entered(area):
	if area is Car:
		area.hit_boundary()
