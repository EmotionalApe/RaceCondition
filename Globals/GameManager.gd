extends Node

const MAIN = preload("uid://co608ulrov8cj")

var data : SaveData
var current_track_name : String = ""

func _enter_tree():
	data = SaveData.load_or_create()

func save_best_lap(new_time : float):
	data.save_best_lap(current_track_name, new_time)

func get_best_lap(track_name : String) -> float:
	return data.get_best_lap(track_name)

func change_to_main():
	get_tree().change_scene_to_packed(MAIN)

func change_to_track(info : TrackInfo):
	current_track_name = info.trackName
	get_tree().change_scene_to_packed(info.trackScene)
