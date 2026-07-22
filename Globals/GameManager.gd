extends Node

const MAIN = preload("uid://co608ulrov8cj")

func change_to_main():
	get_tree().change_scene_to_packed(MAIN)

func change_to_track(info : TrackInfo):
	get_tree().change_scene_to_packed(info.trackScene)
