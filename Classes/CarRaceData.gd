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
