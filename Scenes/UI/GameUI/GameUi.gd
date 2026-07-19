extends Control

class_name GameUI
@export var v_box_container: VBoxContainer

var car_ui_dict : Dictionary[Car, CarUI] = {}

func _enter_tree():
	EventHub.on_lap_update.connect(on_lap_update)

func setup(cars : Array[Car]):
	var ui_nodes : Array[Node] 
	for child in v_box_container.get_children():
		if child is CarUI:
			ui_nodes.append(child)
	
	for i in range (ui_nodes.size()):
		if i >= cars.size():break
		var ui:CarUI = ui_nodes[i]
		var car : Car = cars[i]
		ui.update_values(car, 0, 0.0)
		ui.show()
		car_ui_dict[car] = ui

func on_lap_update(car : Car, lap_count : int, lap_time : float):
	if car in car_ui_dict :
		car_ui_dict[car].update_values(car, lap_count, lap_time)
