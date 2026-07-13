extends Area2D

func _on_area_entered(area):
	if area is Car:
		area.hit_verification(get_instance_id())
