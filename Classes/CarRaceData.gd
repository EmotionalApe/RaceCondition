extends Object

class_name CarRaceData

const DEFAULT_LAPTIME := 999.99

var carNumber : int
var carName : String 
var totalTime := 0.0
var partialProgress : float
var bestLap := DEFAULT_LAPTIME
var targetLaps := 0 

var completedLaps : int:
	get:return completedLaps

var raceCompleted : bool:
	get: return completedLaps == targetLaps

var totalProgress : float: 
	get : return completedLaps + partialProgress
	
func _init(car_name : String, car_number : int, target_laps : int):
	targetLaps = target_laps
	carNumber = car_number
	carName = car_name
	
func add_lap_time(lap_time):
	completedLaps += 1
	bestLap = min(bestLap, lap_time)
	
func set_total_time(total_time: float):
	totalTime = total_time

func force_finish(total_time : float, progress : float):
	partialProgress = progress
	totalTime = total_time
	
func _to_string():
	var total_str := "DNF"
	if raceCompleted : total_str = "%0.fs" % (totalTime / 1000)
	var best_lap_str := ""
	if bestLap != DEFAULT_LAPTIME : best_lap_str = "%0.1fs" % bestLap
	return "%10s %6s %6s %5d" % [
		carName, total_str, best_lap_str, completedLaps
	]
	
static func compare (a: CarRaceData, b:CarRaceData):
	if (a.completedLaps == b.completedLaps):
		if (a.raceCompleted and b.raceCompleted):
			return a.totalTime < b.totalTime
		return a.totalProgress > b.totalProgress
	return a.completedLaps > b.completedLaps
