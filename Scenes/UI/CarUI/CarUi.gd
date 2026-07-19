extends HBoxContainer
class_name CarUI

@onready var name_label = $NameLabel
@onready var lap_label = $LapLabel
@onready var last_lap = $LastLap

func update_values(car : Car, lap_count : int, lap_time : float):
	name_label.text = car.carName.substr(0,3) + "(#" + str(car.carNumber) + ")"
	lap_label.text = str(lap_count)
	last_lap.text = "%.2fs" % lap_time
