extends Node

class_name RaceController
@export var total_laps := 5

var cars : Array[Car] = []
var trackCurve : Curve2D
var raceData : Dictionary[Car, CarRaceData] = {}
var started := false
var finished := false
var startTime : float

func setup(carsp, track_curve):
	cars = carsp
	trackCurve = track_curve
	for c in cars:
		raceData[c] = CarRaceData.new(c.carName,c.carNumber,total_laps)
		
func on_lap_completed(info : LapCompleteData):
	print("RaceController on_lap_completed:", info)
	if not started or finished : return
	var car : Car = info.car
	var rd : CarRaceData = raceData[car]
	rd.add_lap_time(info.lapTime)
	pass
	

func _enter_tree():
	EventHub.on_lap_completed.connect(on_lap_completed)
	EventHub.on_race_start.connect(on_race_start)

func on_race_start():
	if started : return 
	started = true 
	finished = false
	startTime = Time.get_ticks_msec()

func _on_race_over_timer_timeout():
	pass # Replace with function body.
