extends Object

class_name LapCompleteData

var lapTime : float
var car : Car

func _init(p_car : Car, lt : float):
	car = p_car
	lapTime = lt

func _to_string():
	return "LapCompleteData %s (#%d) lap: %.2f" % [
		car.carName, car.carNumber, lapTime
	]
