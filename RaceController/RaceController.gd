extends Node

class_name RaceController

func on_lap_completed(info):
	print("RaceController on_lap_completed:", info)

func _enter_tree():
	EventHub.on_lap_completed.connect(on_lap_completed)
